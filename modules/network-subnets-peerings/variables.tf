#
# společné "globální"
#

variable "rg_prefix" {
  description = "Prefix pro názvy resource groups"
  type        = string
}

variable "rg_env" {
  description = "Kompozit pro název prostředí (DEV|PROD...)"
  type        = string
}

#
# specifické pro peerings
#

variable "hub_resource_group_name" {
  description = "Name of the hub resource group"
  type        = string
}

variable "spoke1_resource_group_name" {
  description = "Name of the spoke1 resource group"
  type        = string
}

variable "spoke2_resource_group_name" {
  description = "Name of the spoke2 resource group"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "spoke1_vnet_name" {
  description = "Name of the spoke1 virtual network"
  type        = string
}

variable "spoke2_vnet_name" {
  description = "Name of the spoke2 virtual network"
  type        = string
}

variable "hub_vnet_id" {
  description = "ID of the hub virtual network"
  type        = string
}

variable "spoke1_vnet_id" {
  description = "ID of the spoke1 virtual network"
  type        = string
}

variable "spoke2_vnet_id" {
  description = "ID of the spoke2 virtual network"
  type        = string
}
