 # get hosted zone details
 data "aws_route53_zone" "hosted_zone" {
   name = var.domain_name   #this is the domain name and a variable was created so as not to make it completely open
 }

 # create a record set in route 53
 resource "aws_route53_record" "domain_site" {
   zone_id = data.aws_route53_zone.hosted_zone.zone_id
   name    = var.sub_domain
   type    = "A"

   alias {
     name                   =  var.application_loadbalancer   # aws_lb.application_loadbalancer.dns_name
     zone_id                =  var.application_load_balancer_zone_id
     evaluate_target_health =  true
   }
 }