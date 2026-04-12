output "aks_dns_zone_id" {
  description = "Private DNS Zone ID for AKS (privatelink.<region>.azmk8s.io)"
  value       = azurerm_private_dns_zone.aks.id
}

output "acr_dns_zone_id" {
  description = "Private DNS Zone ID for ACR (privatelink.azurecr.io)"
  value       = azurerm_private_dns_zone.acr.id
}

output "kv_dns_zone_id" {
  description = "Private DNS Zone ID for Key Vault (privatelink.vaultcore.azure.net)"
  value       = azurerm_private_dns_zone.kv.id
}