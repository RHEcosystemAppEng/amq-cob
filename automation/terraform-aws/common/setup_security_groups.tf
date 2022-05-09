# Security Group(s)

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - default"
    }
  )
}

resource "aws_security_group" "ping_ssh" {
  # Security Group Name (not the same as name of the resource)
  name        = "${var.NAME_PREFIX} - ping_ssh"
  description = "Allows ping and ssh"
  vpc_id      = aws_vpc.main.id

  # Terraform removes the default rule, so lets recreate it
  egress {
    from_port   = var.SEC_GRP_EGRESS_FROM_PORT
    to_port     = var.SEC_GRP_EGRESS_TO_PORT
    protocol    = var.SEC_GRP_EGRESS_PROTOCOL
    cidr_blocks = [var.CIDR_BLOCK_ALL]
  }

  # ssh
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  # ping
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 8
    to_port   = 0
    protocol  = "icmp"
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - Allow ping and ssh"
    }
  )
}

resource "aws_security_group" "amq_broker" {
  name   = "${var.NAME_PREFIX} - amq_broker"
  description = "Allows access to AMQ Broker console as well as default and amqp ports"
  vpc_id = aws_vpc.main.id

  # AMQ Console
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 8161
    to_port   = 8161
    protocol  = "tcp"
  }

  # AMQ Broker
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 61616
    to_port   = 61616
    protocol  = "tcp"
  }

  # AMQ Broker - amqp port
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 5672
    to_port   = 5672
    protocol  = "tcp"
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - brokers"
    }
  )
}

resource "aws_security_group" "amq_router" {
  name   = "${var.NAME_PREFIX} - amq_router"
  description = "Allows access to AMQ router listen port"
  vpc_id = aws_vpc.main.id

  # Router listen address
  ingress {
    cidr_blocks = [var.CIDR_BLOCK_ALL]
    from_port = 5773
    to_port   = 5773
    protocol  = "tcp"
  }

  tags = merge(
    var.TAGS,
    {
      Name : "${var.NAME_PREFIX} - router"
    }
  )
}
