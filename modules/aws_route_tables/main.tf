resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = {
    Name = "${var.department}-public-rt"
  }
  depends_on = [var.public_subnet_ids]
}

resource "aws_eip" "eip" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.department}-Eip"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = element(var.public_subnet_ids, count.index)

  tags = {
    Name = "${var.department}-Nat-Gw"
  }
  depends_on = [var.igw_id, var.public_subnet_ids]
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[0].id
  }

  tags = {
    Name = "${var.department}-private-rt"
  }
  depends_on = [var.private_subnet_ids]
}
resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(var.private_subnet_ids, count.index)
  route_table_id = aws_route_table.private_rt.id
}
