variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true 
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "suffix" {
  description = "Short unique suffix appended to resource names"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type = list(string)
}

variable "aks_system_subnet_name" {
  description = "Name of the AKS system subnet"
  type = string
}

variable "aks_system_subnet_prefix" {
  description = "Address prefix for the AKS system subnet"
  type = list(string)
}

variable "aks_user_subnet_name" {
  description = "Name of the AKS user subnet"
  type = string
}

variable "aks_user_subnet_prefix" {
  description = "Address prefix for the AKS user subnet"
  type = list(string)
}

variable "private_subnet_name" {
  description = "Name of the private subnet for AKS"
  type = string
}

variable "private_subnet_prefix" {
  description = "Address prefix for the private subnet"
  type = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
}

variable "aks_admin_group_object_id" {
  description = "AAD group object ID granted Cluster Admin RBAC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

}
