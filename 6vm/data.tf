data "azurerm_subnet" "subnet-block" {
  for_each             = var.VM
  name                 = "pusub1"
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

