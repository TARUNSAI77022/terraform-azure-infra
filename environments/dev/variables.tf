variable "name" {
  type        = string
  description = "Name of the VM"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "size" {
  type        = string
  description = "VM size"
}
