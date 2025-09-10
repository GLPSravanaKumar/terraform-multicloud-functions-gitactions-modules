variable "alb_sg_id" {
  description = "load balancer sg group id"
}
variable "vpc_id" {
  description = "value to of vpc id"
}
variable "department" {
  description = "value of department tag"
}
variable "public_subnet_ids" {
  description = "public subnet id list"
}
variable "private_subnet_ids" {
  description = "private subnet id list"
}
variable "bucket_name" {
  description = "Name of the storage bucket"
}
variable "lb_type" {
  description = "lb type: ALB, NLB,GLB"
}
variable "aws_instance_ids" {
  description = "Get list of active running instance  Ids"
}
