locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"
  namespaced_service_name    = "${var.service_name}-${var.environment}"
  account_id                 = data.aws_caller_identity.current.account_id

  # ECS
  container_name          = "${local.namespaced_service_name}-container"
  app_image               = var.ecs.app_image != "" ? var.ecs.app_image : "${data.terraform_remote_state.ecr.outputs.repository_url}:${data.terraform_remote_state.ecr.outputs.version}"
  autoscaling_resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"


  # Network
  vpc     = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets


  common_tags = {
    Component = "ECS Fargate"
    ManagedBy = "Terraform"
    Env       = var.environment
  }
}
