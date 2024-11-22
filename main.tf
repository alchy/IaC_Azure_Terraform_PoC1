# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}


#
# deploy
#

module "resource-groups" {
  source    = "./modules/resource-groups"
  
  # globální proměnné ze souboru "./variables.tf"
  rg_prefix = var.rg_prefix
  rg_env    = var.rg_env
  location  = var.location
  tags      = var.tags
}

module "network" {
  source = "./modules/network"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix = var.rg_prefix
  rg_env    = var.rg_env
  location  = var.location
  tags      = var.tags

  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.hub_resource_group_name
  hub_location               = module.resource-groups.hub_resource_group_location
  
  spoke1_resource_group_name = module.resource-groups.spoke1_resource_group_name
  spoke1_location            = module.resource-groups.spoke1_resource_group_location
  
  spoke2_resource_group_name = module.resource-groups.spoke2_resource_group_name
  spoke2_location            = module.resource-groups.spoke2_resource_group_location
}


module "network-subnets" {
  source = "./modules/network-subnets"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix           = var.rg_prefix
  rg_env              = var.rg_env
  location            = var.location

  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.hub_resource_group_name
  spoke1_resource_group_name = module.resource-groups.spoke1_resource_group_name
  spoke2_resource_group_name = module.resource-groups.spoke2_resource_group_name
  
  # Předání hodnot z výstupů modulu "network"
  hub_vnet_name    = module.network.hub_vnet_name
  spoke1_vnet_name = module.network.spoke1_vnet_name
  spoke2_vnet_name = module.network.spoke2_vnet_name
}


module "network-subnet-peerings" {
  source          = "./modules/network-subnets-peerings"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix           = var.rg_prefix
  rg_env              = var.rg_env
 
  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.hub_resource_group_name
  spoke1_resource_group_name = module.resource-groups.spoke1_resource_group_name
  spoke2_resource_group_name = module.resource-groups.spoke2_resource_group_name

  # Předání hodnot z výstupů modulu "network"
  hub_vnet_name    = module.network.hub_vnet_name
  hub_vnet_id      = module.network.hub_vnet_id

  spoke1_vnet_name = module.network.spoke1_vnet_name
  spoke1_vnet_id   = module.network.spoke1_vnet_id
  
  spoke2_vnet_name = module.network.spoke2_vnet_name
  spoke2_vnet_id   = module.network.spoke2_vnet_id
}

#
# VM RHEL9/ROCKY9/BuBuNTU in SPOKE(s)
#

module "linux-vm1" {
  source                  = "./modules/vm-linux"
  
  # globální proměnné ze souboru "./variables.tf"
  rg_prefix               = var.rg_prefix
  rg_env                  = var.rg_env

  vm_name                 = "vm1"
  resource_group_name     =  module.resource-groups.spoke1_resource_group_name
  resource_group_location =  module.resource-groups.spoke1_resource_group_location
  subnet_id               = module.network-subnets.spoke1_common_subnet_id

  vm_size                 = "Standard_B2s"
  admin_username          = "vzpadmin"
  admin_password          = "cos_ifneo1s*clAF"    # spravovat v Key Vault

  os_disk_size            = 64
  #availability_zone   = "1"
}


module "linux-vm2" {
  source                  = "./modules/vm-linux"
  
  # globální proměnné ze souboru "./variables.tf"
  rg_prefix               = var.rg_prefix
  rg_env                  = var.rg_env

  vm_name                 = "vm2"
  resource_group_name     = module.resource-groups.spoke2_resource_group_name
  resource_group_location = module.resource-groups.spoke2_resource_group_location
  subnet_id               = module.network-subnets.spoke2_common_subnet_id

  vm_size                 = "Standard_B2s"
  admin_username          = "vzpadmin"
  admin_password          = "cos_ifneo1s*clAF"    # spravovat v Key Vault

  #availability_zone   = "1"
}

#
# VM Windows Server w/ DNS in HUB
#

module "windows-vm1" {
  source                  = "./modules/vm-windows"
  
  # globální proměnné ze souboru "./variables.tf"
  rg_prefix               = var.rg_prefix
  rg_env                  = var.rg_env

  vm_name                 = "windows1"
  resource_group_name     = module.resource-groups.hub_resource_group_name
  resource_group_location = module.resource-groups.hub_resource_group_location
  subnet_id               = module.network-subnets.hub_management_subnet_id

  vm_size                 = "Standard_B2s"
  ip_address_reservation  = "Static"
  admin_username          = var.admin_username
  admin_password          = var.admin_password    # spravovat v Key Vault
  
  #availability_zone   = "1"
}


#
# private DNS zone
#

resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "${var.rg_env}.az.point4.cz"
  resource_group_name = module.resource-groups.hub_resource_group_name
}

# Připojení hub VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "hub-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-hub-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.hub_resource_group_name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.hub_vnet_id                                                   # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]  # Zajištění pořadí
}

# Připojení spoke1 VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "spoke1-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-spoke1-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.hub_resource_group_name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.spoke1_vnet_id                                                # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]                                              # Zajištění pořadí
}

# Připojení spoke2 VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "spoke2-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-spoke2-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.hub_resource_group_name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.spoke2_vnet_id                                                # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]                                              # Zajištění pořadí
}