# Create virtual machine
resource "azurerm_linux_virtual_machine" "kulland_ubuntu_vm" {
  name                  = var.ubuntu_name
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.management_nic.id, azurerm_network_interface.internal_nic.id]
  size                  = var.ubuntu_instance_size
  #custom_data           = filebase64("${path.module}/onboard.tpl", {
  #  docker_compose      = file("${path.module}/../docker-compose.yml")  
  #})
  custom_data = base64encode(templatefile("${path.module}/onboard.tpl", {
    docker_compose = file("${path.module}/Docker/docker-compose.yml"), 
      variables_env = file("${path.module}/Docker/variables.env"),
        nginx_jwt = file("${path.module}/secrets/nginx-repo.jwt"),
      JWT="${var.jwt_secret}",
      TOKEN="${var.dp_token}",
      NAME="${var.nginx_instance_prefix}",
      REPO_URL="${var.repo_url}",
      BRANCH="${var.branch}",
      WORKDIR="${var.workdir}",
      USER="${var.ubuntu-username}"
  }))
  
  os_disk {
    name                 = "myUbuntuDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = var.ubuntu-hostname
  admin_username = var.ubuntu-username
  admin_password = var.ubuntu-password

  admin_ssh_key {
    username   = var.ubuntu-username
    public_key = file(var.ssh_key)
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  tags = {
    owner = var.resourceOwner
    email = var.resourceOwnerEmail
  }  
}