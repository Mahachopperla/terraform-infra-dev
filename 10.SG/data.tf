data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

# we need to check what is the name of vpc id they given and provide it's name here.
#once we provide name this data soruce will fetch the value of it.