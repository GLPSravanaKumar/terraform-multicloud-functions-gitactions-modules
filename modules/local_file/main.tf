resource "local_file" "company" {
  content  = "Hello Welcome this organisation"
  filename = "${path.root}/optum_induction.txt"
}

/* resource "local_file" "ansible_inventory_file" {
  content = templatefile("${path.root}/template.tpl",
    {
      public_server_1 = var.public_server_ip[0]
      public_server_2 = var.public_server_ip[1]
      public_server_3 = var.public_server_ip[2]
      public_server_4 = var.public_server_ip[3]
    }
  )
  filename = "${path.root}/ansible_inventory_file"
} */

resource "local_file" "ansible_inventory_file" {
  content = templatefile("${path.root}/template.tpl",
    {
      ansible_controller_public_servers = var.ansible_controller_public_servers
      dev_public_servers                = var.dev_public_servers
      test_public_servers               = var.test_public_servers
      qa_public_servers                 = var.qa_public_servers

      public_servers  = var.public_server_ip
      private_servers = var.private_server_ip
    }
  )
  filename = "${path.root}/ansible/inventory_file.ini"
}
resource "local_file" "ansible_dev_inventory_file" {
  content = templatefile("${path.root}/ansible/templates/dev.tpl",
    {
      dev_public_servers = var.dev_public_servers
    }
  )
  filename = "${path.root}/ansible/inventories/dev/dev_hosts.ini"
}
resource "local_file" "ansible_test_inventory_file" {
  content = templatefile("${path.root}/ansible/templates/test.tpl",
    {
      test_public_servers = var.test_public_servers
    }
  )
  filename = "${path.root}/ansible/inventories/test/test_hosts.ini"
}
resource "local_file" "ansible_qa_inventory_file" {
  content = templatefile("${path.root}/ansible/templates/qa.tpl",
    {
      qa_public_servers = var.qa_public_servers
    }
  )
  filename = "${path.root}/ansible/inventories/qa/qa_hosts.ini"
}
