#
# output pro network
#

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "spoke1_vnet_id" {
  value = azurerm_virtual_network.spoke1.id
}

output "spoke2_vnet_id" {
  value = azurerm_virtual_network.spoke2.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "spoke1_vnet_name" {
  value = azurerm_virtual_network.spoke1.name
}

output "spoke2_vnet_name" {
  value = azurerm_virtual_network.spoke2.name
}
