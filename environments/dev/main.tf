terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate SSH key pair for the VM
resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-test-dev-infra"
  location = "South India"
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-test-dev"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  source               = "../../modules/subnet"
  name                 = "snet-test-dev"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "nsg" {
  source              = "../../modules/nsg"
  name                = "nsg-test-dev"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  security_rules = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Jenkins"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Prometheus"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9090"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Grafana"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3000"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = module.subnet.id
  network_security_group_id = module.nsg.id
}

module "vm" {
  source              = "../../modules/vm"
  name                = "vm-test-dev"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.subnet.id
  admin_username      = "adminuser"
  admin_public_key    = tls_private_key.vm_ssh.public_key_openssh
  custom_data         = filebase64("../../scripts/install_tools.sh")
}

output "vm_public_ip" {
  value       = module.vm.public_ip_address
  description = "Public IP address of the Jenkins VM"
}

output "private_key" {
  value     = tls_private_key.vm_ssh.private_key_pem
  sensitive = true
}
