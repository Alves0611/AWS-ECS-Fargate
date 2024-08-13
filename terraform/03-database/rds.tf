resource "aws_security_group" "this" {
  name        = "${local.namespaced_service_name}-postgres"
  description = "Allows incoming database connections"
  vpc_id      = local.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.subnets.private.cidr_blocks
  }

  dynamic "ingress" {
    for_each = local.bastion_host_sg_id != "" ? [1] : []
    content {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [local.bastion_host_sg_id]
    }
  }

  tags = {
    Name = "${local.namespaced_service_name}-postgres"
  }
}

