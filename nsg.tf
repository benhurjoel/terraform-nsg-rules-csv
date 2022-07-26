locals {
  csv_source = csvdecode(file("./nsg_rules/inbound-web.csv"))
  rules_name = local.csv_source[*].ruleName
  rules = {
    for item in local.rules_name : 
    item => [ for line in local.csv_source : line ] 
  }
 

}

resource "azurerm_resource_group" "rg" {
  name     = "test-resource-group"
  location = "South EastAsia"
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = local.rules
  name                = "random-nsg-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = each.value
    content {
    access                                     = security_rule.value.access
    description                                = security_rule.value.description
    destination_address_prefix                 = security_rule.value.destinationAddressPrefix
    destination_port_range                     = security_rule.value.destinationPortRange
    direction                                  = security_rule.value.direction
    name                                       = security_rule.value.ruleName
    priority                                   = security_rule.value.priority
    protocol                                   = security_rule.value.protocol
    source_address_prefix                      = security_rule.value.sourceAddressPrefix
    source_port_range                          = security_rule.value.sourcePortRange
    }
  }


}