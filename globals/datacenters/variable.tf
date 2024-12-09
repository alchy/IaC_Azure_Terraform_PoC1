#
# datacenters (variables.tf)
#

variable "datacenters" {
  description = "Primary and secondary datacenter"
  type = object({
    primary = object({
      name     = string
      location = string
      loc      = string
    })
    secondary = object({
      name     = string
      location = string
      loc      = string
    })
  })
  default = {
    primary = {
      name     = "Germany West Central"
      location = "germanywestcentral"
      loc      = "gwc"
    }
    secondary = {
      name     = "Sweden Central"
      location = "swedencentral"
      loc      = "swC"
    }
  }
}
