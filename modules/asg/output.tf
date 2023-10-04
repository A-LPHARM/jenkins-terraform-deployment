output "autoscaling_group_name" {
  description = "The name of the created Auto Scaling Group."
  value       = aws_autoscaling_group.asg.name
}

output "aws_launch_name" {
  description = "The name of the created Launch Configuration."
  value       =  aws_launch_template.asg_launch_template.name
}
