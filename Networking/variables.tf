# - Network inputs.
variable "nsg_name" {
  description = "Name of the NSG"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the virtual network and NAT gateway"
  type        = string
}

variable "nsg_resource_group_name" {
  description = "Name of the NSG resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the vnet"
  type        = string
}

variable "subnet_1_name" {
  description = "VM subnet name"
  type        = string
}

variable "subnet_2_name" {
  description = "Printer subnet name"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name of the nat gateway"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the NAT gateway public IP"
  type        = string
}

variable "vnet_address_space" {
  description = "Address range for the virtual network"
  type        = string
}

variable "subnet_1_address_prefix" {
  description = "Address range for the VM subnet"
  type        = string
}

variable "subnet_2_address_prefix" {
  description = "Address range for the printer subnet"
  type        = string
}


variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
}


variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "estates_fileshare_name" {
  description = "Name of the Estates file share"
  type        = string
}

variable "finance_storage_account_name" {
  description = "Name of the Finance storage account"
  type        = string
}

variable "operations_storage_account_name" {
  description = "Name of the Operations storage account"
  type        = string
}
