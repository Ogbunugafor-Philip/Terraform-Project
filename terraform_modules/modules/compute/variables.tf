variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_sg_id" {
  description = "Security Group ID for the App EC2 instance"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "ARN of the load balancer target group"
  type        = string
  default     = null
}
