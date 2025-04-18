# Output the RDS endpoint so the app or admin can connect
output "db_endpoint" {
  description = "The connection endpoint (DNS address) of the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

# Output the database name for reference
output "db_name" {
  description = "The name of the database created"
  value       = aws_db_instance.mysql.db_name
}
