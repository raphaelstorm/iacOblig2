resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg%s", var.prefix, var.suffix)
  location = var.location

  tags = var.common_tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "sa" {
  count                    = length(var.sa_list)
  name                     = replace(lower(format("%s-sa%s%s", var.prefix, count.index, var.suffix)), "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = var.sa_list[count.index]
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  tags = var.common_tags
}