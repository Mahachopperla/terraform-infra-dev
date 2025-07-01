locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split ("," , data.aws_ssm_parameter.private_subnet_ids.value) #here we store list of subnets as string separeated by commas in parameter store. that's y we are accessing string and converting back to list . beacuse module accepts list of subnets only
  backend-ALB_sg_id = data.aws_ssm_parameter.backend-ALB_sg_id.value

  common_Tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
}