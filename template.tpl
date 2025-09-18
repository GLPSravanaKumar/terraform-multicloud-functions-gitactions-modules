# Ansible Controller Main Servers
[ansible_controller_public_servers]
%{ for idx, ip in ansible_controller_public_servers ~}
ansible_controller_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}

# Dev Servers
[dev_public_servers]
%{ for idx, ip in dev_public_servers ~}
dev_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}

# Test Servers
[test_public_servers]
%{ for idx, ip in test_public_servers ~}
test_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}

# QA Servers
[qa_public_servers]
%{ for idx, ip in qa_public_servers ~}
qa_public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}

[all_public_servers:children]
dev_public_servers
qa_public_servers
test_public_servers

# Public Servers
[public_servers]
%{ for idx, ip in public_servers ~}
public_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}

# Private Servers
[private_servers]
%{ for idx, ip in private_servers ~}
private_server_${idx + 1} ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=glpskey ansible_host=${ip}
%{ endfor ~}


