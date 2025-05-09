output "ssh_private_key" {
  value       = join("", tls_private_key.default.*.private_key_openssh)
  sensitive   = true
  description = "The value of the private SSH key generated for the container."
}

output "network" {
  value       = proxmox_lxc.default.network
  description = "The network interfaces created for the container."
}

output "id" {
  value       = proxmox_lxc.default.id
  description = "Id of the created Proxmox LXC container."
}
