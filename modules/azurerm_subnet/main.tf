# AKS System Node Pool Subnet
resource "azurerm_subnet" "aks_system" {
  name                 = var.aks_system_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.aks_system_subnet_prefix
}

# AKS User Node Pool Subnet
resource "azurerm_subnet" "aks_user" {
  name                 = var.aks_user_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.aks_user_subnet_prefix
}

# Private Endpoint Subnet
resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.private_subnet_prefix

  # disables network policies on the subnet
  private_endpoint_network_policies = "Disabled"
}
