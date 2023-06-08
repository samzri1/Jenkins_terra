terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
   client_id = "b348740f-1307-414f-97bb-3ad525451347"
   client_secret = "FRR8Q~YcZSWLDtdM63Ou4fgMIziOx5GCiubeMbMu"
   tenant_id = "7349d3b2-951f-41be-877e-d8ccd9f3e73c"
   skip_provider_registration = true
   features {}
}

resource "azurerm_resource_group" "jktfrg" {
  name     = "test-terra"
  location = "West Europe"
}

resource "azurerm_virtual_network" "jktfvm" {
  name                = "jknetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jktfrg.location
  resource_group_name = azurerm_resource_group.jktfrg.name
}

resource "azurerm_subnet" "jktfsub" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.jktfrg.name
  virtual_network_name = azurerm_virtual_network.jktfvm.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "jktfnic" {
  name                = "example-nic"
  location            = azurerm_resource_group.jktfrg.location
  resource_group_name = azurerm_resource_group.jktfrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jktfsub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jktfvm" {
  name                = "Vmjktf"
  resource_group_name = azurerm_resource_group.jktfrg.name
  location            = azurerm_resource_group.jktfrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "@Azurev69007"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.jktfnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
