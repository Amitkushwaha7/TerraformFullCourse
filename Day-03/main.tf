resource "aws_s3_bucket" "my_bucket" {
  bucket = "amit-terraform-course-bucket-03"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}