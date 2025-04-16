variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name tag for the NAT Gateway"
  type        = string
}

variable "public_rt_name" {
  description = "Name tag for the public route table"
  type        = string
}

variable "private_rt_name" {
  description = "Name tag for the private route table"
  type        = string
}

variable "public_subnet_az1" {
  description = "CIDR block for public subnet in AZ 1"
  type        = string
}

variable "public_subnet_az2" {
  description = "CIDR block for public subnet in AZ 2"
  type        = string
}

variable "private_web_subnet_az1" {
  description = "CIDR block for private web subnet in AZ 1"
  type        = string
}

variable "private_web_subnet_az2" {
  description = "CIDR block for private web subnet in AZ 2"
  type        = string
}

variable "private_db_subnet_az1" {
  description = "CIDR block for private DB subnet in AZ 1"
  type        = string
}

variable "private_db_subnet_az2" {
  description = "CIDR block for private DB subnet in AZ 2"
  type        = string
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
}
