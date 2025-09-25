# QA Servers
[qa_public_servers]
%{ for idx, ip in qa_public_servers ~}
qa_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}