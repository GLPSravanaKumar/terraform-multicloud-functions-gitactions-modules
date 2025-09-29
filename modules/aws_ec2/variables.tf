variable "instance_type" {
  description = "Type of EC2 instance"
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}
variable "pub_sg_id" {
  description = "value of public security group id"
}
variable "private_sg_id" {
  description = "value of public security group id"
}
variable "public_subnet_cidrs" {
  description = "public subnet cidr values"
}
variable "ami" {
  description = "AMI ID for the EC2 instance"
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "private subnet cidr values"
}
variable "key_name" {
  description = "instance access key name"
}
variable "user_data" {
  description = "user data to attaced to instances"
}
variable "department" {
  description = "value of department tag"
}
variable "ansible_ecr_instance_profile" {
  description = "instance profile for ansible servers get ecr readonly access"
}
