variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}
variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique)"
  type        = string
}

variable "suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "kubelet_principal_id" {
  description = "AKS kubelet identity principal ID (for AcrPull role)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}