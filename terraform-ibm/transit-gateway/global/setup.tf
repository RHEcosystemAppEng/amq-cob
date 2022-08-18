locals {
  NETWORK_TYPE_VPC = "vpc"
  GATEWAY_NAME_PREFIX = "${var.PREFIX}-${var.REGION_1}-${var.REGION_2}"
}

module "transit_gateway_for_cluster-1_n_3" {
  source = "../common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${local.GATEWAY_NAME_PREFIX}-1"
  GATEWAY_REGION = var.REGION_2
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = true

  VPC_1 = data.ibm_is_vpc.amq_vpc_region1_1
  VPC_2 = data.ibm_is_vpc.amq_vpc_region2_1

  tags = var.tags
}

module "transit_gateway_for_cluster-2_n_4" {
  source = "../common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${local.GATEWAY_NAME_PREFIX}-2"
  GATEWAY_REGION = var.REGION_1
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = true

  VPC_1 = data.ibm_is_vpc.amq_vpc_region1_2
  VPC_2 = data.ibm_is_vpc.amq_vpc_region2_2

  tags = var.tags
}
