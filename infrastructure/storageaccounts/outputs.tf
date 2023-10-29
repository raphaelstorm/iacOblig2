output "sa_info" {
  value = [
    for sa in azurerm_storage_account.sa :
    {
      id         = sa.id
      name       = sa.name
      access_key = sa.primary_access_key
    }
  ]
}

output "sa_name" {
  value = azurerm_storage_account.sa[length(azurerm_storage_account.sa) - 1].name
}