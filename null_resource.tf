resource "null_resource" "configure_server" {
  count = length(var.public_subnet_cidrs)
  triggers = {
    instance_id = join(",", module.aws_ec2_ansible-controller.aws_instance_ids)
  }
  provisioner "file" {
    source      = "requirements.sh"
    destination = "/tmp/requirements.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
    }
  }
  provisioner "file" {
    source      = "ansible_inventory_file.ini"
    destination = "/home/ubuntu/ansible_inventory_file.ini"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}", # wait 20s * index
      "sudo sed -i 's/\r$//' /tmp/requirements.sh",
      "sudo sed -i 's/\r$//' /home/ubuntu/ansible_inventory_file.ini",
      "sudo chmod +x /tmp/requirements.sh",
      "sudo chmod +x /home/ubuntu/ansible_inventory_file.ini",
      "sudo /tmp/requirements.sh",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible -i ansible_inventory_file.ini all -m ping"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
      timeout     = "2m"
    }
  }
  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2_ansible-controller.public_server_ip, count.index)} >> uhg_servers_list.txt
    EOH
  }
}
/* 
resource "null_resource" "dev_configure_server" {
  count = length(module.aws_ec2_dev.public_server_ip)
  triggers = {
    instance_id = join(",", module.aws_ec2_dev.aws_instance_id)
  }
  provisioner "file" {
    source      = "dev.sh"
    destination = "/tmp/dev.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_dev.public_server_ip, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}", # wait 20s * index
      "sudo sed -i 's/\r$//' /tmp/dev.sh",
      "sudo chmod +x /tmp/dev.sh",
      "sudo /tmp/dev.sh"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_dev.public_server_ip, count.index)
      timeout     = "2m"
    }
  }

  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2_dev.public_server_ip, count.index)} >> dev_servers_list.txt
    EOH
  }
}

resource "null_resource" "test_configure_server" {
  count = length(module.aws_ec2_test.public_server_ip)
  triggers = {
    instance_id = join(",", module.aws_ec2_test.aws_instance_id)
  }
  provisioner "file" {
    source      = "test.sh"
    destination = "/tmp/test.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_test.public_server_ip, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}", # wait 20s * index
      "sudo sed -i 's/\r$//' /tmp/test.sh",
      "sudo chmod +x /tmp/test.sh",
      "sudo /tmp/test.sh"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_test.public_server_ip, count.index)
      timeout     = "2m"
    }
  }
  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2_test.public_server_ip, count.index)} >> test_servers_list.txt
    EOH
  }
}

resource "null_resource" "qa_configure_server" {
  count = length(module.aws_ec2_qa.public_server_ip)
  triggers = {
    instance_id = join(",", module.aws_ec2_qa.aws_instance_id)
  }
  provisioner "file" {
    source      = "qa.sh"
    destination = "/tmp/qa.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_qa.public_server_ip, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}", # wait 20s * index
      "sudo sed -i 's/\r$//' /tmp/qa.sh",
      "sudo chmod +x /tmp/qa.sh",
      "sudo /tmp/qa.sh"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_qa.public_server_ip, count.index)
      timeout     = "2m"
    }
  }
  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2_qa.public_server_ip, count.index)} >> qa_servers_list.txt
    EOH
  }
}
 */
