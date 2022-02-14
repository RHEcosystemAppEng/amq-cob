
resource "ibm_is_vpc" "amq_vpc" {
  name                        = var.VPC_NAME
  address_prefix_management   = "manual"
  default_security_group_name = var.VPC_DEFAULT_SECURITY_GROUP_NAME
  tags                        = local.tags
}

resource "ibm_is_vpc_address_prefix" "amq_address_prefix_1" {
  name = "${ibm_is_vpc.amq_vpc.name}-addr-prefix-01"
  zone = var.ZONE1
  vpc  = ibm_is_vpc.amq_vpc.id
  cidr = var.ZONE1_CIDR
}

resource "ibm_is_vpc_address_prefix" "amq_address_prefix_2" {
  name = "${ibm_is_vpc.amq_vpc.name}-addr-prefix-02"
  zone = var.ZONE2
  vpc  = ibm_is_vpc.amq_vpc.id
  cidr = var.ZONE2_CIDR
}

resource "ibm_is_vpc_address_prefix" "amq_address_prefix_3" {
  name = "${ibm_is_vpc.amq_vpc.name}-addr-prefix-03"
  zone = var.ZONE3
  vpc  = ibm_is_vpc.amq_vpc.id
  cidr = var.ZONE3_CIDR
}

resource "ibm_is_subnet" "amq_subnet_01" {
  depends_on = [
    ibm_is_vpc_address_prefix.amq_address_prefix_1
  ]
  name            = var.SUBNET_1_NAME
  vpc             = ibm_is_vpc.amq_vpc.id
  zone            = var.ZONE1
  ipv4_cidr_block = var.ZONE1_CIDR
  tags            = local.tags
}

resource "ibm_is_subnet" "amq_subnet_02" {
  depends_on = [
    ibm_is_vpc_address_prefix.amq_address_prefix_2
  ]
  name            = var.SUBNET_2_NAME
  vpc             = ibm_is_vpc.amq_vpc.id
  zone            = var.ZONE2
  ipv4_cidr_block = var.ZONE2_CIDR
  tags            = local.tags
}

resource "ibm_is_subnet" "amq_subnet_03" {
  depends_on = [
    ibm_is_vpc_address_prefix.amq_address_prefix_3
  ]
  name            = var.SUBNET_3_NAME
  vpc             = ibm_is_vpc.amq_vpc.id
  zone            = var.ZONE3
  ipv4_cidr_block = var.ZONE3_CIDR
  tags            = local.tags
}
