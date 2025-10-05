resource "null_resource" "configure_server" {
  count = length(var.public_subnet_cidrs)

  triggers = {
    instance_id = join(",", module.aws_ec2_ansible-controller.aws_instance_ids)
    always_run  = timestamp()
  }

  # Upload requirements.sh
  provisioner "file" {
    source      = "requirements.sh"
    destination = "/tmp/requirements.sh"

    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
    }
  }

  # Upload PRIVATE key to controller server
  /* provisioner "file" {
    source      = pathexpand("~/.ssh/id_ed25519_glpskumar")
    destination = "${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/id_ed25519_glpskumar"

    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
    }
  } */

  # Upload inventory file to controller
  provisioner "file" {
    source      = pathexpand("ansible")
    destination = "${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible"

    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 20}",

      # Install dependencies
      "sudo sed -i 's/\r$//' /tmp/requirements.sh",
      "sudo chmod +x /tmp/requirements.sh",
      "sudo /tmp/requirements.sh",

      # Fix SSH setup
      "mkdir -p ~/.ssh",
      "chmod 700 ~/.ssh",
      # Write the key (from var.private_key if set, else local file content)
      "echo '${var.private_key != "" ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))}' > ~/.ssh/id_ed25519_glpskumar",
      "chmod 600 ~/.ssh/id_ed25519_glpskumar",
      #      "echo 'IdentityFile ~/id_ed25519_glpskumar' >> ~/.ssh/config",

      # Ensure Ansible uses the correct key
      "export ANSIBLE_PRIVATE_KEY_FILE=/home/ubuntu/.ssh/id_ed25519_glpskumar",

      # Ping all servers from inventory
      "ANSIBLE_HOST_KEY_CHECKING=False ansible -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventory_file.ini public_servers -m ping",

      "cd ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible",

      /* "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventory_file.ini install_packages.yml",

      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventories/dev/dev_hosts.ini ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/playbooks/dev.yml",

      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventories/test/test_hosts.ini ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/playbooks/test.yml",

      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventories/qa/qa_hosts.ini ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/playbooks/qa.yml",

      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ami == "ubuntu" ? "/home/ubuntu" : "/home/ec2-user"}/ansible/inventory_file.ini gather_facts.yml" */

    ]

    connection {
      type        = "ssh"
      user        = var.ami == "ubuntu" ? "ubuntu" : "ec2-user"
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
      host        = element(module.aws_ec2_ansible-controller.public_server_ip, count.index)
      timeout     = "2m"
    }
  }

  provisioner "local-exec" {
    command = "echo ${element(module.aws_ec2_ansible-controller.public_server_ip, count.index)} >> uhg_servers_list.txt"
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
      private_key = length(var.private_key) > 0 ? var.private_key : file(pathexpand("~/.ssh/id_ed25519_glpskumar"))
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
