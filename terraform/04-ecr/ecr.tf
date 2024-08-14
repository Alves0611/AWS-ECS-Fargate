resource "aws_ecr_repository" "this" {
  name                 = local.namespaced_department_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_repo
}

