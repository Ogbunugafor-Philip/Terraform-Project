variable "ami_id" {
  description = "AMI ID for the Bastion Host (e.g., Ubuntu 20.04)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Bastion Host"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name to access the Bastion Host"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where Bastion Host will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID that allows SSH access"
  type        = string
}
