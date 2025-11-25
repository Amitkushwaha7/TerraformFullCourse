resource "aws_instance" "my_ec2" {
  ami           = "ami-0fa3fe0fa7920f68e"   # Amazon Linux 2 AMI (ap-south-1)
  instance_type = "t2.micro"                # Free-tier eligible

  tags = {
    Name = "AWS_Terraform_EC2_Instance"
  }
}
