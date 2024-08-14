variable "aws_region" {
  description = "AWS region where the Network resources will be deployed, e.g., 'eu-central-1' for the Europe (Frankfurt) region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name, such as 'dev', 'test', 'prod'. This categorizes the Network resources by their usage stage"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "The name of the service the bastion host is associated with, used for naming and tagging resources in AWS"
  type        = string
  default     = "express-todo-api"
}

variable "department_name" {
  description = "Name of the department responsible for the VPC, e.g., 'engineering', 'marketing'. Helps in identifying ownership of the resources"
  type        = string
  default     = "devops"
}

variable "ecs" {
  description = "Configuration object for the ECS service, including CPU/memory allocations, app container port, desired count of tasks, Docker image URL, and health check path"
  type = object({
    fargate_cpu       = number
    fargate_memory    = number
    app_port          = number
    app_count         = number
    app_image         = string
    health_check_path = string
  })
  default = {
    fargate_cpu       = 256
    fargate_memory    = 512
    app_port          = 3000
    app_count         = 1
    app_image         = ""
    health_check_path = "/healthcheck"
  }
}


