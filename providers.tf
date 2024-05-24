terraform {
  required_providers {
    azurerm = {
      
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}
