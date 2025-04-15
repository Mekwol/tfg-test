# ------------------------------------------
# AWS Cloud WAN Core Network Configuration
# ------------------------------------------

# Create the AWS Cloud WAN Global Network
resource "aws_networkmanager_global_network" "global_network" {
  provider    = aws.delegated_account
  description = "TFG Global Network"
  
  tags = {
    Name        = "TFG-Global-Network"
    Environment = "Test"
  }
}

# Create the Core Network
resource "aws_networkmanager_core_network" "core_network" {
  provider          = aws.delegated_account
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "TFG Core Network"
  
  tags = {
    Name        = "TFG-Core-Network"
    Environment = "Test"
  }
}

# Define a minimal valid Core Network Policy

locals {
  initial_core_network_policy = jsonencode({
    "version": "2021.12",
    "core-network-configuration": {
      "vpn-ecmp-support": true,
      "asn-ranges": [
        "64512-65534"
      ],
      "edge-locations": [
        {
          "location": "us-east-1",
          "asn": 64512
        },
        {
          "location": "us-east-2",
          "asn": 64513
        }
      ]
    },
    "segments": [
      {
        "name": "prod",
        "require-attachment-acceptance": false
      },
     {
        "name": "non-prod",
        "require-attachment-acceptance": false
      }
    ],
    "network-function-groups": []
  })
}


# Attach the minimal policy to the Core Network
resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  provider        = aws.delegated_account
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = local.initial_core_network_policy
}

# Attach VPCs to the Core Network - Simplify to get basic functionality working
resource "aws_networkmanager_vpc_attachment" "region1_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.region1_private_subnet1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.region1_vpc.arn
  
  tags = {
    Name        = "Region1-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}

resource "aws_networkmanager_vpc_attachment" "region2_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.region2_private_subnet1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.region2_vpc.arn
  
  tags = {
    Name        = "Region2-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}
