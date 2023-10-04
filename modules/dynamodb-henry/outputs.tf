output "henryproject" {
    value = var.henryproject
}

output "vpc_id" {
    value = aws_vpc.henryvpc.id
}

output "publicsubnet" {
    value = aws_subnet.publicsubnet.id
}

output "publicsubnet2" {
    value = aws_subnet.publicsubnet2.id
}

output "privatesubnet1" {
    value = aws_subnet.privatesubnet1.id
}

output "privatesubnet2" {
    value = aws_subnet.privatesubnet2.id
}

output "Internetgateway" {
    value = aws_internet_gateway.publicig
}