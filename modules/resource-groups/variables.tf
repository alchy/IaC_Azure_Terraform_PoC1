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

variable "resource_groups" {
  description = "Iterater for map of resource groups with their parameters"
  type  = map(
    object(
      {
        location = string
        name = string
      }
    )
  )
}