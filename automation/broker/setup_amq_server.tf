locals {
  tags = concat(var.tags, [
    "zone:${var.MAIN_ZONE}"
  ])
}

resource "ibm_is_instance" "amq_broker" {
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
    security_groups      = [
      var.SECURITY_GROUP_1_ID,
      var.SECURITY_GROUP_2_ID,
      var.DEFAULT_SECURITY_GROUP
    ]
  }

  tags = local.tags

  # the path starts from where terraform is run (cluster2)
  user_data = file(var.USER_DATA_FILE)

  timeouts {
    create = "3m"
  }
}

resource "ibm_is_floating_ip" "amq_fip" {
  name   = "${ibm_is_instance.amq_broker.name}-fip"
  target = ibm_is_instance.amq_broker.primary_network_interface[0].id
  tags   = var.tags
}

