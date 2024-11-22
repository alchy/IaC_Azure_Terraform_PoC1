#
# společné "globální"
#

variable "rg_prefix" {
  description = "Prefix pro názvy resource groups"
  type        = string
}

variable "rg_env" {
  description = "Kompozit pro název prostředí (DEV|PROD...)"
  type        = string
}

#
# specifické pro VM
#
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the actual asset"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id for NIC"
  type = string
}

#
# Parameters
#
variable "ip_address_reservation" {
  description = "Static od Dynamic IP address. Domain Controllers should have Static"
  default = "Dynamic"
}
  
variable "vm_size" {
  description = "SKU of VM"
  type = string
  default = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username"
  type = string
  default = "administrator"
}

variable "admin_password" {
  description = "Admin password"
  type = string
}

variable "os_disk_size" {
  description = "Disk size"
  type = string
  default = 128
}

