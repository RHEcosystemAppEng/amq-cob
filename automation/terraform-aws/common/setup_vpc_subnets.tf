# Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.MAIN_CIDR_BLOCK
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = var.TAGS
}

resource "aws_subnet" "all" {
  # Creating all the subnets based on the length of the az names as some regions have 2 zones (e.g. us-west-1)
  count = length(data.aws_availability_zones.zones.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.CIDR_BLOCKS[tostring(count.index)].cidr
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = var.SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - ${count.index}",
    }
  )
}
