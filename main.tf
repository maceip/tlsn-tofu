
data "azurerm_client_config" "current" {}



resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("~/.ssh/${var.resource_group_name_prefix}-sshkey.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.ssh.private_key_pem
}


resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "main" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_group_name_prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.resource_group_name_prefix}-verifier-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.resource_group_name_prefix}-verifier-address"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "prover" {
  name                = "${var.resource_group_name_prefix}-prover-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.prover.id
  }
}

resource "azurerm_public_ip" "prover" {
  name                = "${var.resource_group_name_prefix}-prover-address"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
}


resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.resource_group_name_prefix}-verifier-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_DC1s_v3"
  admin_username      = "ubuntu"
  computer_name       = "${var.resource_group_name_prefix}-verifier-vm"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
        public_key =  tls_private_key.ssh.public_key_openssh 
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

    lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "prover" {
  name                = "${var.resource_group_name_prefix}-prover-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2ms"
  admin_username      = "ubuntu"
  computer_name       = "${var.resource_group_name_prefix}-prover-vm"
  network_interface_ids = [
    azurerm_network_interface.prover.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
        public_key =  tls_private_key.ssh.public_key_openssh 
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

    lifecycle {
    create_before_destroy = true
  }
}

output "verifier_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "prover_ip_address" {
  value = azurerm_public_ip.prover.ip_address
}

resource "ansible_host" "verifier" {
  name                = azurerm_public_ip.main.ip_address
  groups = ["sgx", "verifier"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = "~/.ssh/${var.resource_group_name_prefix}-sshkey.pem",
    ansible_python_interpreter   = "/usr/bin/python3",
  }
}

resource "ansible_host" "prover" {
  name                = azurerm_public_ip.prover.ip_address
  groups = ["sgx","prover"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = "~/.ssh/${var.resource_group_name_prefix}-sshkey.pem",
    ansible_python_interpreter   = "/usr/bin/python3",
  }
}