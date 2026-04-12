variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_id" {
  description = "ID of the Virtual Network where resources will be associated"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "aks_dns_zone_name" {
  description = "Name of the Private DNS Zone for AKS API Server"
  type        = string
}