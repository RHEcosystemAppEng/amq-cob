# Security Group(s)
resource "aws_security_group" "ssh" {
  # Security Group Name (not the same as name of the resource)
  name        = "${local.NAME_PREFIX} - TLS"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
    #    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  # Terraform removes the default rule
  egress {
    from_port        = var.SEC_GRP_EGRESS_FROM_PORT
    to_port          = var.SEC_GRP_EGRESS_TO_PORT
    protocol         = var.SEC_GRP_EGRESS_PROTOCOL
    cidr_blocks      = [var.CIDR_BLOCK_ALL]
    ipv6_cidr_blocks = var.SEC_GRP_EGRESS_IPV6_CIDR_BLOCK
  }

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - Allow TLS"
    }
  )
}

resource "aws_security_group" "ingress-all" {
  name   = "${local.NAME_PREFIX} - ingress-allow-all"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  # Terraform removes the default rule
  egress {
    from_port        = var.SEC_GRP_EGRESS_FROM_PORT
    to_port          = var.SEC_GRP_EGRESS_TO_PORT
    protocol         = var.SEC_GRP_EGRESS_PROTOCOL
    cidr_blocks      = [var.CIDR_BLOCK_ALL]
    ipv6_cidr_blocks = var.SEC_GRP_EGRESS_IPV6_CIDR_BLOCK
  }

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - Allow TLS"
    }
  )
}