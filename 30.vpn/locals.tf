locals {
  vpn_sg_id = data.aws_ssm_parameter.vpn_sg_id.value
  ami_id = data.aws_ami.my_vpn_ami.id
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  
  common_Tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
}