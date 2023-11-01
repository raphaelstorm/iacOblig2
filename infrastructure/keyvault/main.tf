provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "random_string" "string_gen" {
  length  = 4
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg%s", var.prefix, var.suffix)
  location = var.location

  tags = var.common_tags
}

resource "azurerm_key_vault" "keyvault" {
  name                        = format("%s-kv%s", var.prefix, var.suffix)
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = falsea

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Create", "Delete", "Encrypt", "Decrypt", "Sign", "Verify", "WrapKey", "UnwrapKey", "Import", "Update", "Backup", "Restore", "Recover", "Purge"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    storage_permissions = [
      "Get", "Set", "List", "Delete"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "vm-password" {
  depends_on      = [azurerm_key_vault.keyvault]
  name            = format("%s-pswd-${random_string.string_gen.result}%s", var.prefix, var.suffix)
  value           = "gaffa.Teip2"
  content_type    = "password"
  key_vault_id    = azurerm_key_vault.keyvault.id
  expiration_date = "2024-12-30T20:00:00Z"
}

resource "azurerm_key_vault_secret" "sa-accesskey" {
  depends_on      = [azurerm_key_vault.keyvault]
  count           = length(var.sa_info)
  name            = format("%s-saak%s-${random_string.string_gen.result}%s", var.prefix, count.index, var.suffix)
  value           = var.sa_info[count.index].access_key
  key_vault_id    = azurerm_key_vault.keyvault.id
  expiration_date = "2024-12-30T20:00:00Z"
  content_type    = "text/plain"
}