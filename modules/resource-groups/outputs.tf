output "hub_resource_group" {
  value = azurerm_resource_group.hub
}

output "spoke1_resource_group" {
  value = azurerm_resource_group.spoke1
}

output "spoke2_resource_group" {
  value = azurerm_resource_group.spoke2
}
