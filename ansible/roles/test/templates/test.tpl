# Test Servers
[test_public_servers]
%{ for idx, ip in test_public_servers ~}
test_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_ed25519_glpskumar ansible_host=${ip}
%{ endfor ~}
