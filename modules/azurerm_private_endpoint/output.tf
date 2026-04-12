output "private_endpoint_id" {
  description = "Resource ID of the private endpoint"
  value       = azurerm_private_endpoint.this.id
}

output "private_endpoint_name" {
  description = "Name of the private endpoint"
  value       = azurerm_private_endpoint.this.name
}

output "private_ip_address" {
  description = "Private IP address allocated to the endpoint NIC"
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
