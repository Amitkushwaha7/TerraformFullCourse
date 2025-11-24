resource "aws_instance" "my_ec2" {
  ami           = "ami-0e472ba40eb589f49"   # Amazon Linux 2 AMI (ap-south-1)
  instance_type = "t2.micro"                # Free-tier eligible

  tags = {
    Name = "AWS_Terraform_EC2_Instance"
  }
}
