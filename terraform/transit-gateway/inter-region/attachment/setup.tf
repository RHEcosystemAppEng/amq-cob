# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC1/2 (on each side)
# ------------------------------------------------------------------

# Create the peering attachment between R1 and R2 Transit Gateways
resource "aws_ec2_transit_gateway_peering_attachment" "r1-r2-peering_attachment" {
  peer_region             = var.REGION_2
  peer_transit_gateway_id = var.R2_TRANSIT_GATEWAY_ID
  transit_gateway_id      = var.R1_TRANSIT_GATEWAY_ID

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX} - peering - inter_region - ${var.NUMBER}"
      Type : "Inter-region"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

# Accept the Peering attachment (from 2nd region)
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "r1-r2-peering_attachment_acceptor" {
  provider = aws.aws_r2

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.r1-r2-peering_attachment.id

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX} - peering acceptor - ${var.NUMBER}"
      Type : "Acceptor in R2"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}
