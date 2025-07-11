module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.project}-${var.environment}-frontend-ALB"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  create_security_group = "false"
  internal = "false"
  security_groups = [local.frontend-ALB_sg_id]
  enable_deletion_protection = "false"
  version = "9.16.0"
  
  tags = merge( local.common_Tags,{
    Name = "${var.project}-${var.environment}-frontend-ALB"
  })
}

# creating a listner and attaching it to alb

resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1> Hi I am from frontend_ALB <h1>"
      status_code  = "200"
    }
  }
}

# creating a record for ALB
#here record is not for an ip address . its for another domain name. so in that case we need to use aliases.

resource "aws_route53_record" "frontend_alb_record" {
  zone_id = var.hosted_zone_id #this is the zone id of ur domain robotshop.site . u will get from aws portal
  name    = "dev.${var.hosted_zone_name}" # this is also from aws portal
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = module.alb.dns_name # u will get it from official module
    zone_id                = module.alb.zone_id # this is the zone_id of alb created. this also u can get it from alb offical module.
    evaluate_target_health = true
  }
}