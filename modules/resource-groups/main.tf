#
# resrouce groups
#

resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups

    name     = replace(each.value.name, "RESOURCE-NAME", each.key) 
    location = each.value.location
    tags     = var.tags
}
