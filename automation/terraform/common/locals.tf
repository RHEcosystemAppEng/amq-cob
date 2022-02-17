locals {
  tags = concat(var.tags, [
    "amq:common"
  ])
}