data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "backend-ALB_sg_id" {
  name = "/${var.project}/${var.environment}/backend-ALB_sg_id"
}

# we need to check what is the name of vpc id they given and provide it's name here.
#once we provide name this data soruce will fetch the value of it.