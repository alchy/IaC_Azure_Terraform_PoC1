#
# datacenters (outputs.tf)
#

output "primary" {
  value = var.datacenters.primary
}

output "secondary" {
  value = var.datacenters.secondary
}
