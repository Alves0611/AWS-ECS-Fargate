data "aws_caller_identity" "current" {}
data "aws_availability_zones" "all" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tfstate-891377404175"
    key    = "ecs-fargate/dev/network/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "bastion_host" {
  backend = "s3"

  config = {
    bucket = ""
    key    = "ecs-fargate/dev/bastion-host/terraform.tfstate"
    region = var.aws_region
  }
}