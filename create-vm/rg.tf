
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.env-prefix}-rg"
}