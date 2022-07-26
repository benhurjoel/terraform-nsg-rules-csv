locals {
  csv_source = csvdecode(file("./nsg_rules/inbound-web.csv"))
  rules      = { for item, line in local.csv_source : "${item}" => line }
}

resource "azurerm_resource_group" "rg" {
  name     = "test-resource-group"
  location = "South EastAsia"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "random-nsg-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = local.rules
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = azurerm_network_security_group.nsg.name
  access                       = each.value.access
  description                  = each.value.description
  destination_address_prefix   = each.value.destinationAddressPrefix != "" ? each.value.sourcePortRange : null
  destination_address_prefixes = each.value.destinationAddressPrefixes != "" ?  split("," , each.value.destinationAddressPrefixes) : null
  destination_port_range       = each.value.destinationPortRange != "" ? each.value.destinationPortRange : null
  direction                    = each.value.direction
  name                         = each.value.ruleName
  priority                     = each.value.priority
  protocol                     = each.value.protocol
  source_address_prefix        = each.value.sourceAddressPrefix != "" ? each.value.sourceAddressPrefix : null
  source_address_prefixes      = each.value.sourceAddressPrefixes != "" ?  split("," , each.value.sourceAddressPrefixes) : null
  source_port_range            = each.value.sourcePortRange != "" ? each.value.sourcePortRange : null

}      