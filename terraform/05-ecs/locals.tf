locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"
  namespaced_service_name    = "${var.service_name}-${var.environment}"
  account_id                 = data.aws_caller_identity.current.account_id


  # Network
  vpc     = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets


  common_tags = {
    Component = "ECS Fargate"
    ManagedBy = "Terraform"
    Env       = var.environment
  }
}
