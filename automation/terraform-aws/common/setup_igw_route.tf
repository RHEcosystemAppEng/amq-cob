#resource "aws_instance" "main" {
#  ami           = local.REGION_N_AMI[var.REGION].ami_id
#  instance_type = var.INSTANCE_TYPE
#  key_name      = var.ssh_key
#  private_ip    = "${local.IP_NUMBER_PREFIX.0}.10"
#
#  #  for_each = aws_subnet.all
#  subnet_id       = aws_subnet.all["0"].id
#  vpc_security_group_ids = [aws_security_group.ingress-all.id, aws_security_group.ssh.id, aws_default_security_group.default_sg.id]
#
#  tags = local.MAIN_TAGS
#}

## Elastic IP
#resource "aws_eip" "main" {
#  instance = aws_instance.main.id
#  vpc      = true
#
#  tags = local.MAIN_TAGS
#}

# Internet Gateway (to route traffic from internet to VPC)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.TAGS
}

## Custom route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - public"
    }
  )
}

## Naming the default route table
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - default"
    }
  )
}

resource "aws_route_table_association" "main" {
  # Associating all the subnets with main route table - taking the subnets based on zone names
  /*
   Using the subnets (in for_each) fails as subnets is a tuple and even converting them to a map fails
   as the subnets will be dynamically created and terraform doesn't know in advance about "how many".

   ** Following error is thrown by terraform:
     for_each = { for subnet in aws_subnet.all : subnet.id => subnet }

     The "for_each" value depends on resource attributes that cannot be determined until apply, so Terraform
     cannot predict how many instances will be created. To work around this, use the -target argument to
     first apply only the resources that the for_each depends on.
  */

  count = length(data.aws_availability_zones.zones.names)

  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.all[tostring(count.index)].id
}

# Associate VPC with main route table. By default it is associated with the "default" route table
resource "aws_main_route_table_association" "main" {
  route_table_id = aws_route_table.main.id
  vpc_id         = aws_vpc.main.id
}

resource "aws_route" "internet-route" {
  route_table_id = aws_route_table.main.id
  gateway_id = aws_internet_gateway.main.id
  destination_cidr_block = var.CIDR_BLOCK_ALL
}
