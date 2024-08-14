resource "aws_alb" "this" {
  name            = local.namespaced_service_name
  subnets         = local.subnets.public.id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "this" {
  vpc_id      = local.vpc.id
  name        = local.namespaced_service_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    unhealthy_threshold = "2"
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/healthcheck"
  }
}

