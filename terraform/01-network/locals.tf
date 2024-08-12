locals {
  common_tags = {
    Component  = "Network"
    ManagedBy  = "Terraform"
    Env        = var.environment
  }
}
