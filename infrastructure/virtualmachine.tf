resource "azurerm_public_ip" "pip_vm" {
  name                = "${local.prefix}-${var.pip_name}-${var.base_name}-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg-infra.name
  location            = azurerm_resource_group.rg-infra.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.prefix}-${var.vm_nic_name}-${var.base_name}-${local.suffix}"
  location            = azurerm_resource_group.rg-infra.location
  resource_group_name = azurerm_resource_group.rg-infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_vm.id
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = "${local.prefix}-${var.vm_name}-${var.base_name}-${local.suffix}"
  resource_group_name             = azurerm_resource_group.rg-infra.name
  location                        = azurerm_resource_group.rg-infra.location
  size                            = "Standard_F2"
  admin_username                  = var.vm_username
  admin_password                  = "Placeh0lder-pass" //azurerm_key_vault_secret.vm_password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}