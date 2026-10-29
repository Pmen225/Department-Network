# - Resource groups in the shared subscription set by the root module.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}


resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name1
  location = var.location
}



resource "azurerm_resource_group" "rg2" {
  name     = var.resource_group_name2
  location = var.location
}


resource "azurerm_resource_group" "rg3" {
  name     = var.resource_group_name3
  location = var.location

}
