resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true
  tags = {
    Name = "optum-connection-to-uhc"
  }
}
resource "aws_route" "optum_to_uhc" {
  route_table_id            = var.route_table_id[0]
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Add route in VPC2 route table to reach VPC1
resource "aws_route" "uhc_to_optum" {
  count                     = length(var.route_table1_id)
  route_table_id            = var.route_table1_id[count.index]
  destination_cidr_block    = var.vpc1_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
