# - Azure modules in one shared subscription.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }

}

provider "azurerm" {
  features {}
}



module "Resource_Groups" {
  source               = "./ResourceGroups"
  resource_group_name1 = "networking_Rg"
  resource_group_name2 = "virtual_machine_Rg"
  resource_group_name3 = "Storage_Rg"
  location             = "UK South"
}

module "Networking" {
  source                          = "./Networking"
  nsg_name                        = "Network_NSG"
  vnet_name                       = "Vnet1"
  vnet_address_space              = "10.0.0.0/16"
  subnet_1_address_prefix         = "10.0.1.0/24"
  subnet_2_address_prefix         = "10.0.2.0/28"
  subnet_1_name                   = "vm_subnet"
  subnet_2_name                   = "printer_subnet"
  resource_group_name             = module.Resource_Groups.rg2.name
  location                        = module.Resource_Groups.rg2.location
  nat_gateway_name                = "nat-gateway"
  public_ip_name                  = "nat-gateway-public-ip"
  nsg_resource_group_name         = module.Resource_Groups.rg2.name
  private_dns_zone_name           = "privatednszone.local"
  storage_account_name            = "tfchestates20261029"
  estates_fileshare_name          = "estates-fileshare"
  finance_storage_account_name    = var.finance_storage_account_name
  operations_storage_account_name = var.operations_storage_account_name

}

variable "finance_storage_account_name" {
  type = string
}

variable "operations_storage_account_name" {
  type = string
}
