output "ip_tg_arn" {
  value = aws_lb_target_group.ip_tg.arn
}

output "lb_listener_arn" {
  value = aws_lb_listener.tg_listener.arn
}

output "lb_dns" {
  value = aws_lb.lb.dns_name
}

output "lb_arn" {
  value = aws_lb.lb.arn_suffix
}