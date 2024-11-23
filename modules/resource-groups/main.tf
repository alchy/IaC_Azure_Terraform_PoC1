#
# resrouce groups
#

module "naming" {
  source = "../terraform-azurerm-naming" 
  prefix                 = [var.rg_prefix, var.rg_env]
  #suffix                 = ["su", "fix"]
}

resource "azurerm_resource_group" "hub" {
  name     = "${var.rg_prefix}-${var.rg_env}-hub-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke1" {
  name     = "${var.rg_prefix}-${var.rg_env}-spoke1-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke2" {
  name     = "${var.rg_prefix}-${var.rg_env}-spoke2-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups

    name     = format("%s-%s", module.naming.resource_group.name, each.key)
    location = each.value.location
    tags     = var.tags
}
