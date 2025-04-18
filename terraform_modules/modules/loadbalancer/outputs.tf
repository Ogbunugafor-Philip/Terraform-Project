output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.app_tg.arn
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.ssl_cert.arn
}
