locals {
  
  ami_id = data.aws_ami.my_ami.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
  
  database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  
  common_Tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
}