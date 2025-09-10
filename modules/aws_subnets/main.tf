data "aws_availability_zones" "az" {
  state = "available"

  # exclude or blacklist particular az
  # exclude_names = ["ap-south-1b"]
}
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = var.vpc_id
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name   = "${var.department}-pubsubnet ${count.index + 1}"
    subnet = "Public Subnet-${count.index + 1}"
  }
  depends_on = [var.vpc_id]
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch = false
  vpc_id                  = var.vpc_id
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name   = "${var.department}-pvtsubnet ${count.index + 1}"
    subnet = "Private Subnet-${count.index + 1}"
  }
  depends_on = [var.vpc_id]
}
