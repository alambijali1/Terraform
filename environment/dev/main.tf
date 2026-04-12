# Resource Group
module "rg" {
  source              = "../../modules/azurerm_resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

# Random suffix 
module "random" {
  source = "../../modules/azurerm_random"
}

# Virtual Network 

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_virtual_network"
  vnet_name           = var.vnet_name
  location            = module.rg.location
  resource_group_name = module.rg.name
  vnet_address_space  = var.vnet_address_space
  tags                = local.tags
}

# Subnets 

module "subnet" {
  depends_on          = [module.rg, module.vnet]
  source              = "../../modules/azurerm_subnet"
  resource_group_name = module.rg.name
  vnet_name           = module.vnet.vnet_name

  aks_system_subnet_name   = var.aks_system_subnet_name
  aks_system_subnet_prefix = var.aks_system_subnet_prefix
  aks_user_subnet_name     = var.aks_user_subnet_name
  aks_user_subnet_prefix   = var.aks_user_subnet_prefix
  private_subnet_name      = var.private_subnet_name
  private_subnet_prefix    = var.private_subnet_prefix
  tags                     = local.tags
}

# Managed Identities 
module "identity" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_identity"
  resource_group_name = module.rg.name
  location            = module.rg.location
  suffix              = var.suffix
  tags                = local.tags
}

# Private DNS Zones 

module "dns" {
  depends_on          = [module.rg, module.vnet]
  source              = "../../modules/azurerm_private_dns"
  resource_group_name = module.rg.name
  location            = module.rg.location
  vnet_id             = data.azurerm_virtual_network.vnet.id
  aks_dns_zone_name   = local.aks_dns_zone_name
  tags                = local.tags
}

# ACR 
module "acr" {
  depends_on           = [module.rg, module.vnet, module.dns, module.identity]
  source               = "../../modules/azurerm_acr"
  acr_name             = local.acr_name
  resource_group_name  = module.rg.name
  location             = module.rg.location
  suffix               = var.suffix
  kubelet_principal_id = module.identity.kubelet_principal_id
  tags                 = local.tags
}

# Key Vault
module "keyvault" {
  depends_on            = [module.rg, module.vnet, module.dns, module.identity]
  source                = "../../modules/azurerm_key_vault"
  keyvault_name         = local.keyvault_name
  resource_group_name   = module.rg.name
  location              = module.rg.location
  suffix                = var.suffix
  tenant_id             = data.azurerm_client_config.current.tenant_id
  kubelet_principal_id  = module.identity.kubelet_principal_id
  kv_admin_principal_id = data.azurerm_client_config.current.object_id
  tags                  = local.tags
}

# AKS Cluster

module "aks" {
  depends_on          = [module.rg, module.vnet, module.subnet, module.dns, module.identity, module.acr]
  source              = "../../modules/azurerm_kubernetes_cluster"
  resource_group_name = module.rg.name
  location            = module.rg.location
  suffix              = var.suffix

  aks_system_subnet_id = data.azurerm_subnet.aks_system.id
  aks_user_subnet_id   = data.azurerm_subnet.aks_user.id

  private_dns_zone_id = module.dns.aks_dns_zone_id

  aks_identity_id     = module.identity.aks_identity_id
  aks_principal_id    = module.identity.aks_principal_id
  kubelet_identity_id = module.identity.kubelet_identity_id
  kubelet_client_id   = module.identity.kubelet_client_id
  kubelet_object_id   = module.identity.kubelet_principal_id

  acr_id                    = module.acr.acr_id
  kubernetes_version        = var.kubernetes_version
  aks_admin_group_object_id = var.aks_admin_group_object_id
  tags                      = local.tags
}

# Private Endpoint: ACR 

module "pe_acr" {
  depends_on                      = [module.acr, module.subnet, module.dns]
  source                          = "../../modules/azurerm_private_endpoint"
  private_endpoint_name           = "pe-acr-${var.suffix}"
  location                        = module.rg.location
  resource_group_name             = module.rg.name
  subnet_id                       = data.azurerm_subnet.private.id
  private_service_connection_name = "psc-acr"
  private_connection_resource_id  = module.acr.acr_id
  subresource_names               = ["registry"]
  dns_zone_group_name             = "acr-dns-group"
  private_dns_zone_ids            = [module.dns.acr_dns_zone_id]
  tags                            = local.tags
}

# Private Endpoint: Key Vault 

module "pe_keyvault" {
  depends_on                      = [module.keyvault, module.subnet, module.dns]
  source                          = "../../modules/azurerm_private_endpoint"
  private_endpoint_name           = "pe-kv-${var.suffix}"
  location                        = module.rg.location
  resource_group_name             = module.rg.name
  subnet_id                       = data.azurerm_subnet.private.id
  private_service_connection_name = "psc-kv"
  private_connection_resource_id  = module.keyvault.key_vault_id
  subresource_names               = ["vault"]
  dns_zone_group_name             = "kv-dns-group"
  private_dns_zone_ids            = [module.dns.kv_dns_zone_id]
  tags                            = local.tags
}
