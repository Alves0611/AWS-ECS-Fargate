resource "aws_acm_certificate" "this" {
  count = local.create_resource_based_on_domain_name

  domain_name       = local.subdomain_name
  validation_method = "DNS"
}


