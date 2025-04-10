# Output for easy reference
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.private.private_ip
}

# Add this to variables.tf
variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}
