/* resource "aws_launch_template" "lt" {
  name = "${var.department}-lt"
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 10
    }
  }
  cpu_options {
    core_count       = 2
    threads_per_core = 1
  }
  iam_instance_profile {
    name = var.instance_profile_role
  }
  image_id                             = var.ami
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
  }
  vpc_security_group_ids = [var.pub_sg_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.department}-template"
    }
  }
  user_data = var.user_data
}
 */
