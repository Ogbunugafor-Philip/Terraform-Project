output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.app_template.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}
