#
# Windows VM provisioning
#

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm-windows-nsg" {
    name                = "${var.vm_name}-nsg"
    location            = "${var.resource_group_location}" 
    resource_group_name = "${var.resource_group_name}" 

security_rule {
    name                        = "Allow-RDP"
    priority                    = 1000
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = ["3389"]
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
  }
}

# create public IP
resource "azurerm_public_ip" "vm-windows-public-ip" {
  name                = "${var.vm_name}-pip"
  location            = "${var.resource_group_location}" 
  resource_group_name = "${var.resource_group_name}" 

  allocation_method = "Static" # "Dynamic||Static"
  sku               = "Standard"
}

# Create NIC
resource "azurerm_network_interface" "vm-windows-nic" {
  name                = "${var.vm_name}-nic"
  location            = "${var.resource_group_location}" 
  resource_group_name = "${var.resource_group_name}" 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-windows-public-ip.id
  }
}

# bind NSG to interface 
resource "azurerm_network_interface_security_group_association" "vm-nic-nsg-association" {
  network_interface_id    = azurerm_network_interface.vm-windows-nic.id
  network_security_group_id = azurerm_network_security_group.vm-windows-nsg.id
}


# Create VM
resource "azurerm_windows_virtual_machine" "windows-vm" {
  name                = "${var.vm_name}-vm"
  resource_group_name = "${var.resource_group_name}" 
  location            = "${var.resource_group_location}" 
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"

  #disable_password_authentication = false
  
  network_interface_ids = [azurerm_network_interface.vm-windows-nic.id]

  os_disk {
    name                 = "${var.vm_name}-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size
  }
  
  # az vm image list --location westeurope
  # az vm image list --location westeurope --publisher Canonical --output table (!in table the offer + publisher + sku is important, the key names may you led astray!)
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
 
  additional_capabilities {
    hibernation_enabled = false
  }

}

