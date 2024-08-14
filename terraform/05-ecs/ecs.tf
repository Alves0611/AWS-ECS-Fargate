resource "aws_ecs_cluster" "this" {
  name = local.namespaced_department_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

