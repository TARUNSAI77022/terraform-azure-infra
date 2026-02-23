variable "name" {
  type        = string
  description = "Name of the subnet"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the VNet"
}

variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes for subnet"
}
