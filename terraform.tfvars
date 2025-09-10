az_rgname1           = "glps-tf-rg1"
az_location1         = "SouthIndiA"
az_rgname2           = "glps-tf-rg2"
az_location2         = "westindia"
mongodb_proj_name    = "glps_project"
bucket_name          = "uhg-s3-backend-table"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24", "10.0.7.0/24", "10.0.9.0/24", "10.0.11.0/24"]
private_subnet_cidrs = ["10.0.13.0/24", "10.0.15.0/24"]
vpc_cidr_block       = "10.0.0.0/16"
instance_type        = "t2.micro"
ami                  = "ubuntu"
department           = "uhg"
/* dev_public_subnet_cidrs  = ["11.0.1.0/24", "11.0.3.0/24"]
test_public_subnet_cidrs = ["11.0.5.0/24", "11.0.7.0/24"]
qa_public_subnet_cidrs   = ["11.0.9.0/24", "11.0.11.0/24"]
 */
lb_type = "application"
