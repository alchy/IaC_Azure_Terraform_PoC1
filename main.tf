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
# set context: datacenters
#
module "datacenters" {
  source = "./globals/datacenters" 
}

#
# set context: environment
#
module "env" {
  source = "./globals/environment" 
  project = ""
  environment = "dev3"
}


#
# set naming context
#
module "naming_pdc" {
  source = "../terraform-azurerm-naming" 
  prefix                 = [var.rg_prefix]
  suffix                 = ["RESOURCE-NAME", module.env.project, 
                            module.env.environment, module.datacenters.primary.loc]
}

module "naming_sdc" {
  source = "../terraform-azurerm-naming" 
  prefix                 = [var.rg_prefix]
  suffix                 = ["RESOURCE-NAME", module.env.project, 
                            module.env.environment, module.datacenters.secondary.loc]
}

#
# deploy
#

module "resource-groups" {

  source    = "./modules/resource-groups"
  
  # globální proměnné
  location  = module.datacenters.primary.location
  tags      = var.tags

  resource_groups = {
    hub    = {location = module.datacenters.primary.location, name = module.naming_pdc.resource_group.name}
    spoke1 = {location = module.datacenters.primary.location, name = module.naming_pdc.resource_group.name}
    spoke2 = {location = module.datacenters.primary.location, name = module.naming_pdc.resource_group.name}
    spoke3 = {location = module.datacenters.primary.location, name = module.naming_sdc.resource_group.name}
    spoke4 = {location = module.datacenters.primary.location, name = module.naming_sdc.resource_group.name}
  }
}


module "network" {
  source = "./modules/network"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix = var.rg_prefix
  rg_env    = var.rg_env
  location  = module.datacenters.primary.location
  tags      = var.tags

  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.rg.hub.name
  hub_location               = module.resource-groups.rg.hub.location
  
  spoke1_resource_group_name = module.resource-groups.rg.spoke1.name
  spoke1_location            = module.resource-groups.rg.spoke1.location
  
  spoke2_resource_group_name = module.resource-groups.rg.spoke2.name
  spoke2_location            = module.resource-groups.rg.spoke2.location
}


module "network-subnets" {
  source = "./modules/network-subnets"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix           = var.rg_prefix
  rg_env              = var.rg_env
  location            = module.datacenters.primary.location

  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.rg.hub.name
  spoke1_resource_group_name = module.resource-groups.rg.spoke1.name
  spoke2_resource_group_name = module.resource-groups.rg.spoke2.name
  
  # Předání hodnot z výstupů modulu "network"
  hub_vnet_name    = module.network.hub_vnet.name
  spoke1_vnet_name = module.network.spoke1_vnet.name
  spoke2_vnet_name = module.network.spoke2_vnet.name
}

module "network-subnet-peerings" {
  source          = "./modules/network-subnets-peerings"

  # globální proměnné ze souboru "./variables.tf"
  rg_prefix           = var.rg_prefix
  rg_env              = var.rg_env
 
  # Předání hodnot z výstupů modulu "resource-groups"
  hub_resource_group_name    = module.resource-groups.rg.hub.name
  spoke1_resource_group_name = module.resource-groups.rg.spoke1.name
  spoke2_resource_group_name = module.resource-groups.rg.spoke2.name

  # Předání hodnot z výstupů modulu "network"
  hub_vnet_name    = module.network.hub_vnet.name
  hub_vnet_id      = module.network.hub_vnet.id

  spoke1_vnet_name = module.network.spoke1_vnet.name
  spoke1_vnet_id   = module.network.spoke1_vnet.id
  
  spoke2_vnet_name = module.network.spoke2_vnet.name
  spoke2_vnet_id   = module.network.spoke2_vnet.id
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
  resource_group_name     = module.resource-groups.rg.spoke1.name
  resource_group_location = module.resource-groups.rg.spoke1.location
  subnet_id               = module.network-subnets.spoke1_common_subnet_id

  vm_size                 = "Standard_B2s"
  admin_username          = var.admin_username
  admin_password          = var.admin_password    # spravovat v Key Vault

  os_disk_size            = 64
  #availability_zone   = "1"
}


module "linux-vm2" {
  source                  = "./modules/vm-linux"
  
  # globální proměnné ze souboru "./variables.tf"
  rg_prefix               = var.rg_prefix
  rg_env                  = var.rg_env

  vm_name                 = "vm2"
  resource_group_name     = module.resource-groups.rg.spoke2.name
  resource_group_location = module.resource-groups.rg.spoke2.location
  subnet_id               = module.network-subnets.spoke2_common_subnet_id

  vm_size                 = "Standard_B2s"
  admin_username          = var.admin_username
  admin_password          = var.admin_password    # spravovat v Key Vault

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
  resource_group_name     = module.resource-groups.rg.hub.name
  resource_group_location = module.resource-groups.rg.hub.location
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
  resource_group_name = module.resource-groups.rg.hub.name
}

# Připojení hub VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "hub-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-hub-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.rg.hub.name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.hub_vnet.id                                                   # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]  # Zajištění pořadí
}

# Připojení spoke1 VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "spoke1-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-spoke1-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.rg.hub.name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.spoke1_vnet.id                                                # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]                                              # Zajištění pořadí
}

# Připojení spoke2 VNet do DNS zóny
resource "azurerm_private_dns_zone_virtual_network_link" "spoke2-link" {
  name                   = "${var.rg_prefix}-${var.rg_env}-spoke2-vnet-link"
  private_dns_zone_name  = azurerm_private_dns_zone.private-dns-zone.name                               # Název DNS zóny
  resource_group_name    = module.resource-groups.rg.hub.name                               # Název resource group, kde je DNS zóna
  virtual_network_id     = module.network.spoke2_vnet.id                                                # ID hub VNet
  registration_enabled   = true                                                                         # Povolit automatickou registraci DNS záznamů pro připojené VM
  depends_on = [azurerm_private_dns_zone.private-dns-zone]                                              # Zajištění pořadí
}

#
# virtual wan
# https://jakewalsh.co.uk/deploying-azure-virtual-wan-using-terraform/

# vwan
resource "azurerm_virtual_wan" "vwan" {
  name                = "vWAN"
  resource_group_name = module.resource-groups.rg.hub.name
  location            = module.resource-groups.rg.hub.location
}

# Virtual WAN Hubs
resource "azurerm_virtual_hub" "region1-vhub1" {
  name                = "hub-${module.datacenters.primary.loc}-vWAN"
  resource_group_name = module.resource-groups.rg.hub.name
  location            = module.datacenters.primary.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.100.0.0/16"
}
resource "azurerm_virtual_hub" "region2-vhub1" {
  name                = "hub-${module.datacenters.secondary.loc}-vWAN"
  resource_group_name = module.resource-groups.rg.hub.name
  location            = module.datacenters.secondary.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.101.0.0/16"
}