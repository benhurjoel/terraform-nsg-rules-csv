resource "azurerm_resource_group" "rg" {
  name     = "test-resource-group"
  location = "South EastAsia"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "TestSecurityGroup1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}