provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Component = "Remote State"
      ManagedBy = "Terraform"
    }
  }
}
