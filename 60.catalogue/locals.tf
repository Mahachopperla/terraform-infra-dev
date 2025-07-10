locals {
  
  ami_id = data.aws_ami.my_ami.id
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  backend_alb_listener_arn = data.aws_ssm_parameter.alb_listener_arn.value
  common_Tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
}