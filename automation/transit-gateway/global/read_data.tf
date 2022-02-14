data "ibm_is_vpc" "amq_vpc_region1_1" {
  name     = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${var.REGION_1}-1"
  provider = ibm.tor
}

data "ibm_is_vpc" "amq_vpc_region1_2" {
  name     = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${var.REGION_1}-2"
  provider = ibm.tor
}

data "ibm_is_vpc" "amq_vpc_region2_1" {
  name = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${var.REGION_2}-1"
}

data "ibm_is_vpc" "amq_vpc_region2_2" {
  name = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${var.REGION_2}-2"
}
