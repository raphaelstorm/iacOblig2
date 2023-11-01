terraform {
  required_version = "1.6.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rsl-backend-rg"
    storage_account_name = "rslbackendsa"
    container_name       = "rsl-backend-sc"
    key                  = "lab6_2.terraform.tfstate"
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

module "network" {
  source       = "./network"
  prefix       = "${var.initials}-${var.shortcompanyname}-network"
  suffix       = local.suffix
  location     = var.defaultlocation
  ip_whitelist = var.ip_whitelist
  vmList       = local.vmList //For finding out how many public ip's should be created.
  addressLayout = {
    main  = "10.0.0.0/16"
    sn_vm = "10.0.0.0/24"
    sn_sa = "10.0.1.0/24"
  }
  common_tags = {
    company         = var.companyname
    owner           = "Raphael Storm Larsen"
    billing_account = var.billing_accounts.network
  }
}

module "keyvault" {
  source   = "./keyvault"
  prefix   = "${var.initials}-${var.shortcompanyname}-keyvault"
  suffix   = local.suffix
  location = var.defaultlocation
  sa_info  = module.storageaccounts.sa_info
  sa_name  = module.storageaccounts.sa_name
  common_tags = {
    company         = var.companyname
    owner           = "Raphael Storm Larsen"
    billing_account = var.billing_accounts.storageaccounts
  }
}

module "storageaccounts" {
  source   = "./storageaccounts"
  prefix   = "${var.initials}-${var.shortcompanyname}-storage"
  suffix   = local.suffix
  location = var.defaultlocation
  sa_list  = local.saList
  common_tags = {
    company         = var.companyname
    owner           = "Raphael Storm Larsen"
    billing_account = var.billing_accounts.storageaccounts
  }
}

module "virtualmachines" {
  source         = "./virtualmachines"
  prefix         = "${var.initials}-${var.shortcompanyname}-virtualmachines"
  suffix         = local.suffix
  location       = var.defaultlocation
  public_ip_list = module.network.publicip_output
  subnet         = module.network.vmSubnet_output
  vm_password    = module.keyvault.vm_pass_output
  vmList         = local.vmList
  common_tags = {
    company         = var.companyname
    owner           = "Raphael Storm Larsen"
    billing_account = var.billing_accounts.virtualmachines
  }
}

#1