
output "aks_system_subnet_id" {
  value = azurerm_subnet.aks_system.id
}

output "aks_user_subnet_id" {
  value = azurerm_subnet.aks_user.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}