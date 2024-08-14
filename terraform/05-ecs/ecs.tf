resource "aws_ecs_cluster" "this" {
  name = local.namespaced_department_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.namespaced_service_name
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.fargate_cpu
  memory                   = var.ecs.fargate_memory
  skip_destroy             = true

  container_definitions = jsonencode([{
    name  = local.container_name
    image = local.app_image

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group"         = "/ecs/${local.namespaced_service_name}",
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs",
      }
    }

    portMappings = [{
      containerPort = var.ecs.app_port
      hostPort      = var.ecs.app_port
    }]

    environment = [
      {
        name  = "ENV"
        value = var.environment
      },
      {
        name  = "APP_NAME"
        value = local.namespaced_service_name
      },
      {
        name  = "PORT"
        value = tostring(var.ecs.app_port)
      },
      {
        name  = "LOG_LEVEL"
        value = var.log_level
      },
      {
        name  = "AWS_REGION"
        value = var.aws_region
      },
      {
        name  = "DATABASE_URL"
        value = "postgresql://${local.db_user}:${urlencode(local.db_pass)}@${local.db_host}:${local.db_port}/${local.db_name}"
      },
      {
        name  = "AWS_NODEJS_CONNECTION_REUSE_ENABLED"
        value = "1"
      }
    ]
  }])
}

