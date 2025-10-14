resource "aws_instance" "public_servers" {
  count                       = length(var.public_subnet_cidrs)
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(var.public_subnet_ids, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.pub_sg_id]
  iam_instance_profile        = var.ansible_ecr_instance_profile
  metadata_options {
    http_tokens = "optional"
  }
  user_data = var.user_data
  tags = {
    Name = "${var.department}-public_webserver-${count.index + 1}"
    Role = var.department == "Ansible-Controller" ? "controller" : var.department == "Dev" ? "dev" : var.department == "Test" ? "test" : "unknown"
  }
}

resource "aws_instance" "private_servers" {
  count                       = length(var.private_subnet_cidrs)
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.private_subnet_ids, count.index)
  key_name                    = var.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.private_sg_id]
  user_data                   = var.user_data
  tags = {
    Name = "${var.department}-private_webserver-${count.index + 1}"
    Role = var.department == "Ansible-Controller" ? "controller" : var.department == "Dev" ? "dev" : var.department == "Test" ? "test" : "unknown"
  }
}
