resource "azurerm_virtual_network_peering" "hub-spoke1" {
  name                      = "${var.rg_prefix}-${var.rg_env}-hub-spoke1-peering"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke1_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke1-hub" {
  name                      = "${var.rg_prefix}-${var.rg_env}-spoke1-hub-peering"
  resource_group_name       = var.spoke1_resource_group_name
  virtual_network_name      = var.spoke1_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-spoke2" {
  name                      = "${var.rg_prefix}-${var.rg_env}-hub-spoke2-peering"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke2_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke2-hub" {
  name                      = "${var.rg_prefix}-${var.rg_env}-spoke2-hub-peering"
  resource_group_name       = var.spoke2_resource_group_name
  virtual_network_name      = var.spoke2_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
