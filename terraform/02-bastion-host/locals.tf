locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  # Network
  vpc     = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets

  common_tags = {
    Component = "Bastion Host"
    ManagedBy = "Terraform"
    Env       = var.environment
  }
}
