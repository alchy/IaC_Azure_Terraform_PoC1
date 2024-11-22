output "hub_common_subnet_id" {
  description = "The ID of the Hub Common Subnet"
  value       = azurerm_subnet.hub-common.id
}

output "hub_private_resolver_inbound_subnet_id" {
  description = "The ID of the Hub Private Resolver Inbound Subnet"
  value       = azurerm_subnet.hub-private-resolver-inbound.id
}

output "hub_private_resolver_outbound_subnet_id" {
  description = "The ID of the Hub Private Resolver Outbound Subnet"
  value       = azurerm_subnet.hub-private-resolver-outbound.id
}

output "hub_management_subnet_id" {
  description = "The ID of the Hub Management Subnet"
  value       = azurerm_subnet.hub-management.id
}

output "spoke1_common_subnet_id" {
  description = "The ID of the Spoke1 Common Subnet"
  value       = azurerm_subnet.spoke1-common.id
}

output "spoke2_common_subnet_id" {
  description = "The ID of the Spoke2 Common Subnet"
  value       = azurerm_subnet.spoke2-common.id
}
