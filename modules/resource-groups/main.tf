#
# resrouce groups
#

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
