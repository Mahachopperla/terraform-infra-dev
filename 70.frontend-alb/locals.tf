locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids = split ("," , data.aws_ssm_parameter.public_subnet_ids.value) #here we store list of subnets as string separeated by commas in parameter store. that's y we are accessing string and converting back to list . beacuse module accepts list of subnets only
  frontend-ALB_sg_id = data.aws_ssm_parameter.frontend-ALB_sg_id.value
  certificate_arn = data.aws_ssm_parameter.certificate_arn.value

  common_Tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
}