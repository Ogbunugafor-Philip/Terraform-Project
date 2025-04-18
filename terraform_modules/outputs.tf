output "vpc_id" {
  description = "VPC ID created by the VPC module"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs used for ALB and Bastion Host"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private subnets for EC2 Auto Scaling Group"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private subnets for the database"
  value       = module.vpc.private_db_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.loadbalancer.alb_dns_name
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host for SSH access"
  value       = module.bastion.public_ip
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}

output "db_endpoint" {
  description = "RDS MySQL endpoint (DNS) from the database module"
  value       = module.database.db_endpoint
}

output "db_name" {
  description = "Name of the created MySQL database"
  value       = module.database.db_name
}
