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
      public_servers  = var.public_server_ip
      private_servers = var.private_server_ip
    }
  )
  filename = "${path.root}/ansible_inventory_file.ini"
}
