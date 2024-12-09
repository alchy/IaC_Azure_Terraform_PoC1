output "rg" {
  value = {
    for key, rg in azurerm_resource_group.resource_groups :
    key => {
      name     = rg.name
      location = rg.location
      id       = rg.id
      tags     = rg.tags
    }
  }
}
