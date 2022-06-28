module "toronto-cluster1" {
  source = "../cluster1"

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER1_PRIVATE_IP_PREFIX

  REGION  = var.REGION
  SSH_KEY = var.SSH_KEY

  AMI_ID        = local.REGION_N_AMI[var.REGION].ami_id
  AMI_NAME      = local.REGION_N_AMI[var.REGION].ami_name
  INSTANCE_TYPE = var.INSTANCE_TYPE

  CIDR_BLOCKS      = local.CLUSTER1_CIDR_BLOCKS
  IP_NUMBER_PREFIX = local.CLUSTER1_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK  = local.CLUSTER1_MAIN_CIDR_BLOCK
  NAME_PREFIX      = local.NAME_PREFIX

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-1",
    }
  )
}

module "toronto-cluster2" {
  source = "../cluster2"

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER2_PRIVATE_IP_PREFIX

  REGION  = var.REGION
  SSH_KEY = var.SSH_KEY

  AMI_ID        = local.REGION_N_AMI[var.REGION].ami_id
  AMI_NAME      = local.REGION_N_AMI[var.REGION].ami_name
  INSTANCE_TYPE = var.INSTANCE_TYPE

  CIDR_BLOCKS      = local.CLUSTER2_CIDR_BLOCKS
  IP_NUMBER_PREFIX = local.CLUSTER2_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK  = local.CLUSTER2_MAIN_CIDR_BLOCK
  NAME_PREFIX      = local.NAME_PREFIX

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-2",
    }
  )
}

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "vpc1-vpc2" {
  peer_vpc_id = module.toronto-cluster1.vpc_id
  vpc_id      = module.toronto-cluster2.vpc_id
  auto_accept = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering",
    }
  )
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-vpc1_to_vpc2" {
  route_table_id            = module.toronto-cluster1.route_table-main-id
  destination_cidr_block    = module.toronto-cluster2.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "peering-vpc2_to_vpc1" {
  route_table_id            = module.toronto-cluster2.route_table-main-id
  destination_cidr_block    = module.toronto-cluster1.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}
