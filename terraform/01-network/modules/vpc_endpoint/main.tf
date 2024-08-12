resource "aws_security_group" "vpce" {
  name        = "${var.vpc_name}-vpce-sg"
  description = "${var.vpc_name} VPC Endpoints security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
}