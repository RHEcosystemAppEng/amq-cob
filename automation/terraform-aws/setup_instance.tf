resource "aws_instance" "main" {
  ami           = local.REGION_N_AMI[var.REGION].ami_id
  instance_type = var.INSTANCE_TYPE
  key_name      = var.ssh_key

  #  for_each = aws_subnet.all
  subnet_id       = aws_subnet.all["0"].id
  security_groups = [aws_security_group.ingress-all.id, aws_security_group.ssh.id]

  tags = local.MAIN_TAGS
}

# Elastic IP
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  vpc      = true

  tags = local.MAIN_TAGS
}

# Internet Gateway (to route traffic from internet to VPC)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.MAIN_TAGS
}

#resource "aws_route_table" "main" {
#  vpc_id = aws_vpc.main.id
#
#  route {
#    cidr_block = var.CIDR_BLOCK_ALL
#    gateway_id = aws_internet_gateway.main.id
#  }
#
#  tags = local.MAIN_TAGS
#}

## Changing the default route table instead of creating a new one
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = var.CIDR_BLOCK_ALL
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - default"
    }
  )
}

resource "aws_route_table_association" "subnet-association" {
  #  for_each = local.CIDR_N_ZONES
#  for_each = aws_subnet.all
#  for_each = { for subnet in aws_subnet.all : subnet.id => subnet }
  count = length(data.aws_availability_zones.zones.names)

  route_table_id = aws_default_route_table.main.id
  subnet_id      = aws_subnet.all[tostring(count.index)].id
#  subnet_id      = each.key
}

#resource "aws_route_table_association" "subnet-association-1" {
#  route_table_id = aws_route_table.main.id
#  subnet_id      = aws_subnet.main.id
#}
#
#resource "aws_route_table_association" "subnet-association-2" {
#  route_table_id = aws_route_table.main.id
#  subnet_id      = aws_subnet.main.id
#}
#
#resource "aws_route_table_association" "subnet-association-3" {
#  route_table_id = aws_route_table.main.id
#  subnet_id      = aws_subnet.main.id
#}
