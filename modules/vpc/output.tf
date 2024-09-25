# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.gw.id
}

# Output Public Subnet IDs
output "alb_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.alb_subnets[*].id
}

# Output Private Subnet IDs
output "app_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.app_subnets[*].id
}

output "db_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.db_subnets[*].id
}

# Output Public Subnet CIDR Blocks
output "alb_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets."
  value       = aws_subnet.alb_subnets[*].cidr_block
}

# Output Private Subnet CIDR Blocks
output "app_subnet_cidrs" {
  description = "The CIDR blocks of the private subnets."
  value       = aws_subnet.app_subnets[*].cidr_block
}

# Output Private Subnet CIDR Blocks
output "db_subnet_cidrs" {
  description = "The CIDR blocks of the private subnets."
  value       = aws_subnet.db_subnets[*].cidr_block
}

output "aws_availability_zones" {
  description = "availablity zones"
  value       = data.aws_availability_zones.available.names
}