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

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.id
  port              = 80
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = local.has_domain_name ? [1] : []
    content {
      type = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = local.has_domain_name ? [] : [1]
    content {
      type             = "forward"
      target_group_arn = aws_alb_target_group.this.id
    }
  }
}

