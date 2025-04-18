output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_az_1_id" {
  description = "ID of Public Subnet in AZ 1"
  value       = aws_subnet.public_az_1.id
}

output "public_subnet_az_2_id" {
  description = "ID of Public Subnet in AZ 2"
  value       = aws_subnet.public_az_2.id
}

output "private_web_subnet_az_1_id" {
  description = "ID of Private Web Subnet in AZ 1"
  value       = aws_subnet.private_web_az_1.id
}

output "private_web_subnet_az_2_id" {
  description = "ID of Private Web Subnet in AZ 2"
  value       = aws_subnet.private_web_az_2.id
}

output "private_db_subnet_az_1_id" {
  description = "ID of Private DB Subnet in AZ 1"
  value       = aws_subnet.private_db_az_1.id
}

output "private_db_subnet_az_2_id" {
  description = "ID of Private DB Subnet in AZ 2"
  value       = aws_subnet.private_db_az_2.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_web_az_1.id,
    aws_subnet.private_web_az_2.id,
    aws_subnet.private_db_az_1.id,
    aws_subnet.private_db_az_2.id,
  ]
}
output "public_subnet_ids" {
  value = [
    aws_subnet.public_az_1.id,
    aws_subnet.public_az_2.id,
  ]
}
