data "aws_ami" "my_vpn_ami" {
  most_recent      = true
  owners           = ["679593333241"]

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-8fbe3379-63b6-43e8-87bd-0e93fd7be8f3"]
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

data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/${var.environment}/vpn_sg_id"
}


data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}
# in parameter store we have this public subnets as string
# 				-> we need to convert it into list and get first subnet id and create ec2 instance in that subnet
# 				-> so in data source -> get entire list of public subents
# 				-> now subnet_id value u assign it in locals
# 				-> in locals -> subnetid= split(",",data.aws_ssm_parameter_pub_Subnet_id's.value)[0]
# 						this will convert public subnet id's to list and get first value
