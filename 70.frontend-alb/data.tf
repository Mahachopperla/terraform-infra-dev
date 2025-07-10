data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "frontend-ALB_sg_id" {
  name = "/${var.project}/${var.environment}/frontend-ALB_sg_id"
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project}/${var.environment}/certificate_arn"
}


# we need to check what is the name of vpc id they given and provide it's name here.
#once we provide name this data soruce will fetch the value of it.