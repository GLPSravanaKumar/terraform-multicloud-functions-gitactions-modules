resource "null_resource" "configure_server" {
  count = length(var.public_subnet_cidrs)
  triggers = {
    instance_id = join(",", module.aws_ec2.aws_instance_id)
  }
  provisioner "file" {
    source      = "requirements.sh"
    destination = "/tmp/requirements.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2.public_server_ip, count.index)
    }
  }
  provisioner "file" {
    source      = "ansible_inventory_file.ini"
    destination = "/home/ubuntu/ansible_inventory_file.ini"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2.public_server_ip, count.index)
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
      "ansible -i ansible_inventory_file.ini all -m ping"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2.public_server_ip, count.index)
      timeout     = "2m"
    }
  }

  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2.public_server_ip, count.index)} >> optum_servers_list.txt
    EOH
  }
}

resource "null_resource" "test_configure_server" {
  count = length(module.aws_ec2_1.public_server_ip)
  triggers = {
    instance_id = join(",", module.aws_ec2_1.aws_instance_id)
  }
  provisioner "file" {
    source      = "testenv.sh"
    destination = "/tmp/testenv.sh"
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_1.public_server_ip, count.index)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}", # wait 20s * index
      "sudo sed -i 's/\r$//' /tmp/testenv.sh",
      "sudo chmod +x /tmp/testenv.sh",
      "sudo /tmp/testenv.sh"
    ]
    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = file("~/.ssh/id_ed25519_glpskumar")
      host        = element(module.aws_ec2_1.public_server_ip, count.index)
      timeout     = "2m"
    }
  }

  provisioner "local-exec" {
    command = <<EOH
      echo ${element(module.aws_ec2_1.public_server_ip, count.index)} >> uhc_servers_list.txt
    EOH
  }
}
