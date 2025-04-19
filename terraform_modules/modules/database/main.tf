# -----------------------------------------
# Create a DB Subnet Group for RDS
# This ensures RDS is launched in private subnets across multiple AZs
# -----------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "DB Subnet Group"
  }
}

# -----------------------------------------
# Provision a Multi-AZ MySQL RDS instance
# Securely placed in private subnets, protected by DB security group
# -----------------------------------------
resource "aws_db_instance" "mysql" {
  identifier              = "terraform-db"
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  multi_az                = true
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true
  publicly_accessible     = false

  db_subnet_group_name     = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids   = [var.db_sg_id]

  tags = {
    Name = "Terraform MySQL RDS"
  }
}
