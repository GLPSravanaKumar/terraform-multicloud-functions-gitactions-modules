variable "vpc_id" {
  description = "Requester vpc id"
}
variable "peer_vpc_id" {
  description = "Accepter Peering vpc id"
}
variable "route_table_id" {
  description = "route table id"
}
variable "route_table1_id" {
  description = "route table1 id"
}
variable "vpc_cidr_block" {
  description = "VPC Cidr block"
}
variable "vpc1_cidr_block" {
  description = "VPC1 Cidr block"
}
variable "public_subnet_cidrs" {
  description = "subnet cidr count"
}
variable "public_subnet1_cidrs" {
  description = "subnet1 cidr count"
}
