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
    version = "2021.12",
    core-network-configuration = {
      edges = [
        {
          asn      = 64512,
          location = "us-east-1"
        },
        {
          asn      = 64513,
          location = "us-east-2"
        }
      ]
    },
    segments = [
      {
        name                          = "segment1",
        description                   = "Segment One",
        require-attachment-acceptance = false
      }
    ],
    attachment-policies = [
      {
        rule-number     = 100,
        condition-logic = "or",
        conditions = [
          {
            type     = "tag-value",
            operator = "equals",
            key      = "Environment",
            value    = "Test"
          }
        ],
        action = {
          association-method = "constant",
          segment            = "segment1"
        }
      }
    ]
  })
}

# Apply Core Network Policy via CLI after Core Network creation
resource "null_resource" "apply_core_network_policy" {
  provisioner "local-exec" {
    command = <<EOT
      
     echo "Waiting for core network to be fully available..."
      sleep 60

    aws networkmanager put-core-network-policy \
        --core-network-id ${aws_networkmanager_core_network.core_network.id} \
        --policy-document '${local.initial_core_network_policy}'
    EOT

    environment = {
      AWS_REGION = "us-east-1" # Replace if needed
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [aws_networkmanager_core_network.core_network]
}

# Attach VPCs to the Core Network
resource "aws_networkmanager_vpc_attachment" "region1_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.region1_private_subnet1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.region1_vpc.arn
  
  tags = {
    Name        = "Region1-VPC-Attachment"
    Environment = "Test"
  }

  depends_on = [null_resource.apply_core_network_policy]
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

  depends_on = [null_resource.apply_core_network_policy]
}

