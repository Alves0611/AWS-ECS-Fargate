data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "remote_state" {
  bucket = "tfstate-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
