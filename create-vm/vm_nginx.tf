resource "azurerm_network_interface" "mic" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "${var.env-prefix}-mic-public"
  ip_configuration {
    name                          = "${var.env-prefix}-ip-conf-pub"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.network-subnet-pub.id
    public_ip_address_id          = azurerm_public_ip.network-public-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "mic-sg" {
  network_security_group_id = azurerm_network_security_group.main-security-group.id
  network_interface_id      = azurerm_network_interface.mic.id
}

data "template_file" "cloud-init-nginx" {
  template = file("resources/nginx-cloud-init.yml")
}

resource "azurerm_linux_virtual_machine" "vm_nginx" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.env-prefix}-vm-nginex"
  network_interface_ids = [
    azurerm_network_interface.mic.id
  ]
  admin_username = "titan"
  size           = "Standard_B1ms"

  admin_ssh_key {
    username   = "titan"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  custom_data = base64encode(data.template_file.cloud-init-nginx.rendered)
}