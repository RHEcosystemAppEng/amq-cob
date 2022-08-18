
variable "NAME_PREFIX" {}

variable "MAIN_CIDR_BLOCK" {}
variable "CIDR_BLOCKS" {}

variable "TAGS" {}

variable "SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP" {
  default = true
}

variable "CIDR_BLOCK_ALL" {
  default = "0.0.0.0/0"
}

variable "SEC_GRP_FROM_PORT_ALL" {
  default = 0
}

variable "SEC_GRP_TO_PORT_ALL" {
  default = 0
}

variable "SEC_GRP_PROTOCOL_ALL" {
  default = "-1"
}

variable "SEC_GRP_EGRESS_PROTOCOL_ALL" {
  default = "all"
}

variable "SEC_GRP_EGRESS_IPV6_CIDR_BLOCK" {
  default = ["::/0"]
}

variable "BROKER_INGRESS_PORTS" {
  type = list(number)
  // AMQ Console, AMQ Broker and amqp port
  default = [8161, 61616, 5672]
}
