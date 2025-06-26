resource "aws_ssm_parameter" "dev-vpc_id" {
  name  = "/${var.main_project}/${var.main_environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

# we know aws follws strict naming convention for parametrs. they should be given with "/"
resource "aws_ssm_parameter" "public_subnet_id's" {
  name  = "/${var.main_project}/${var.main_environment}/Public_subnet_id's"
  type  = "StringList"
  value = module.vpc.public_subnet_ids
  
}
