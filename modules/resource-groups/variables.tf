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
