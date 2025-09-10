resource "aws_lb_target_group" "alb_target_gp" {
  name        = "${var.department}-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}
resource "aws_lb" "alb" {
  name               = "${var.department}-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.alb_sg_id]
  subnets            = concat(var.public_subnet_ids, var.private_subnet_ids)
  access_logs {
    bucket  = var.bucket_name
    prefix  = "${var.department}-alb-logs"
    enabled = true
  }
}
resource "aws_lb_target_group_attachment" "alb_attachment" {
  count            = length(var.aws_instance_ids)
  target_group_arn = aws_lb_target_group.alb_target_gp.arn
  target_id        = var.aws_instance_ids[count.index]
  port             = 80
}
