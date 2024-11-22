#
# output pro network
#

output "hub_vnet" {
  value = azurerm_virtual_network.hub
}

output "spoke1_vnet" {
  value = azurerm_virtual_network.spoke1
}

output "spoke2_vnet" {
  value = azurerm_virtual_network.spoke2
}
