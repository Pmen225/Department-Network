# - Network resources.
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





resource "azurerm_virtual_network" "Vnet1" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]

}

resource "azurerm_subnet" "subnet_1" {
  name                 = var.subnet_1_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = [var.subnet_1_address_prefix]
}

resource "azurerm_subnet" "subnet_2" {
  name                            = var.subnet_2_name
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.Vnet1.name
  address_prefixes                = [var.subnet_2_address_prefix]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet_network_security_group_association" "subnet_2" {
  subnet_id                 = azurerm_subnet.subnet_2.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}





resource "azurerm_network_security_group" "NSG" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.nsg_resource_group_name
}



resource "azurerm_nat_gateway" "NATGateway" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}


resource "azurerm_public_ip" "nat_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}



resource "azurerm_nat_gateway_public_ip_association" "nat_public_ip" {
  nat_gateway_id       = azurerm_nat_gateway.NATGateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_1" {
  subnet_id      = azurerm_subnet.subnet_1.id
  nat_gateway_id = azurerm_nat_gateway.NATGateway.id
}
