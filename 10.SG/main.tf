module "frontend" {
  source = "../../terraform-securitygroup-module"
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "bastion" {
  source = "../../terraform-securitygroup-module"
  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "ALB-SG" {
  source = "../../terraform-securitygroup-module"
  sg_name = var.ALB_sg_name
  sg_description = var.ALB_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "VPN-SG" {
  source = "../../terraform-securitygroup-module"
  sg_name = var.vpn_sg_name
  sg_description = var.vpn_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "mongodb" {
  source = "../../terraform-securitygroup-module"
  sg_name = "mongodb"
  sg_description = "Created sg for mongodb server"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "redis" {
  source = "../../terraform-securitygroup-module"
  sg_name = "redis"
  sg_description = "Created sg for redis server"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "mysql" {
  source = "../../terraform-securitygroup-module"
  sg_name = "mysql"
  sg_description = "Created sg for mysql server"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "rabbitmq" {
  source = "../../terraform-securitygroup-module"
  sg_name = "rabbitmq"
  sg_description = "Created sg for rabbitmq server"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "catalogue" {
  source = "../../terraform-securitygroup-module"
  sg_name = "catalogue"
  sg_description = "Created sg for catalogue server"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

# bastion accepting connections from my laptop
resource "aws_security_group_rule" "bastion-inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.bastion.sg_id

}
# ALB accepting connections from Bastion SG
resource "aws_security_group_rule" "ALB-inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
  security_group_id = module.ALB-SG.sg_id

}

resource "aws_security_group_rule" "ALB-inbound-vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id #Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
  security_group_id = module.ALB-SG.sg_id

}


#vpn needs some default ports to be opened 22,443,1194,943
#openig ports for vpn-> vpn accepting connections from laptop

resource "aws_security_group_rule" "vpn_inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.VPN-SG.sg_id

}

resource "aws_security_group_rule" "vpn_inbound_http" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.VPN-SG.sg_id

}

resource "aws_security_group_rule" "vpn_inbound_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.VPN-SG.sg_id

}

resource "aws_security_group_rule" "vpn_inbound_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.VPN-SG.sg_id

}

resource "aws_security_group_rule" "mongo_inbound" {
count = length(var.mongodb-ports)
  type              = "ingress"
  from_port         = var.mongodb-ports[count.index]
  to_port           = var.mongodb-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.mongodb.sg_id

}

resource "aws_security_group_rule" "redis_inbound" {
count = length(var.redis-ports)
  type              = "ingress"
  from_port         = var.redis-ports[count.index]
  to_port           = var.redis-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.redis.sg_id

}

resource "aws_security_group_rule" "mysql_inbound" {
count = length(var.mysql-ports)
  type              = "ingress"
  from_port         = var.mysql-ports[count.index]
  to_port           = var.mysql-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.mysql.sg_id

}

resource "aws_security_group_rule" "rabbitmq_inbound" {
count = length(var.rabbitmq-ports)
  type              = "ingress"
  from_port         = var.rabbitmq-ports[count.index]
  to_port           = var.rabbitmq-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.rabbitmq.sg_id

}

# ports required for catalogue server is 22,8080
# allowing port 22 from vpn 
resource "aws_security_group_rule" "catalogue_ssh_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id #Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
  security_group_id = module.catalogue.sg_id

}

#catalogue allowing port 22 from bastion

resource "aws_security_group_rule" "catalogue_ssh_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
security_group_id = module.catalogue.sg_id

}

#catalogue allowing port 8080 from ALB

resource "aws_security_group_rule" "catalogue_ALB" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.ALB-SG.sg_id
  security_group_id = module.catalogue.sg_id

}

# catalogue allowing port 8080 from vpn

resource "aws_security_group_rule" "catalogue_VPN" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id 
  security_group_id = module.catalogue.sg_id

}

# mongodb should also allow catalogue from it's port 27017

resource "aws_security_group_rule" "mongo_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id

}

