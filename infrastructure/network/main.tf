resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg%s", var.prefix, var.suffix)
  location = var.location

  tags = var.common_tags
}

//Security group for only allowing home ip to connect to cloud network, and only over port 22.
resource "azurerm_network_security_group" "sg01" {
  name                = format("%s-sg01%s", var.prefix, var.suffix)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  //Make sure only whitelisted ip's may access the virtual machine subnet.
  dynamic "security_rule" {
    for_each = var.ip_whitelist
    content {
      name                       = format("%s-sg01-allowip%s%s", var.prefix, security_rule.key, var.suffix)
      priority                   = 100 + security_rule.key
      protocol                   = "Tcp"
      direction                  = "Inbound"
      access                     = "Allow"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = security_rule.value
      destination_address_prefix = "*"
    }
  }
  tags = var.common_tags
}

//Define virtual network
resource "azurerm_virtual_network" "vn01" {
  name                = format("%s-vn01%s", var.prefix, var.suffix)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.addressLayout.main]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = var.common_tags
}

//Define subnet for vm's
resource "azurerm_subnet" "vn01-sn_vm" {
  name                 = format("%s-vn01-sn_vm%s", var.prefix, var.suffix)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn01.name
  address_prefixes     = [var.addressLayout.sn_vm]
}

//Associate security group with subnet
resource "azurerm_subnet_network_security_group_association" "sga" {
  subnet_id                 = azurerm_subnet.vn01-sn_vm.id
  network_security_group_id = azurerm_network_security_group.sg01.id
}

//Define subnet for storage accounts
resource "azurerm_subnet" "vn01-sn_sa" {
  name                 = format("%s-vn01-sn01_sa%s", var.prefix, var.suffix)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn01.name
  address_prefixes     = [var.addressLayout.sn_sa]
}

//Reserve as many public ip's as there are public virtual machines.
resource "azurerm_public_ip" "publicip" {

  count = length([for vm in var.vmList : tobool(vm.public) if tobool(vm.public) == true])

  //count               = length([for vm in var.vmList : tobool(vm.public) == true])
  name                = format("%s-publicip%s%s", lower(var.prefix), count.index, var.suffix)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = var.common_tags
}