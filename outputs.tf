#
# kontrola proměnných poskytnutých terradorm shellem 
#

output "check_variables" {
  value = var.admin_username != null && var.admin_username != "" ? "Hodnota proměnné admin_username: ${var.admin_username}" :  "[!] Proměnná 'admin_username' není nastavena."
}
