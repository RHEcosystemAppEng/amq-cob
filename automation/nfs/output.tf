output "instance_zone" {
  value = ibm_is_instance.amq_nfs_server.zone
}

output "private_ip" {
  value = ibm_is_instance.amq_nfs_server.primary_network_interface[0].primary_ipv4_address
}

output "public_ip" {
  value = ibm_is_floating_ip.amq_fip.address
}

output "instance_name" {
  value = ibm_is_instance.amq_nfs_server.name
}

output "floating_ip_name" {
  value = ibm_is_floating_ip.amq_fip.name
}
