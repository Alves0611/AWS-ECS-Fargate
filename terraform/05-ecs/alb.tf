resource "aws_alb" "this" {
  name            = local.namespaced_service_name
  subnets         = local.subnets.public.id
  security_groups = [aws_security_group.alb.id]
}

