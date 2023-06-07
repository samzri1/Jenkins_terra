provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" {
  name     = "resource-group-terra"
  location = "West Europe"
}

resource "azurerm_virtual_network" {
  name                = "terrasam-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.name
}

resource "azurerm_subnet"{
  name                 = "azure-subnet"
  resource_group_name  = azurerm_resource_group.name
  virtual_network_name = azurerm_resource_group.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface"{
  name                = "azureterra-nic"
  location            = azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.name

  ip_configuration {
    name                          = "terrasam-config"
    subnet_id                     = azurerm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" {
  name                = "terra-vm"
  location            = azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.name
  size                = "Standard_B1s"

  network_interface_ids = [azurerm_network_interface.id]

  os_disk {
    name              = "terraform-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = "adminuser"

  admin_ssh_key {
    username       = "adminuser"
    public_key     = file("~/.ssh/id_rsa.pub")
  }
}
