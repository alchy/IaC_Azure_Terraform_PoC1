#
# subnets
#

resource "azurerm_subnet" "hub-common" {
  name                 = "${var.rg_prefix}-${var.rg_env}-hub-common-sn"
  resource_group_name  = var.hub_resource_group_name
  virtual_network_name = var.hub_vnet_name
  address_prefixes     = var.address_prefixes["hub_common"]
}

resource "azurerm_subnet" "hub-private-resolver-inbound" {
  name                 = "${var.rg_prefix}-${var.rg_env}-hub-private-resolver-inbound-sn"
  resource_group_name  = var.hub_resource_group_name
  virtual_network_name = var.hub_vnet_name
  address_prefixes     = var.address_prefixes["hub_private_resolver_inbound"]

  delegation {
    name = "dnsDelegation"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "hub-private-resolver-outbound" {
  name                 = "${var.rg_prefix}-${var.rg_env}-hub-private-resolver-outbound-sn"
  resource_group_name  = var.hub_resource_group_name
  virtual_network_name = var.hub_vnet_name
  address_prefixes     = var.address_prefixes["hub_private_resolver_outbound"]

  delegation {
    name = "dnsDelegation"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "hub-management" {
  name                 = "${var.rg_prefix}-${var.rg_env}-hub-management-sn"
  resource_group_name  = var.hub_resource_group_name
  virtual_network_name = var.hub_vnet_name
  address_prefixes     = var.address_prefixes["hub_management"]
}

resource "azurerm_subnet" "spoke1-common" {
  name                 = "${var.rg_prefix}-${var.rg_env}-spoke1-common-sn"
  resource_group_name  = var.spoke1_resource_group_name
  virtual_network_name = var.spoke1_vnet_name
  address_prefixes     = var.address_prefixes["spoke1_common"]
}

resource "azurerm_subnet" "spoke2-common" {
  name                 = "${var.rg_prefix}-${var.rg_env}-spoke2-common-sn"
  resource_group_name  = var.spoke2_resource_group_name
  virtual_network_name = var.spoke2_vnet_name
  address_prefixes     = var.address_prefixes["spoke2_common"]
}
