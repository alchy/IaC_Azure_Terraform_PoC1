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
# specifické, předání proměnných jmen rg
#

variable "hub_resource_group_name" {
  description = "Název resource group pro hub"
  type        = string
}

variable "spoke1_resource_group_name" {
  description = "Název resource group pro spoke1"
  type        = string
}

variable "spoke2_resource_group_name" {
  description = "Název resource group pro spoke2"
  type        = string
}

#
# specifické, předání proměnných jmen vnet
#

variable "hub_vnet_name" {
  description = "Název virtuální sítě pro hub"
  type        = string
}

variable "spoke1_vnet_name" {
  description = "Název virtuální sítě pro spoke1"
  type        = string
}

variable "spoke2_vnet_name" {
  description = "Název virtuální sítě pro spoke2"
  type        = string
}

variable "location" {
  description = "Location pro subnety"
  type        = string
}

#
# adresní rozsahy pro jednotlivé sn
#

variable "address_prefixes" {
  description = "Seznam address prefixů pro subnety"
  type        = map(list(string))
  default = {
    hub_common                         = ["10.32.0.0/25"]
    hub_private_resolver_inbound       = ["10.32.0.128/26"]
    hub_private_resolver_outbound      = ["10.32.0.192/26"]
    hub_management                     = ["10.32.1.0/29"]
    spoke1_common                      = ["10.33.0.0/25"]
    spoke2_common                      = ["10.34.0.0/25"]
  }
}
