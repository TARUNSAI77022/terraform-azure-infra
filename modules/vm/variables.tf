variable "name" {
  type        = string
  description = "Name of the VM"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "size" {
  type        = string
  description = "VM size"
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  type        = string
  description = "Admin username"
  default     = "azureuser"
}

variable "admin_public_key" {
  type        = string
  description = "Public SSH key"
}

variable "custom_data" {
  type        = string
  description = "Base64 encoded custom data script"
  default     = null
}
