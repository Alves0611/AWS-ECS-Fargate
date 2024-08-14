data "aws_caller_identity" "current" {}
data "aws_availability_zones" "all" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tfstate-891377404175"
    key    = "ecs-fargate/${var.environment}/network/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket = "tfstate-891377404175"
    key    = "ecs-fargate/${var.environment}/ecr/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "tfstate-891377404175"
    key    = "ecs-fargate/${var.environment}/database/terraform.tfstate"
    region = var.aws_region
  }
}


