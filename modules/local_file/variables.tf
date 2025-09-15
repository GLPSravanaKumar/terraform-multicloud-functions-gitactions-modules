variable "public_server_ip" {
  description = "public server details "
}
variable "private_server_ip" {
  description = "list of instace private server Ids"
}
variable "ansible_controller_public_servers" {
  description = "list of ansible controller main instace public server Ids"
}
variable "dev_public_servers" {
  description = "list of dev instace public server Ids"
}
variable "test_public_servers" {
  description = "list of test instace public server Ids"
}
variable "qa_public_servers" {
  description = "list of qa instace public server Ids"
}
