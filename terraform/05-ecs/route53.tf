data "aws_route53_zone" "this" {
  count = local.create_resource_based_on_domain_name

  name         = var.domain_name
  private_zone = false
}

