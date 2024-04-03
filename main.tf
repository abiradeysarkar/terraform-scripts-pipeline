#Creating remote state
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "deploy-vnet-terraform"
        storage_account_name = "nickstoragestate"
        container_name       = "state"
        key                  = "terraform.tfstate"
    }
}

data "azurerm_resource_group" "resource_gp" {
  name = "deploy-vnet-terraform"
}

#Creating the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-new"
  resource_group_name = data.azurerm_resource_group.resource_gp.name
  location            = var.location
  address_space       = ["10.222.0.0/16"]
}
resource "azurerm_subnet" "snet" {
    for_each = var.subnets
    name = each.key
    resource_group_name = data.azurerm_resource_group.resource_gp.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [each.value]
}

resource "azurerm_network_interface" "main" {
  for_each = var.subnets
  name                = "${var.prefix}-nic"
  resource_group_name = data.azurerm_resource_group.resource_gp.name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

#creating Virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.subnets
  name                            = "${var.prefix}-vm"
  resource_group_name             = data.azurerm_resource_group.resource_gp.name
  location                        = var.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "adminuser"
  admin_password                  = "test@12345678"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[each.key].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "random_string" "tfstate" {
  length  = 10
  special = false
}