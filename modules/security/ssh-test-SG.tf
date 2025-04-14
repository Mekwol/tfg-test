# Create a security group for the bastion host in the public subnet
resource "aws_security_group" "bastion_sg" {
  provider    = aws.tfg-test-account1-region1
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.region1_vpc.id

  # Allow SSH from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/20"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.linux_ip}/32"]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "TFG-Test-Bastion-SG"
    Environment = "Test"
  }
}

# Create a security group for the private instance
resource "aws_security_group" "private_sg" {
  provider    = aws.tfg-test-account1-region1
  name        = "private-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.region1_vpc.id

  # Allow SSH only from the VPC CIDR (specifically the bastion host)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1_vpc.cidr_block]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "TFG-Test-Private-SG"
    Environment = "Test"
  }
}
