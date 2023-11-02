terraform {
  required_version = "1.6.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
      
    }
  }

  backend "azurerm" {
    resource_group_name  = "rsl-backend-rg"
    storage_account_name = "rslbackendsa"
    container_name       = "rsl-backend-sc"
    key                  = "oblig2.terraform.tfstate"
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