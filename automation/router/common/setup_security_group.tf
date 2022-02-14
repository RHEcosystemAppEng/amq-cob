
# ------------------------------------------------------------
# 3rd security group for AMQ routers
# ------------------------------------------------------------
resource "ibm_is_security_group" "amq_sec_grp_03" {
  name = var.SECURITY_GROUP_NAME
  vpc  = var.VPC_ID
  tags = var.tags
}

resource "ibm_is_security_group_rule" "ingress_router_listener" {
  group      = ibm_is_security_group.amq_sec_grp_03.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_03]

  tcp {
    port_min = 5773
    port_max = 5773
  }
}
