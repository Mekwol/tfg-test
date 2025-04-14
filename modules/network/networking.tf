# networking.tf

# ------------------------------
# Region 1 Networking Components
# ------------------------------

# Internet Gateway for Region 1
resource "aws_internet_gateway" "region1_igw" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  tags = {
    Name        = "TFG-Test-Account1-IGW-Region1"
    Environment = "Test"
  }
}

# Elastic IP for NAT Gateway in Region 1
resource "aws_eip" "region1_nat_eip" {
  provider = aws.tfg-test-account1-region1
  domain   = "vpc"

  tags = {
    Name        = "TFG-Test-Account1-NAT-EIP-Region1"
    Environment = "Test"
  }
}

# NAT Gateway for Region 1 - place in public subnet 1
resource "aws_nat_gateway" "region1_nat" {
  provider      = aws.tfg-test-account1-region1
  allocation_id = aws_eip.region1_nat_eip.id
  subnet_id     = aws_subnet.region1_public_subnet1.id # Place NAT Gateway in the first public subnet

  tags = {
    Name        = "TFG-Test-Account1-NAT-Region1"
    Environment = "Test"
  }

  depends_on = [aws_internet_gateway.region1_igw]
}

# ------------------------------
# Region 2 Networking Components
# ------------------------------

# Internet Gateway for Region 2
resource "aws_internet_gateway" "region2_igw" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  tags = {
    Name        = "TFG-Test-Account1-IGW-Region2"
    Environment = "Test"
  }
}

# Elastic IP for NAT Gateway in Region 2
resource "aws_eip" "region2_nat_eip" {
  provider = aws.tfg-test-account1-region2
  domain   = "vpc"

  tags = {
    Name        = "TFG-Test-Account1-NAT-EIP-Region2"
    Environment = "Test"
  }
}

# NAT Gateway for Region 2 - place in public subnet 1
resource "aws_nat_gateway" "region2_nat" {
  provider      = aws.tfg-test-account1-region2
  allocation_id = aws_eip.region2_nat_eip.id
  subnet_id     = aws_subnet.region2_public_subnet1.id # Place NAT Gateway in the first public subnet

  tags = {
    Name        = "TFG-Test-Account1-NAT-Region2"
    Environment = "Test"
  }

  depends_on = [aws_internet_gateway.region2_igw]
}
