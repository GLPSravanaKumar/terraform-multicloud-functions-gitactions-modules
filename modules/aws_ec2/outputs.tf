#title: converts the first letter of each word in the given string to uppercase.

/* output "keypair_id" {
  value = data.aws_key_pair.key.key_pair_id
} */
output "ami_image_id" {
  description = "Get instance Ami image ID"
  value       = aws_instance.public_servers[*].ami
}
output "aws_instance_ids" {
  description = "Get list of active running instance  Ids"
  value       = aws_instance.public_servers[*].id
}
output "public_server_ip" {
  description = "list of instace public server Ids"
  value       = aws_instance.public_servers[*].public_ip
}
output "private_server_ip" {
  description = "list of instace private server Ids"
  value       = aws_instance.private_servers[*].private_ip
}
