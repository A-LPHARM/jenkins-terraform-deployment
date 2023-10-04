 output "domain" {
     value = aws_route53_record.domain_site.alias[0] 
 }