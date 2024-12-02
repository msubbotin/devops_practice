# Get the latest AMI ID for Amazon Linux 2023
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Create a ec2 instance
resource "aws_instance" "test" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ssh_access.name]
  user_data = file("ec2_init.sh")
  # key need to be created in aws console
  key_name = "terraform"
  tags = {
    Name        = "test"
    Environment = "Dev"
  }
}

# Create a security group with SSH access
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all access"
  }
}