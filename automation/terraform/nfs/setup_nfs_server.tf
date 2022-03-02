locals {
  tags = concat(var.tags, [
    "instance:nfs-server",
    "zone:${var.MAIN_ZONE}"
  ])
}

resource "ibm_is_instance" "amq_nfs_server" {
  name    = var.INSTANCE_NAME
  image   = var.IMAGE.id
  profile = var.INSTANCE_PROFILE

  vpc  = var.VPC.id
  zone = var.MAIN_ZONE
  keys = [var.ssh_key.id]

  primary_network_interface {
    name                 = "eth0"
    subnet               = var.MAIN_SUBNET_ID
    primary_ipv4_address = var.PRIVATE_IP
    allow_ip_spoofing    = false
    security_groups = [
      var.MAIN_SECURITY_GROUP_ID,
      var.DEFAULT_SECURITY_GROUP
    ]
  }

  tags      = local.tags

  timeouts {
    create = "3m"
  }
}

resource "ibm_is_floating_ip" "amq_fip" {
  name   = "${ibm_is_instance.amq_nfs_server.name}-fip"
  target = ibm_is_instance.amq_nfs_server.primary_network_interface[0].id
  tags   = local.tags
}

