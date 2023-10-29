output "vm_pass_output" {
  value = azurerm_key_vault_secret.vm-password.value
}