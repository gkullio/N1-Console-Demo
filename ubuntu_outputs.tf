output "management_public_ip_address" {
  value = azurerm_linux_virtual_machine.kulland_ubuntu_vm.public_ip_address
}
# output "management_public_ip_address_different_resource" {
#   value = azurerm_public_ip.management_pubip.ip_address
# }
# output "dns_a_record_fqdn" {
#   value = trimsuffix(azurerm_dns_a_record.nginx-ubuntu.fqdn, ".")
# }
output "ssh_command" {
  value = "ssh ${var.ubuntu-username}@${azurerm_linux_virtual_machine.kulland_ubuntu_vm.public_ip_address} -i ${var.ssh_key}"
}
output "nginx_instances_public_ip_addresses" {
  value = {
    plus1_public_ip                         = azurerm_public_ip.plus1.ip_address
    plus2_public_ip                         = azurerm_public_ip.plus2.ip_address
    plus3_public_ip                         = azurerm_public_ip.plus3.ip_address
    oss1_public_ip                          = azurerm_public_ip.oss1.ip_address
    oss2_public_ip                          = azurerm_public_ip.oss2.ip_address
    oss3_public_ip                          = azurerm_public_ip.oss3.ip_address
  }
}