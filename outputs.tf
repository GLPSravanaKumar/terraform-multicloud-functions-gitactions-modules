/* output "az" {
  value       = module.vpc.az
  description = "The availability zone where the VPC and subnet are created."
} */
/* output "az_rgname1" {
  description = "Name of the Azure Resource Group 1"
  value       = module.az_resourcegroup.az_rgname1
}
output "az_rgname2" {
  description = "Name of the Azure Resource Group 2"
  value       = module.az_resourcegroup.az_rgname2
} */
/* output "mangodb_project_id" {
  value = data.mongodbatlas_project.existing_project.id
}
output "mangodb_project_name" {
  value = data.mongodbatlas_project.existing_project.name
}
output "mangodb_proj_org_id" {
  value = data.mongodbatlas_project.existing_project.org_id
}
output "mangodb_proj_cluster_count" {
  value = data.mongodbatlas_project.existing_project.cluster_count
}
 */
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.aws_subnets.public_subnet_ids
}
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.aws_subnets.private_subnet_ids
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.aws_vpc.vpc_id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.aws_vpc.vpc_cidr_block
}
output "pub_sg_id" {
  description = "The ID of the public security group"
  value       = module.aws_security_groups.pub_sg_id
}
output "private_sg_id" {
  description = "The ID of the private security group"
  value       = module.aws_security_groups.private_sg_id
}
/* output "keypair_id" {
  value = module.aws_ec2.keypair_id
} */
output "public_route_table_ids" {
  description = "list of public Route table Ids"
  value       = module.aws_route_tables.public_route_table_ids
}
output "private_route_table_ids" {
  description = "list of private Route table Ids"
  value       = module.aws_route_tables.private_route_table_ids
}
output "nat_gw_ids" {
  description = "value of Nat Gatewat Ids"
  value       = module.aws_route_tables.nat_gw_ids
}
output "ami_image_id" {
  description = "launched instance Ami image ID"
  value       = module.aws_ec2.ami_image_id
}
output "aws_instance_id" {
  description = "list of active running instance  Ids"
  value       = module.aws_ec2.aws_instance_id
}
output "public_server_ip" {
  description = "list of instace public server Ids"
  value       = concat(module.aws_ec2.public_server_ip, module.aws_ec2_1.public_server_ip)
}
output "s3_bucket_arn" {
  description = "aws s3 bucket access resource name"
  value       = module.aws_s3_bucket.s3_bucket_arn
}
output "s3_bucket_domain_name" {
  description = "Name of the s3 bucket"
  value       = module.aws_s3_bucket.s3_bucket_domain_name
}
output "private_server_ip" {
  description = "list of instace private server Ids"
  value       = concat(module.aws_ec2.private_server_ip, module.aws_ec2_1.private_server_ip)
}
#OR
/* output "private_server_ips" {
  description = "Private server IPs grouped by module"
  value = {
    ec2  = module.aws_ec2.private_server_ip
    ec2_1 = module.aws_ec2_1.private_server_ip
  }
} */

output "igw_id" {
  description = "internet gateway Id"
  value       = module.aws_igw.igw_id
}
output "peering_id" {
  value = module.aws_vpc_peering.peering_id
}
