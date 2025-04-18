variable "web_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}
