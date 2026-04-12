variable "private_endpoint_name" {
  description = "Name of the private endpoint resource (e.g. pe-acr-dev)"
  type        = string
}

variable "location" {
  description = "Azure region where the private endpoint will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the private endpoint NIC will be placed"
  type        = string
}

variable "private_service_connection_name" {
  description = "Name of the private service connection (e.g. psc-acr)"
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the target Azure resource (ACR, Key Vault, etc.)"
  type        = string
}

variable "subresource_names" {
  description = "Sub-resource name(s) for the target resource. e.g. [\"registry\"] for ACR, [\"vault\"] for Key Vault"
  type        = list(string)
}

variable "dns_zone_group_name" {
  description = "Name of the private DNS zone group attached to this endpoint"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs to associate with this private endpoint"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the private endpoint resource"
  type        = map(string)
  default     = {}
}
