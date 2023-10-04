output "henryproject" {
    value = var.henryproject
}

output "alb_target_group_arn"{
    value = aws_lb_target_group.alb_target_group.arn
}

output "listener_arn" {
    value  = aws_lb_listener.alb_http_listener.arn

}

output "application_loadbalancer_dns_name"{
    value = aws_lb.application_loadbalancer.dns_name
}

output "application_load_balancer_zone_id"{
    value = aws_lb.application_loadbalancer.zone_id
}