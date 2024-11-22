#
# variables
#

variable "location" {
  description = "Region pro resource group"
  type        = string
}

variable "tags" {
  description = "Tagy pro resource group"
  type        = map(string)
}

variable "rg_prefix" {
  description = "Prefix pro názvy resource groups"
  type        = string
}

variable "rg_env" {
  description = "Kompozit pro název prostředí (např. DEV, PROD)"
  type        = string
}

#
# specifické proměnné pro network vrstvu
#

variable "hub_resource_group_name" {
  description = "Resource group name for hub"
  type        = string
}

variable "spoke1_resource_group_name" {
  description = "Resource group name for spoke1"
  type        = string
}

variable "spoke2_resource_group_name" {
  description = "Resource group name for spoke2"
  type        = string
}

variable "hub_location" {
  description = "Location for hub resource group"
  type        = string
}

variable "spoke1_location" {
  description = "Location for spoke1 resource group"
  type        = string
}

variable "spoke2_location" {
  description = "Location for spoke2 resource group"
  type        = string
}
