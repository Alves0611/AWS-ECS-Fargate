resource "aws_iam_role" "this" {
  name               = local.name
  assume_role_policy = <<EOD
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
EOD
}

resource "aws_iam_policy_attachment" "this" {
  name       = local.name
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


