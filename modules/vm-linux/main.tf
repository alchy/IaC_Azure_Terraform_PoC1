#
# Linux VM provisioning
#

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm-linux-nsg" {
  name                = "${var.vm_name}-nsg"
  location            = "${var.resource_group_location}" 
  resource_group_name = "${var.resource_group_name}" 

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# create public IP
resource "azurerm_public_ip" "vm-linux-public_ip" {
  name                = "${var.vm_name}-pip"
  location            = "${var.resource_group_location}" 
  resource_group_name = "${var.resource_group_name}" 

  allocation_method = "Static" # "Dynamic||Static"
  sku               = "Standard"
}

# Create NIC
resource "azurerm_network_interface" "vm-linux-nic" {
  name                = "${var.vm_name}-nic"
  location            = "${var.resource_group_location}" 
  resource_group_name = "${var.resource_group_name}" 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-linux-public_ip.id
  }
}

# bind NSG to interface 
resource "azurerm_network_interface_security_group_association" "vm-nic-nsg-association" {
  network_interface_id    = azurerm_network_interface.vm-linux-nic.id
  network_security_group_id = azurerm_network_security_group.vm-linux-nsg.id
}

# Create VM
resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "${var.vm_name}-vm"
  resource_group_name = "${var.resource_group_name}" 
  location            = "${var.resource_group_location}" 
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"

  disable_password_authentication = false
  
  network_interface_ids = [azurerm_network_interface.vm-linux-nic.id]

  os_disk {
    name                 = "${var.vm_name}-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size
  }
  
  # az vm image list --location westeurope
  # az vm image list --location westeurope --publisher Canonical --output table (!in table the offer + sku is important!)
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  /*
  source_image_reference {
    publisher = "resf"
    offer     = "rockylinux-x86_64"
    sku       = "9-base"
    version   = "latest"
  }
  */

  additional_capabilities {
    hibernation_enabled = false
  }

}
