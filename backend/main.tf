terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
}

provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg",var.prefix)
  location = var.location
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                        = format("%s-kv",var.prefix)
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get","List","Create", "Purge", "Delete", "Recover"
    ]

    secret_permissions = [
      "Get","Set","List",
    ]

    storage_permissions = [
      "Get","Set","List",
    ]
  }
}
resource "azurerm_key_vault_secret" "sa_backend_accesskey" {
  name         = format("%s-backendkey",var.prefix)
  value        = azurerm_storage_account.sa.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_storage_account" "sa" {
  name                     = replace(format("%s-sa",var.prefix),"-","")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "sc" {
  name                  = format("%s-sc",var.prefix)
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}


