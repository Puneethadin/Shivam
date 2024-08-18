resource "azurerm_network_interface" "nic" {
  for_each            = var.VM
  name                = each.value.nicname
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

 ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet-block[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "example" {
  for_each = var.VM
  
  name                = each.value.vmname
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = "Standard_F2"
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids = [resource.azurerm_network_interface.nic[each.key].id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}