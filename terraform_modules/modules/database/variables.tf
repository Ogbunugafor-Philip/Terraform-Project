# List of private DB subnet IDs where RDS will be deployed
variable "private_db_subnet_ids" {
  description = "List of private subnets for RDS deployment"
  type        = list(string)
}

# Security group ID that allows MySQL traffic from the app layer
variable "db_sg_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}

# Logical database name inside MySQL (e.g., terraform_db)
variable "db_name" {
  description = "Name of the MySQL database"
  type        = string
}

# Admin username for connecting to the database
variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

# Admin password for the DB user
variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}
