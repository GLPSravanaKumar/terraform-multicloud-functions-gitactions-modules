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
  availability_zone       = data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)]
  # % modulo operator: So even if you have 8 subnets and 6 AZs, Terraform cycles through AZs like
  # Requested 10 subnets but only 6az's in region so we used above + "% length(data.aws_availability_zones.az.names)"
  #(0→us-east-1a, 1→us-east-1b, 2→us-east-1c, 3→us-east-1d, 4→us-east-1e, 5→us-east-1f,6→us-east-1a, 7→us-east-1b, 8→us-east-1c)
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
