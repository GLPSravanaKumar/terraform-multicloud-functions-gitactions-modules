output "pub_sg_id" {
  value = aws_security_group.pub_sg.id
}
output "private_sg_id" {
  value = aws_security_group.private_sg.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg_ingress.id
}
