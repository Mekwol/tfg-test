# Generate a new SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair using the generated public key
resource "aws_key_pair" "generated_key" {
  provider   = aws.tfg-test-account1-region1
  key_name   = "tfg-test-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
# Create a bastion host in public subnet
resource "aws_instance" "bastion" {
  provider                    = aws.tfg-test-account1-region1
  ami                         = "ami-0e1c5d8c23330dee3"  # Amazon Linux 2023 AMI for us-east-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.region1_public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "TFG-Test-Bastion"
    Environment = "Test"
  }
}

# Create a private instance in private subnet
resource "aws_instance" "private" {
  provider               = aws.tfg-test-account1-region1
  ami                    = "ami-0e1c5d8c23330dee3"  # Amazon Linux 2023 AMI for us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.region1_private_subnet1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags = {
    Name        = "TFG-Test-Private"
    Environment = "Test"
  }
}



resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/tfg-test-key.pem"
  file_permission = "0400"

depends_on = [tls_private_key.ssh_key]
 
}
