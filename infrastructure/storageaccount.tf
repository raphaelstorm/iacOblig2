resource "azurerm_storage_account" "sa" {
  name                     = "${local.prefix}${var.sa_name}${var.base_name}${random_string.random_string.result}${local.suffix}"
  resource_group_name      = azurerm_resource_group.rg-infra.name
  location                 = azurerm_resource_group.rg-infra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = "${local.prefix}${var.sc_name}${var.base_name}${local.suffix}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}