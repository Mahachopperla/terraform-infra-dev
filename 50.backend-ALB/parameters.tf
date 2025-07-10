resource "aws_ssm_parameter" "alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/alb_listener_Arn"
  type  = "String"
  value = aws_lb_listener.backend_alb.arn
}