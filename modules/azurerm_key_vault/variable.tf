variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
  
}
variable "suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD Tenant ID used for Key Vault and identity configuration"
  type        = string
}

variable "workload_principal_ids" {
  description = "List of principal IDs that require access to Key Vault"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "kubelet_principal_id" {
  description = "AKS kubelet identity principal ID (for AcrPull role)"
  type        = string
}

variable "kv_admin_principal_id" {
  description = "Principal ID for Key Vault admin access"
  type = string
}