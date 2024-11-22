output "hub_resource_group_name" {
  value = azurerm_resource_group.hub.name
}

output "spoke1_resource_group_name" {
  value = azurerm_resource_group.spoke1.name
}

output "spoke2_resource_group_name" {
  value = azurerm_resource_group.spoke2.name
}

output "hub_resource_group_location" {
  value = azurerm_resource_group.hub.location
}

output "spoke1_resource_group_location" {
  value = azurerm_resource_group.spoke1.location
}

output "spoke2_resource_group_location" {
  value = azurerm_resource_group.spoke2.location
}
