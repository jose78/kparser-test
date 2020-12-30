resource "azurerm_virtual_network" "network-vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.env-prefix}-network-vnet"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "network-subnet-pub" {
  name                 = "${var.env-prefix}-network-subnet-pub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "network-public-ip" {
  allocation_method   = "Dynamic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.env-prefix}-public-ip"
}
