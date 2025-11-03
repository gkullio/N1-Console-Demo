############## Create Virtual Network and Subnets ##############
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.rg_name}-${random_id.random_id.hex}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]
  depends_on          = [ azurerm_resource_group.rg ]
}

resource "azurerm_subnet" "mgmt" {
  name                 = var.mgmt_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.mgmt_address_space]
}

resource "azurerm_subnet" "int" {
  name                 = var.int_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.int_address_space]
}

# Create public IPs
resource "azurerm_public_ip" "management_pubip" {
  name                = "ubuntu-management_pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  sku                 = "Standard" # the Standard sku is required due to the use of availability zones
  depends_on = [ azurerm_resource_group.rg ]
  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }  
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "management_nsg" {
  name                = "ubuntu-mgmt-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH-WebUI"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "443"]
    source_address_prefix      = var.adminSrcAddr
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.rg ]
  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }  
}

resource "azurerm_network_security_group" "internal_nsg" {
  name                = "ubuntu-internal-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_resource_group.rg ]
  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }  
}  

# Create network interface
resource "azurerm_network_interface" "management_nic" {
  name                = "ubuntu-management-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "managenment_nic_configuration"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management_pubip.id
  }
  depends_on = [ azurerm_resource_group.rg ]
  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }
}

resource "azurerm_network_interface" "internal_nic" {
  name                = "ubuntu-internal-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal_nic_configuration"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.50"
    primary                       = true
  }
  ip_configuration {
    name                          = "internal_nic_plus1"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.100"
  }
  ip_configuration {
    name                          = "internal_nic_plus2"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.101"
  }
  ip_configuration {
    name                          = "internal_nic_plus3"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.102"
  }
  ip_configuration {
    name                          = "internal_nic_oss1"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.103"
  }
  ip_configuration {
    name                          = "internal_nic_oss2"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.104"
  }
  ip_configuration {
    name                          = "internal_nic_oss3"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.105"
  }
  ip_configuration {
    name                          = "internal_nic_waf_test"
    subnet_id                     = azurerm_subnet.int.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.20.2.106"
  }
  depends_on = [ azurerm_resource_group.rg ]
  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "mgmt" {
  network_interface_id      = azurerm_network_interface.management_nic.id
  network_security_group_id = azurerm_network_security_group.management_nsg.id
}

resource "azurerm_network_interface_security_group_association" "internal" {
  network_interface_id      = azurerm_network_interface.internal_nic.id
  network_security_group_id = azurerm_network_security_group.internal_nsg.id
}