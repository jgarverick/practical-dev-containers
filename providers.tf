terraform {
    required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
        delete_os_disk_on_deletion = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
}