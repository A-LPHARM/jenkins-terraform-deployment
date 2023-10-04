
output "alb_sec_grp" {
  value = aws_security_group.alb_sec_grp.id
}

output "aws_security_group" {
    value = aws_security_group.secgrp.id 
}

output "ssh-secgrp" {
    value = aws_security_group.ssh-secgrp.id
}

output "webserver-secgrp" {
    value = aws_security_group.webserver-secgrp.id
}

output "rds_sg" {
    value = aws_security_group.rds_sg.id
}

