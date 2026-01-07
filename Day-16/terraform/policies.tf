resource "aws_iam_policy" "engineer_ec2_limited" {
  name        = "EngineerEC2LimitedAccess"
  description = "Allow engineers to start/stop EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}
