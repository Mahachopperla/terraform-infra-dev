resource "aws_ssm_parameter" "dev-vpc_id" {
  name  = "/${var.main_project}/${var.main_environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

# value get it from module-> module.vpc.Public_subent_id's
# 						here we might get error because module gives us ouput as lsit of strings with braces
# 							[ "public subnet 1",
# 							"public subnet 2"]
# 						but ssm parameter store accepts list of strings with comma(,) separated
# 							public subnet1,public subnet 2
# 						Now, we need to convert list into strings separated by commas
# 							we should use join function
# 							value = join(",", module.vpc.public_subnet_ids)
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)

}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)

}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)

}

