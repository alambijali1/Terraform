variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}


variable "aks_system_subnet_name" {
  description = "Name of the AKS system node pool subnet"
  type        = string
}

variable "aks_system_subnet_prefix" {
  description = "Address prefix(es) for the AKS system node pool subnet"
  type        = list(string)
}

variable "aks_user_subnet_name" {
  description = "Name of the AKS user node pool subnet"
  type        = string
}

variable "aks_user_subnet_prefix" {
  description = "Address prefix(es) for the AKS user node pool subnet"
  type        = list(string)
}

variable "private_subnet_name" {
  description = "Name of the private endpoint subnet"
  type        = string
}

variable "private_subnet_prefix" {
  description = "Address prefix(es) for the private endpoint subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all subnet resources"
  type        = map(string)
  default     = {}
}
