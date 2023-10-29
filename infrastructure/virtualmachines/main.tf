//Network interface card to use with virtual machine
resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg%s", var.prefix, var.suffix)
  location = var.location

  tags = var.common_tags
}

/*
//Virtual machines
resource "azurerm_linux_virtual_machine" "vm" {
  count                           = length(var.vmList)
  name                            = format("%s-vm%s", var.prefix, count.index)
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vmList[count.index].size
  admin_username                  = var.vmList[count.index].username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    tobool(var.vmList[count.index].public) ?
    azurerm_network_interface.nic_pub.id :
    azurerm_network_interface.nic_priv.id
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

  tags = var.common_tags
}*/


//Network interface cards for that will have a public ip attached
resource "azurerm_network_interface" "nic_pub" {
  count = length([for vm in var.vmList : tobool(vm.public) if tobool(vm.public) == true])

  name                = format("%s-nic_pub%s%s", var.prefix, count.index, var.suffix)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = format("%s-nic_pub%s-ipconf%s", var.prefix, count.index, var.suffix)
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_list[count.index]
  }

  tags = var.common_tags
}

//Virtual machines
resource "azurerm_linux_virtual_machine" "vm_pub" {
  count                           = length(local.vm_public_list)
  name                            = format("%s-pub_vm%s%s", var.prefix, count.index, var.suffix)
  computer_name                   = local.vm_public_list[count.index].computername
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vmList[count.index].size
  admin_username                  = local.vm_public_list[count.index].username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_pub[count.index].id]


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

  tags = var.common_tags
}

//Nic for non-public vm's
resource "azurerm_network_interface" "nic_priv" {
  count = length([for vm in var.vmList : tobool(vm.public) if tobool(vm.public) == false])

  name                = format("%s-nic_priv%s%s", var.prefix, count.index, var.suffix)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = format("%s-nic_priv%s-ipconf%s", var.prefix, count.index, var.suffix)
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.common_tags
}


//Virtual machines
resource "azurerm_linux_virtual_machine" "vm_priv" {
  count                           = length(local.vm_private_list)
  name                            = format("%s-priv_vm%s%s", var.prefix, count.index, var.suffix)
  computer_name                   = local.vm_private_list[count.index].computername
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vmList[count.index].size
  admin_username                  = local.vm_private_list[count.index].username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_priv[count.index].id]


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

  tags = var.common_tags
}
