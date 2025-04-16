variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "my_ip" {
  description = "Your IP address with /32"
  type        = string
  default     = "197.210.53.31/32"
}

variable "enable_rds_role" {
  description = "Whether to create RDS IAM Role"
  type        = bool
  default     = true
}
