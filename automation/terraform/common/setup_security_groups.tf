# Security Group(s)

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  # Terraform removes the default rule, so lets recreate it
  egress {
    from_port   = var.SEC_GRP_FROM_PORT_ALL
    to_port     = var.SEC_GRP_TO_PORT_ALL
    protocol    = var.SEC_GRP_PROTOCOL_ALL
    cidr_blocks = [var.CIDR_BLOCK_ALL]
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - default"
    }
  )
}

# allow all inbound traffic - this is required for NFS
resource "aws_security_group_rule" "allow_all" {
  from_port                = var.SEC_GRP_FROM_PORT_ALL
  protocol                 = var.SEC_GRP_PROTOCOL_ALL
  security_group_id        = aws_default_security_group.default.id
  source_security_group_id = aws_default_security_group.default.id
  to_port                  = var.SEC_GRP_TO_PORT_ALL
  type                     = "ingress"
}


resource "aws_security_group" "ping_ssh" {
  # Security Group Name (not the same as name of the resource)
  name        = "${var.TAGS.Name} - ping_ssh"
  description = "Allows ping and ssh"
  vpc_id      = aws_vpc.main.id

  # ssh
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # ping
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - Allow ping and ssh"
    }
  )
}

resource "aws_security_group" "amq_broker" {
  name        = "${var.TAGS.Name} - amq_broker"
  description = "Allows access to AMQ Broker console as well as default and amqp ports"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.BROKER_INGRESS_PORTS
    content {
      cidr_blocks = [var.CIDR_BLOCK_ALL]
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
    }
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - brokers"
    }
  )
}

resource "aws_security_group" "amq_router" {
  name        = "${var.TAGS.Name} - amq_router"
  description = "Allows access to AMQ router listen port"
  vpc_id      = aws_vpc.main.id

  # Router listen address
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port   = 5773
    to_port     = 5773
    protocol    = "tcp"
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.TAGS.Name} - router"
    }
  )
}
