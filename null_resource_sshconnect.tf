resource "local_file" "ssh_file" {
  content = join("\n", concat(
    [
      for idx, ip in module.aws_ec2_ansible-controller.public_server_ip :
      "ansible_controller_${idx + 1} : ssh -i \"C:\\Users\\Naga\\.ssh\\id_ed25519_glpskumar\" ubuntu@${ip}"
    ],
    [
      for idx, ip in module.aws_ec2_dev.public_server_ip :
      "dev_server_${idx + 1} : ssh -i \"C:\\Users\\Naga\\.ssh\\id_ed25519_glpskumar\" ubuntu@${ip}"
    ] /* ,
    [
      for idx, ip in module.ec2_rosters.public_server_ip :
      "rosters_server_${idx + 1} : ssh -i \"C:\\Users\\Naga\\.ssh\\id_ed25519_glpskumar\" ubuntu@${ip}"
    ] */
  ))
  filename = "${path.root}/ssh_connect_servers.txt"
}

