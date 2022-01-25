module "transit-gateway-local-dallas" {
  source = "./common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${var.PREFIX}-${local.DAL_REGION}-local-01"
  GATEWAY_REGION = local.DAL_REGION
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = false

  VPC_1 = data.ibm_is_vpc.amq_vpc_dallas_1
  VPC_2 = data.ibm_is_vpc.amq_vpc_dallas_2

  tags = var.tags
}

module "transit-gateway-local-toronto" {
  source = "./common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${var.PREFIX}-${local.TOR_REGION}-local-01"
  GATEWAY_REGION = local.TOR_REGION
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = false

  VPC_1 = data.ibm_is_vpc.amq_vpc_toronto_1
  VPC_2 = data.ibm_is_vpc.amq_vpc_toronto_2

  tags = var.tags
}


module "transit_gateway_for_cluster-1_n_3" {
  source = "./common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${var.PREFIX}-${local.TOR_REGION}-${local.DAL_REGION}-1"
  GATEWAY_REGION = local.DAL_REGION
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = true

  VPC_1 = data.ibm_is_vpc.amq_vpc_dallas_1
  VPC_2 = data.ibm_is_vpc.amq_vpc_toronto_1

  tags = var.tags
}

module "transit_gateway_for_cluster-2_n_4" {
  source = "./common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${var.PREFIX}-${local.TOR_REGION}-${local.DAL_REGION}-2"
  GATEWAY_REGION = local.TOR_REGION
  NETWORK_TYPE   = local.NETWORK_TYPE_VPC
  GLOBAL         = true

  VPC_1 = data.ibm_is_vpc.amq_vpc_dallas_2
  VPC_2 = data.ibm_is_vpc.amq_vpc_toronto_2

  tags = var.tags
}
