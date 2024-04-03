resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${lower(random_string.tfstate.result)}"
  resource_group_name      = data.azurerm_resource_group.resource_gp.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true

  tags = {
    environment = "staging"
  }
}



resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
