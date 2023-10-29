output "rg_name_output" {
  value = azurerm_resource_group.rg.name
}

output "vmSubnet_output" {
  value = azurerm_subnet.vn01-sn_vm.id
}

output "publicip_output" {
  value = [for ip in azurerm_public_ip.publicip : ip.id]
}
