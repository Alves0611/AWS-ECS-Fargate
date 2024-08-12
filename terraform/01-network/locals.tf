locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"

  use_nat_gateway      = var.use_nat_gateway
  use_nat_instance     = var.use_nat_instance && local.use_nat_gateway == false
  enable_dns_support   = (var.use_nat_instance || var.create_vpc_endpoint) ? true : var.network.enable_dns_support
  enable_dns_hostnames = (var.use_nat_instance || var.create_vpc_endpoint) ? true : var.network.enable_dns_hostnames

  common_tags = {
    Component = "Network"
    ManagedBy = "Terraform"
    Env       = var.environment
  }
}
