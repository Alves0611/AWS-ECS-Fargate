resource "aws_ecr_repository" "this" {
  name                 = local.namespaced_department_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_repo
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })

}
