data "ibm_is_vpc" "amq_vpc_dallas_1" {
  name = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${local.DAL_REGION}-1"
}

data "ibm_is_vpc" "amq_vpc_dallas_2" {
  name = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${local.DAL_REGION}-2"
}

data "ibm_is_vpc" "amq_vpc_toronto_1" {
  name     = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${local.TOR_REGION}-1"
  provider = ibm.tor
}

data "ibm_is_vpc" "amq_vpc_toronto_2" {
  name     = "${var.PREFIX}-${local.NETWORK_TYPE_VPC}-${local.TOR_REGION}-2"
  provider = ibm.tor
}
