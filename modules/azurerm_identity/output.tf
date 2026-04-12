output "aks_identity_id" {
  value = azurerm_user_assigned_identity.aks.id
}

output "aks_principal_id" {
  value = azurerm_user_assigned_identity.aks.principal_id
}

output "kubelet_identity_id" {
  value = azurerm_user_assigned_identity.kubelet.id
}

output "kubelet_principal_id" {
  value = azurerm_user_assigned_identity.kubelet.principal_id
}

output "kubelet_client_id" {
  value = azurerm_user_assigned_identity.kubelet.client_id
}

