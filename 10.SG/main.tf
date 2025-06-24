module "Security-group" {
  source = "../../terraform-securitygroup-module"
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}