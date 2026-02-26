variable "prefix" {
  description = "Prefix for resources"
  type        = string
  default     = "app3tier"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for VMs and DB"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-test-dev-infra"
}
