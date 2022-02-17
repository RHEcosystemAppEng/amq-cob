# ------------------------------------------------------------
# 1st security group for ping/ssh connections
# ------------------------------------------------------------
resource "ibm_is_security_group" "amq_sec_grp_01" {
  name = var.SECURITY_GROUP_1_NAME
  vpc  = ibm_is_vpc.amq_vpc.id

  tags = local.tags
}

resource "ibm_is_security_group_rule" "ping" {
  group      = ibm_is_security_group.amq_sec_grp_01.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_01]

  icmp {
    type = 8
  }
}

resource "ibm_is_security_group_rule" "ingress_ssh" {
  group      = ibm_is_security_group.amq_sec_grp_01.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_01]

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "egress_all" {
  group      = ibm_is_security_group.amq_sec_grp_01.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_01]
}



# ------------------------------------------------------------
# 2nd security group for AMQ brokers to accept connections and for UI console
# ------------------------------------------------------------
resource "ibm_is_security_group" "amq_sec_grp_02" {
  name = var.SECURITY_GROUP_2_NAME
  vpc  = ibm_is_vpc.amq_vpc.id
  tags = local.tags
}

resource "ibm_is_security_group_rule" "ingress_amq_console" {
  group      = ibm_is_security_group.amq_sec_grp_02.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_02]

  tcp {
    port_min = 8161
    port_max = 8161
  }
}

resource "ibm_is_security_group_rule" "ingress_amq_conn_1" {
  group      = ibm_is_security_group.amq_sec_grp_02.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_02]

  tcp {
    port_min = 61616
    port_max = 61616
  }
}

resource "ibm_is_security_group_rule" "ingress_amq_conn_2" {
  group      = ibm_is_security_group.amq_sec_grp_02.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  depends_on = [ibm_is_security_group.amq_sec_grp_02]

  tcp {
    port_min = 5672
    port_max = 5672
  }
}
