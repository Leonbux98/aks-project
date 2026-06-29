terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatebaa324d2"
    container_name       = "tfstate"
    key                  = "aks-project.terraform.tfstate"
  }
}
