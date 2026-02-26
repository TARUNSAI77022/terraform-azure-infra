terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "../../modules/network"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_cidr           = "10.0.0.0/16"
  web_subnet_cidr     = "10.0.1.0/24"
  app_subnet_cidr     = "10.0.2.0/24"
  db_subnet_cidr      = "10.0.3.0/24"
}

module "security" {
  source              = "../../modules/security"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  web_subnet_id       = module.network.web_subnet_id
  app_subnet_id       = module.network.app_subnet_id
  db_subnet_id        = module.network.db_subnet_id
  web_subnet_cidr     = "10.0.1.0/24"
  app_subnet_cidr     = "10.0.2.0/24"
}

module "compute" {
  source              = "../../modules/compute"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  web_subnet_id       = module.network.web_subnet_id
  app_subnet_id       = module.network.app_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "database" {
  source              = "../../modules/database"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_username      = var.admin_username
  app_subnet_id       = module.network.app_subnet_id
}
