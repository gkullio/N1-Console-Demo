output "management_public_ip_address" {
  value = azurerm_linux_virtual_machine.ubuntu_vm.public_ip_address
}
output "ssh_command" {
  value = "ssh ${var.ubuntu-username}@${azurerm_linux_virtual_machine.ubuntu_vm.public_ip_address}"
}
