# vpc.tf

# ----------------------------------
# Region 1 VPC Configuration
# ----------------------------------

# Create VPC in us-east-1 using the shared IPAM pool
resource "aws_vpc" "region1_vpc" {
  provider = aws.tfg-test-account1-region1

  # Use the Region 1 Production Pool
  ipv4_ipam_pool_id   = "ipam-pool-08f6531d08d2924a4" # Region 1 Production Pool ID
  ipv4_netmask_length = 21                            # Allocate a /21 CIDR block

  # Enable DNS support and hostnames for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "TFG-Test-Account1-VPC-Region1"
    Environment = "Test"
  }
}

# Create first public subnet in us-east-1 VPC
resource "aws_subnet" "region1_public_subnet1" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region1_vpc.cidr_block, 2, 0) # /23 subnet
  availability_zone = "us-east-1a"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "TFG-Test-Account1-Public-Subnet1-Region1"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create second public subnet in us-east-1 VPC
resource "aws_subnet" "region1_public_subnet2" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region1_vpc.cidr_block, 2, 1) # /23 subnet
  availability_zone = "us-east-1b"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "TFG-Test-Account1-Public-Subnet2-Region1"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create private subnet in us-east-1 VPC
resource "aws_subnet" "region1_private_subnet1" {
  provider = aws.tfg-test-account1-region1
  vpc_id   = aws_vpc.region1_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region1_vpc.cidr_block, 2, 2) # /23 subnet
  availability_zone = "us-east-1c"

  # Disable auto-assign public IP for private subnet
  map_public_ip_on_launch = false

  tags = {
    Name        = "TFG-Test-Account1-Private-Subnet1-Region1"
    Environment = "Test"
    Type        = "Private"
  }
}

# ----------------------------------
# Region 2 VPC Configuration
# ----------------------------------

# Create VPC in us-east-2 using the shared IPAM pool
resource "aws_vpc" "region2_vpc" {
  provider = aws.tfg-test-account1-region2

  # Use the Region 2 Production Pool
  ipv4_ipam_pool_id   = "ipam-pool-084e88a5e78284bb8" # Region 2 Production Pool ID
  ipv4_netmask_length = 21                            # Allocate a /21 CIDR block

  # Enable DNS support and hostnames for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "TFG-Test-Account1-VPC-Region2"
    Environment = "Test"
  }
}

# Create first public subnet in us-east-2 VPC
resource "aws_subnet" "region2_public_subnet1" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region2_vpc.cidr_block, 2, 0) # /23 subnet
  availability_zone = "us-east-2a"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "TFG-Test-Account1-Public-Subnet1-Region2"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create second public subnet in us-east-2 VPC
resource "aws_subnet" "region2_public_subnet2" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region2_vpc.cidr_block, 2, 1) # /23 subnet
  availability_zone = "us-east-2b"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "TFG-Test-Account1-Public-Subnet2-Region2"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create private subnet in us-east-2 VPC
resource "aws_subnet" "region2_private_subnet1" {
  provider = aws.tfg-test-account1-region2
  vpc_id   = aws_vpc.region2_vpc.id

  cidr_block        = cidrsubnet(aws_vpc.region2_vpc.cidr_block, 2, 2) # /23 subnet
  availability_zone = "us-east-2c"

  # Disable auto-assign public IP for private subnet
  map_public_ip_on_launch = false

  tags = {
    Name        = "TFG-Test-Account1-Private-Subnet1-Region2"
    Environment = "Test"
    Type        = "Private"
  }
}

