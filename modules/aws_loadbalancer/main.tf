resource "aws_lb_target_group" "alb_target_gp" {
  name        = "${var.department}-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb" "alb" {
  name               = "${var.department}-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}
resource "aws_lb_target_group_attachment" "alb_attachment" {
  count            = length(var.aws_instance_ids)
  target_group_arn = aws_lb_target_group.alb_target_gp.arn
  target_id        = var.aws_instance_ids[count.index]
  port             = 80
}
resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_gp.arn
  }
}
