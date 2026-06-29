provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "resource_group" {
  source   = "./modules/resource-group"
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  environment         = var.environment
  vnet_address_space  = var.vnet_address_space
  aks_subnet_cidr     = var.aks_subnet_cidr
  tags                = local.common_tags
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = local.common_tags
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  environment         = var.environment
  aks_subnet_id       = module.networking.aks_subnet_id
  node_vm_size        = var.node_vm_size
  min_node_count      = var.min_node_count
  max_node_count      = var.max_node_count
  kubernetes_version  = var.kubernetes_version
  acr_id              = module.acr.id
  tags                = local.common_tags
}
