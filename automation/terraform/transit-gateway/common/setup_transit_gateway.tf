data "ibm_resource_group" "group" {
  is_default = "true"
}

resource "ibm_tg_gateway" "interconnect_transit_gateway" {
  name           = var.GATEWAY_NAME
  location       = var.GATEWAY_REGION
  global         = var.GLOBAL
  resource_group = data.ibm_resource_group.group.id

  tags = var.tags

  timeouts {
    create = "10m"
  }
}

resource "ibm_tg_connection" "transit_gateway_conn_1" {
  gateway      = ibm_tg_gateway.interconnect_transit_gateway.id
  network_type = var.NETWORK_TYPE
  name         = var.VPC_1.name
  network_id   = var.VPC_1.resource_crn
}

resource "ibm_tg_connection" "transit_gateway_conn_2" {
  gateway      = ibm_tg_gateway.interconnect_transit_gateway.id
  network_type = var.NETWORK_TYPE
  name         = var.VPC_2.name
  network_id   = var.VPC_2.resource_crn
}
