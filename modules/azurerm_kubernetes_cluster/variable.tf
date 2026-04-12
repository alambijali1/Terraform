variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for AKS deployment"
  type        = string
}

variable "suffix" {
  description = "Unique suffix for AKS resource naming"
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
}

variable "aks_system_subnet_id" {
  description = "Subnet ID for AKS system node pool"
  type        = string
}

variable "aks_user_subnet_id" {
  description = "Subnet ID for AKS user node pool"
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS Zone ID for AKS private cluster"
  type        = string
}

variable "aks_identity_id" {
  description = "User Assigned Managed Identity ID for AKS control plane"
  type        = string
}

variable "kubelet_identity_id" {
  description = "User Assigned Managed Identity ID for kubelet"
  type        = string
}

variable "kubelet_client_id" {
  description = "Client ID of kubelet identity"
  type        = string
}

variable "kubelet_object_id" {
  description = "Object ID of kubelet identity"
  type        = string
}

variable "acr_id" {
  description = "Azure Container Registry ID for image pull access"
  type        = string
}

variable "aks_admin_group_object_id" {
  description = "Azure AD group object ID for AKS admin access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to AKS resources"
  type        = map(string)
  default     = {}
}

variable "aks_principal_id" {
  description = "Principal ID for AKS control plane identity"
  type        = string
}