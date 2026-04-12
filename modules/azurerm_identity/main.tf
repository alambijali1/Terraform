# AKS control plane identity
resource "azurerm_user_assigned_identity" "aks" {
  name                = "mid-aks-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Kubelet identity — used by nodes to pull from ACR and read Key Vault
resource "azurerm_user_assigned_identity" "kubelet" {
  name                = "mid-aks-kubelet-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
