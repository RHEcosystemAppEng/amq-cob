locals {
  REGION = var.REGION

  ZONE1 = "${local.REGION}-1"
  ZONE2 = "${local.REGION}-2"
  ZONE3 = "${local.REGION}-3"

  CLUSTER1_ZONE1_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.0/18"
  CLUSTER1_ZONE2_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.64.0/18"
  CLUSTER1_ZONE3_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.128.0/18"

  CLUSTER2_ZONE1_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.0.0/18"
  CLUSTER2_ZONE2_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.64.0/18"
  CLUSTER2_ZONE3_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.128.0/18"

  INSTANCE_PROFILE = "bx2-2x8"

  VPC_NAME_PREFIX       = "${var.PREFIX}-vpc-${var.REGION}"
  SUBNET_PREFIX         = "${local.VPC_NAME_PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${local.VPC_NAME_PREFIX}-sec-grp"

  CLUSTER1_VPC_NAME                        = "${local.VPC_NAME_PREFIX}-1"
  CLUSTER1_VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.CLUSTER1_VPC_NAME}-default-sg"

  CLUSTER2_VPC_NAME                        = "${local.VPC_NAME_PREFIX}-2"
  CLUSTER2_VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.CLUSTER2_VPC_NAME}-default-sg"


  # User data scripts are relative to the cluster they're invoked from
  CLUSTER1_ROUTER_01_HUB_USER_DATA_FILE   = "../router/hub-router1/region2-initial_setup-01.sh"
  CLUSTER1_ROUTER_02_SPOKE_USER_DATA_FILE = "../router/spoke-router2/region2-initial_setup-01.sh"

  CLUSTER2_ROUTER_03_SPOKE_USER_DATA_FILE = "../router/spoke-router3/region2-initial_setup-01.sh"

}