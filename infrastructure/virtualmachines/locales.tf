locals {
  # Create a list of VMs with "public" set to true
  vm_public_list = [for vm in var.vmList : tomap({ "computername" = vm.computername, "username" = vm.username, "public" = vm.public, "size" = vm.size }) if tobool(vm.public) == true]

  # Create a list of VMs with "public" set to false
  vm_private_list = [for vm in var.vmList : tomap({ "computername" = vm.computername, "username" = vm.username, "public" = vm.public, "size" = vm.size }) if tobool(vm.public) == false]
}