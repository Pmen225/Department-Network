# - Shared network, Windows VMs and department storage. Used tags to identify each department's storage costs.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
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


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}


### - Storage resources

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    department = "Estates"
  }
}


resource "azurerm_storage_share" "estates_fileshare" {
  name               = var.estates_fileshare_name
  storage_account_id = azurerm_storage_account.storage_account.id
  quota              = 500
  access_tier        = "Hot"
}

resource "azurerm_resource_group" "finance" {
  name     = "finance_storage_rg"
  location = "UK South"
}

resource "azurerm_storage_account" "finance" {
  name                     = var.finance_storage_account_name
  resource_group_name      = azurerm_resource_group.finance.name
  location                 = azurerm_resource_group.finance.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    department = "Finance"
  }
}

resource "azurerm_storage_share" "finance" {
  name               = "finance"
  storage_account_id = azurerm_storage_account.finance.id
  quota              = 500
  access_tier        = "Hot"
}

resource "azurerm_resource_group" "operations" {
  name     = "operations_storage_rg"
  location = "UK South"
}

resource "azurerm_storage_account" "operations" {
  name                     = var.operations_storage_account_name
  resource_group_name      = azurerm_resource_group.operations.name
  location                 = azurerm_resource_group.operations.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    department = "Operations"
  }
}

resource "azurerm_storage_share" "operations" {
  name               = "operations"
  storage_account_id = azurerm_storage_account.operations.id
  quota              = 500
  access_tier        = "Hot"
}


# - Department Windows VMs in the shared VM subnet.

resource "azurerm_network_interface" "estates" {
  name                = "estates-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "estates" {
  name                  = "estates-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_D2s_v4"
  admin_username        = "vmadmin"
  admin_password        = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.estates.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "finance" {
  name                = "finance-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "finance" {
  name                  = "finance-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_D2s_v4"
  admin_username        = "vmadmin"
  admin_password        = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.finance.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "operations" {
  name                = "operations-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "operations" {
  name                  = "operations-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_D2s_v4"
  admin_username        = "vmadmin"
  admin_password        = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.operations.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
