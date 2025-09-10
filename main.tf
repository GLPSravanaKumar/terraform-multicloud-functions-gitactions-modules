/* module "az_resourcegroup" {
  source       = "./modules/az_resourcegroup"
  az_rgname1   = var.az_rgname1
  az_location1 = var.az_location1
  az_rgname2   = var.az_rgname2
  az_location2 = var.az_location2
}
module "mongodb" {
  source            = "./modules/mongodb"
  mongodb_proj_name = var.mongodb_proj_name
}
data "mongodbatlas_project" "existing_project" {
  name = var.mongodb_proj_name
}
resource "mongodbatlas_project_ip_access_list" "allow_all" {
  project_id = data.mongodbatlas_project.existing_project.id
  cidr_block = "160.238.72.164/32"
  comment    = "Allow all IPs"
}
module "aws_vpc1" {
  source         = "./modules/aws_vpc"
  vpc_cidr_block = "11.0.0.0/16"
  department     = title("optum")
}
module "aws_vpc_peering" {
  source               = "./modules/aws_vpc_peering"
  vpc_id               = module.aws_vpc.vpc_id
  peer_vpc_id          = module.aws_vpc1.vpc_id
  route_table_id       = module.aws_route_tables.public_route_table_ids
  route_table1_id      = module.aws_route_tables1.public_route_table_ids
  vpc_cidr_block       = module.aws_vpc1.vpc_cidr_block
  vpc1_cidr_block      = module.aws_vpc.vpc_cidr_block
  public_subnet_cidrs  = distinct(var.public_subnet_cidrs)
  public_subnet1_cidrs = distinct(var.private_subnet_cidrs)
}
module "aws_igw1" {
  source     = "./modules/aws_igw"
  vpc_id     = module.aws_vpc1.vpc_id
  department = title("optum")
} 
module "aws_subnets_dev" {
  source = "./modules/aws_subnets"
  #distinct: takes a list and returns a new list with any duplicate elements removed.
  public_subnet_cidrs  = distinct(var.dev_public_subnet_cidrs)
  private_subnet_cidrs = distinct([])
  vpc_id               = module.aws_vpc1.vpc_id
  #title: converts the first letter of each word in the given string to uppercase.
  department = title("optum_dev")
}
module "aws_subnets_test" {
  source = "./modules/aws_subnets"
  #distinct: takes a list and returns a new list with any duplicate elements removed.
  public_subnet_cidrs  = distinct(var.test_public_subnet_cidrs)
  private_subnet_cidrs = distinct([])
  vpc_id               = module.aws_vpc1.vpc_id
  #title: converts the first letter of each word in the given string to uppercase.
  department = title("optum_test")
}
module "aws_subnets_qa" {
  source = "./modules/aws_subnets"
  #distinct: takes a list and returns a new list with any duplicate elements removed.
  public_subnet_cidrs  = distinct(var.qa_public_subnet_cidrs)
  private_subnet_cidrs = distinct([])
  vpc_id               = module.aws_vpc1.vpc_id
  #title: converts the first letter of each word in the given string to uppercase.
  department = title("optum_qa")
}
module "aws_route_tables1" {
  source               = "./modules/aws_route_tables"
  vpc_id               = module.aws_vpc1.vpc_id
  igw_id               = module.aws_igw1.igw_id
  public_subnet_cidrs  = distinct(["11.0.1.0/24", "11.0.3.0/24"])
  private_subnet_cidrs = distinct([])
  public_subnet_ids    = module.aws_subnets_dev.public_subnet_ids
  private_subnet_ids   = module.aws_subnets_dev.private_subnet_ids
  department           = title("optum")
}
module "aws_security_groups1" {
  source     = "./modules/aws_security_groups"
  vpc_id     = module.aws_vpc1.vpc_id
  department = title("optum")
}
module "aws_ec2_dev" {
  source               = "./modules/aws_ec2"
  public_subnet_cidrs  = var.dev_public_subnet_cidrs
  private_subnet_cidrs = distinct([])
  public_subnet_ids    = module.aws_subnets_dev.public_subnet_ids
  pub_sg_id            = module.aws_security_groups1.pub_sg_id
  instance_type        = "t2.micro"
  ami                  = lookup(local.ami_map, var.ami)
  key_name             = aws_key_pair.glpskey.key_name
  private_subnet_ids   = module.aws_subnets_dev.private_subnet_ids
  private_sg_id        = module.aws_security_groups1.private_sg_id
  user_data            = lookup(local.user_data, var.ami)
  department           = title("dev")
}
module "aws_ec2_test" {
  source               = "./modules/aws_ec2"
  public_subnet_cidrs  = var.test_public_subnet_cidrs
  private_subnet_cidrs = distinct([])
  public_subnet_ids    = module.aws_subnets_test.public_subnet_ids
  pub_sg_id            = module.aws_security_groups1.pub_sg_id
  instance_type        = "t2.micro"
  ami                  = lookup(local.ami_map, var.ami)
  key_name             = aws_key_pair.glpskey.key_name
  private_subnet_ids   = module.aws_subnets_test.private_subnet_ids
  private_sg_id        = module.aws_security_groups1.private_sg_id
  user_data            = lookup(local.user_data, var.ami)
  department           = title("test")
}
module "aws_ec2_qa" {
  source               = "./modules/aws_ec2"
  public_subnet_cidrs  = var.qa_public_subnet_cidrs
  private_subnet_cidrs = distinct([])
  public_subnet_ids    = module.aws_subnets_qa.public_subnet_ids
  pub_sg_id            = module.aws_security_groups1.pub_sg_id
  instance_type        = "t2.micro"
  ami                  = lookup(local.ami_map, var.ami)
  key_name             = aws_key_pair.glpskey.key_name
  private_subnet_ids   = module.aws_subnets_qa.private_subnet_ids
  private_sg_id        = module.aws_security_groups1.private_sg_id
  user_data            = lookup(local.user_data, var.ami)
  department           = title("qa")
}
module "local_file" {
  source = "./modules/local_file"
  public_server_ip = concat(module.aws_ec2_ansible-controller.public_server_ip,
    module.aws_ec2_dev.public_server_ip, module.aws_ec2_test.public_server_ip,
  module.aws_ec2_qa.public_server_ip)
  private_server_ip = concat(module.aws_ec2_ansible-controller.private_server_ip,
    module.aws_ec2_dev.private_server_ip, module.aws_ec2_test.private_server_ip,
  module.aws_ec2_qa.private_server_ip)
}*/


module "aws_s3_bucket" {
  source      = "./modules/aws_s3_bucket"
  bucket_name = var.bucket_name
}
module "aws_vpc" {
  source         = "./modules/aws_vpc"
  vpc_cidr_block = var.vpc_cidr_block
  department     = title(var.department)
}
module "aws_igw" {
  source     = "./modules/aws_igw"
  vpc_id     = module.aws_vpc.vpc_id
  department = title(var.department)
}

module "aws_subnets" {
  source = "./modules/aws_subnets"
  #distinct: takes a list and returns a new list with any duplicate elements removed.
  public_subnet_cidrs  = distinct(var.public_subnet_cidrs)
  private_subnet_cidrs = distinct(var.private_subnet_cidrs)
  vpc_id               = module.aws_vpc.vpc_id
  #title: converts the first letter of each word in the given string to uppercase.
  department = title(var.department)
}

module "aws_route_tables" {
  source               = "./modules/aws_route_tables"
  vpc_id               = module.aws_vpc.vpc_id
  igw_id               = module.aws_igw.igw_id
  public_subnet_cidrs  = distinct(var.public_subnet_cidrs)
  private_subnet_cidrs = distinct(var.private_subnet_cidrs)
  public_subnet_ids    = module.aws_subnets.public_subnet_ids
  private_subnet_ids   = module.aws_subnets.private_subnet_ids
  department           = title(var.department)
}

module "aws_security_groups" {
  source     = "./modules/aws_security_groups"
  vpc_id     = module.aws_vpc.vpc_id
  department = title(var.department)
}

module "aws_ec2_ansible-controller" {
  source               = "./modules/aws_ec2"
  public_subnet_cidrs  = distinct(var.public_subnet_cidrs)
  public_subnet_ids    = module.aws_subnets.public_subnet_ids
  pub_sg_id            = module.aws_security_groups.pub_sg_id
  instance_type        = var.instance_type
  ami                  = lookup(local.ami_map, var.ami)
  key_name             = aws_key_pair.glpskey.key_name
  private_subnet_cidrs = distinct(var.private_subnet_cidrs)
  private_subnet_ids   = module.aws_subnets.private_subnet_ids
  private_sg_id        = module.aws_security_groups.private_sg_id
  user_data            = lookup(local.user_data, var.ami)
  department           = title("ansible-controller")
}
module "local_file" {
  source            = "./modules/local_file"
  public_server_ip  = concat(module.aws_ec2_ansible-controller.public_server_ip)
  private_server_ip = concat(module.aws_ec2_ansible-controller.private_server_ip)
}
module "aws_loadbalancer" {
  source             = "./modules/aws_loadbalancer"
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_subnets.private_subnet_ids
  public_subnet_ids  = module.aws_subnets.public_subnet_ids
  lb_type            = var.lb_type
  alb_sg_id          = module.aws_security_groups.alb_sg_id
  bucket_name        = var.bucket_name
  aws_instance_ids   = module.aws_ec2_ansible-controller.aws_instance_ids
  department         = title(var.department)
  depends_on         = [module.aws_ec2_ansible-controller]
}
