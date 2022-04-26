# Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = local.MAIN_CIDR_BLOCK
  instance_tenancy = "default"

  #  enable_dns_hostnames = true
  #  enable_dns_support = true

  tags = local.MAIN_TAGS
}

## Create subnet(s)
#resource "aws_subnet" "main" {
#  vpc_id     = aws_vpc.main.id
#  cidr_block = local.CIDR_BLOCK_1
#  availability_zone = local.ZONE1
#  map_public_ip_on_launch = var.SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP
#
#  tags = merge(
#    var.tags,
#    {
#      Name: "${local.NAME_PREFIX} - 1"
#    }
#  )
#}
#
#resource "aws_subnet" "second" {
#  vpc_id     = aws_vpc.main.id
#  cidr_block = local.CIDR_BLOCK_2
#  availability_zone = local.ZONE2
#  map_public_ip_on_launch = var.SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP
#
#  tags = merge(
#    var.tags,
#    {
#      Name: "${local.NAME_PREFIX} - 2"
#    }
#  )
#}
#
#resource "aws_subnet" "third" {
#  vpc_id     = aws_vpc.main.id
#  cidr_block = local.CIDR_BLOCK_3
#  availability_zone = local.ZONE3
#  map_public_ip_on_launch = var.SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP
#
#  tags = merge(
#    var.tags,
#    {
#      Name: "${local.NAME_PREFIX} - 3"
#    }
#  )
#}

resource "aws_subnet" "all" {
#  for_each = {
#    "1" : { name : "${local.NAME_PREFIX} - 1", cidr : local.CIDR_BLOCK_1, zone : local.ZONE1 }
#    "2" : { name : "${local.NAME_PREFIX} - 2", cidr : local.CIDR_BLOCK_2, zone : local.ZONE2 }
#    "3" : { name : "${local.NAME_PREFIX} - 3", cidr : local.CIDR_BLOCK_3, zone : local.ZONE3 }
#  }

#  for_each = local.CIDR_N_ZONES

#  for_each = {
#    for key, zone in local.CIDR_N_ZONES : key => zone
#      if contains(local.REGION_N_AMI[var.REGION].cidr_zones, zone)
#  }

#  for_each = data.aws_availability_zones.zones.count
  count = length(data.aws_availability_zones.zones.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.CIDR_BLOCKS[tostring(count.index)].cidr
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = var.SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP

#  count = "${length(data.aws_availability_zones.zones.names)}"
#  vpc_id = "${aws_vpc.myVpc.id}"
#  cidr_block = "10.20.${10+count.index}.0/24"
#  availability_zone = "${data.aws_availability_zones.zones.names[count.index]}"
#  map_public_ip_on_launch = true
#  tags {
#    Name = "PublicSubnet"
#  }

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - ${count.index}"
    }
  )
}
