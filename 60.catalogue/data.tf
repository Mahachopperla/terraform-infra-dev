data "aws_ami" "my_ami" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg_id"
}



data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "alb_listener_arn" {
  name = "/${var.project}/${var.environment}/alb_listener_Arn"
}
# in parameter store we have this public subnets as string
# 				-> we need to convert it into list and get first subnet id and create ec2 instance in that subnet
# 				-> so in data source -> get entire list of public subents
# 				-> now subnet_id value u assign it in locals
# 				-> in locals -> subnetid= split(",",data.aws_ssm_parameter_pub_Subnet_id's.value)[0]
# 						this will convert public subnet id's to list and get first value
