# Create IAM Groups
resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

# Add users to the Education group
resource "aws_iam_group_membership" "education_members" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
  ]
}

# Add users to the Managers group
resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
}

# Add users to the Engineers group
resource "aws_iam_group_membership" "engineers_members" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Engineering" # Note: No users match this in the current CSV
  ]
}

#  Attach IAM Policies to Groups

# Education group - ReadOnlyAccess

resource "aws_iam_group_policy_attachment" "education_readonly" {
  group = aws_iam_group.education.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Managers group - AdministratorAccess

resource "aws_iam_group_policy_attachment" "managers_admin" {
  group = aws_iam_group.managers.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}

# Engineers group - EC2 full access

# Engineers group - EC2 full access
resource "aws_iam_group_policy_attachment" "engineers_custom_policy" {
  group      = aws_iam_group.engineers.name
  policy_arn = aws_iam_policy.engineer_ec2_limited.arn
}


output "group_policy_mapping" {
  value = {
    Education  = ["ReadOnlyAccess"]
    Managers   = ["AdministratorAccess"]
    Engineers  = ["EngineerEC2LimitedAccess"]
  }
}
