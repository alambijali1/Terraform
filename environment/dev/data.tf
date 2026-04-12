
data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = module.rg.name

  depends_on = [module.vnet]
}

data "azurerm_subnet" "aks_system" {
  name                 = var.aks_system_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = module.rg.name

  depends_on = [module.subnet]
}

data "azurerm_subnet" "aks_user" {
  name                 = var.aks_user_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = module.rg.name

  depends_on = [module.subnet]
}

data "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = module.rg.name

  depends_on = [module.subnet]
}
