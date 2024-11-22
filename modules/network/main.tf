#
# virtual networks
#

resource "azurerm_virtual_network" "hub" {
  name                = "${var.rg_prefix}-${var.rg_env}-hub-vnet"  # vnet-jn-TST1-hub
  location            = var.hub_location
  resource_group_name = var.hub_resource_group_name
  address_space       = ["10.32.0.0/16"]
  tags                = merge(var.tags, {
    "role" = "hub"
  })
}

resource "azurerm_virtual_network" "spoke1" {
  name                = "${var.rg_prefix}-${var.rg_env}-spoke1-vnet"  # vnet-jn-TST1-spoke1
  location            = var.spoke1_location
  resource_group_name = var.spoke1_resource_group_name
  address_space       = ["10.33.0.0/16"]
  tags                = merge(var.tags, {
    "role" = "spoke1"
  })
}

resource "azurerm_virtual_network" "spoke2" {
  name                = "${var.rg_prefix}-${var.rg_env}-spoke2-vnet"  # vnet-jn-TST1-spoke2
  location            = var.spoke2_location
  resource_group_name = var.spoke2_resource_group_name
  address_space       = ["10.34.0.0/16"]
  tags                = merge(var.tags, 
  { "role" = "spoke2"}
  )
}
