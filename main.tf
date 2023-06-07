# Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  size                 = "Standard_DS1_v2"
  admin_username       = "adminuser"
  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY8sIrQZ/w5Q4N4W0ed8lqEg5B+p+4tkDM7bdg1MwvWmfnrArKAGWKnw+oxJon008YXGq/7fynatuQ52RyZUUnGC9rk5IIL6/+Cld75ex17P01wPAf73baI4/ZiqXXh36dMqlDsacPgrBJOZJ6ml1FAkFOi1mmVVgpENJjOzH27eyQNdRw/0OY5H98b12vdVqBqIN+shc5aIeAvMgPIHHo7S+UfQtSdOrfQ8xcTzbNLnRUJjB7T3r/I34b7eKfcQSiwbf/UaBa7YhQX67I+0oFDID5E7MJQcnuo1Ji1hqWiKOkhi3evXiOwEWIxOf/5XQ7auQr0FQ83wkHKH4K75i0C9kxZRw+bZ3pzL0fmKGQ5P2ii88+6izMTD/GK+xEn+ydGBtMEqMmQSbBQH+HOiJA44YU8MPtv3mHTK6ocqb1pmf5k/JDKpU+xPLeZUrqOV2sH/1yoCdT+TltTTWPdlj5LF3T0upi301ryy0yPVjfc7XE9Frg3Oxo8y+LW5GXl/sPmPUVR7ffU5ByZz8ruUElPyTt1F7Q439T8p1C6dky7T8llebS8ACsSUrA/0V112OEhhkC9NcwJHo7d8TgM6f0Zus3eYJ9A5/Hz58CX4/0IJw5rVxJbUC7OBQql5SbLo8qZ3Of4jtJKJ9Lp1wxZXd8GaonbCeE1tjhiqrjKvwGPw== azureuser@myVM"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

