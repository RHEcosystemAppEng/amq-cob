
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
      Name : "${var.TAGS.Name} - public"
    }
  )
}

## Naming the default route table
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - default"
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

  # Limiting to 3 max as we don't have the static value to set (in the given map) for 4th entry
  count = length(data.aws_availability_zones.zones.names) <= 2 ? length(data.aws_availability_zones.zones.names) : 2

  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.all[tostring(count.index)].id
  # TODO(SG): try following to see if this works
  # subnet_id      = aws_subnet.all.*.id[count.index]
}

# Associate VPC with main route table. By default it is associated with the "default" route table
#resource "aws_main_route_table_association" "main" {
#  route_table_id = aws_route_table.main.id
#  vpc_id         = aws_vpc.main.id
#}

resource "aws_route" "internet-route" {
  route_table_id = aws_route_table.main.id
  gateway_id = aws_internet_gateway.main.id
  destination_cidr_block = var.CIDR_BLOCK_ALL
}
