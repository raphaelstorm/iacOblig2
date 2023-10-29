locals {
  vmList = flatten([
    for vm in var.vmList : (                                                //Iterate over each entry in the vmList list.
      vm.count != null && can(tonumber(vm.count)) ?                         //Check if the map in each index has a "count" set. 
      [for _ in range(0, tonumber(vm.count)) : merge(var.default_vm, vm)] : //If so, merge that map with the default map as many times as the count was set to.
      [merge(var.default_vm, vm)]                                           //If not, merge the maps once.
    )
  ])

  saList = flatten([ //Make a list of sa's, where each entry has the string value of the sa kind.
    for key, value in var.saMap : [for _ in range(value) : key]
  ])
  suffix = terraform.workspace == "default" ? "" : "-${terraform.workspace}"
}

