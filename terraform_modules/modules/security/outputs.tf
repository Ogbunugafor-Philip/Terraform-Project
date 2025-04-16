# Security Group Outputs
output "web_sg_id" {
  description = "Security Group ID for Web (ALB)"
  value       = aws_security_group.web_sg.id
}

output "app_sg_id" {
  description = "Security Group ID for App (EC2)"
  value       = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "Security Group ID for Database (RDS)"
  value       = aws_security_group.db_sg.id
}

output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.bastion_sg.id
}

# IAM Role Outputs
output "ec2_role_arn" {
  description = "ARN of IAM Role for EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "rds_role_arn" {
  description = "ARN of IAM Role for RDS"
  value       = var.enable_rds_role ? aws_iam_role.rds_role[0].arn : null
}
