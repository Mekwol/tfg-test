# route_tables.tf

# ------------------------------
# Region 1 Route Tables
# ------------------------------

# Public Route Table for Region 1
resource "aws_route_table" "region1_public_rt" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.region1_igw.id
  }

  tags = {
    Name        = "TFG-Test-Account1-Public-RT-Region1"
    Environment = "Test"
  }
}

# Private Route Table for Region 1
resource "aws_route_table" "region1_private_rt" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.region1_nat.id
  }

  tags = {
    Name        = "TFG-Test-Account1-Private-RT-Region1"
    Environment = "Test"
  }
}

# Public Subnet Associations for Region 1
resource "aws_route_table_association" "region1_public_rta1" {
  provider       = aws.tfg-test-account1-region1
  subnet_id      = aws_subnet.region1_public_subnet1.id
  route_table_id = aws_route_table.region1_public_rt.id
}

resource "aws_route_table_association" "region1_public_rta2" {
  provider       = aws.tfg-test-account1-region1
  subnet_id      = aws_subnet.region1_public_subnet2.id
  route_table_id = aws_route_table.region1_public_rt.id
}

# Private Subnet Association for Region 1
resource "aws_route_table_association" "region1_private_rta1" {
  provider       = aws.tfg-test-account1-region1
  subnet_id      = aws_subnet.region1_private_subnet1.id
  route_table_id = aws_route_table.region1_private_rt.id
}

# ------------------------------
# Region 2 Route Tables
# ------------------------------

# Public Route Table for Region 2
resource "aws_route_table" "region2_public_rt" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.region2_igw.id
  }

  tags = {
    Name        = "TFG-Test-Account1-Public-RT-Region2"
    Environment = "Test"
  }
}

# Private Route Table for Region 2
resource "aws_route_table" "region2_private_rt" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.region2_nat.id
  }

  tags = {
    Name        = "TFG-Test-Account1-Private-RT-Region2"
    Environment = "Test"
  }
}

# Public Subnet Associations for Region 2
resource "aws_route_table_association" "region2_public_rta1" {
  provider       = aws.tfg-test-account1-region2
  subnet_id      = aws_subnet.region2_public_subnet1.id
  route_table_id = aws_route_table.region2_public_rt.id
}

resource "aws_route_table_association" "region2_public_rta2" {
  provider       = aws.tfg-test-account1-region2
  subnet_id      = aws_subnet.region2_public_subnet2.id
  route_table_id = aws_route_table.region2_public_rt.id
}

# Private Subnet Association for Region 2
resource "aws_route_table_association" "region2_private_rta1" {
  provider       = aws.tfg-test-account1-region2
  subnet_id      = aws_subnet.region2_private_subnet1.id
  route_table_id = aws_route_table.region2_private_rt.id
}


