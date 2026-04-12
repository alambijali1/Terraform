variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "RG name"
  type        = string
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  
}