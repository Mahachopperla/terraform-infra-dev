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

module "backend_ALB_SG" {
  source = "../../terraform-securitygroup-module"
  sg_name = "backend-ALB-sg"
  sg_description = var.ALB_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "frontend_ALB_SG" {
  source = "../../terraform-securitygroup-module"
  sg_name = "frontend-ALB-sg"
  sg_description = "creating frontned ALB"
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

module "user" {
    source = "../../terraform-securitygroup-module"
    #source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "user"
    sg_description = "for user"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "cart" {
    source = "../../terraform-securitygroup-module"
    #source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "cart"
    sg_description = "for cart"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "shipping" {
    source = "../../terraform-securitygroup-module"
    #source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "shipping"
    sg_description = "for shipping"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "payment" {
    source = "../../terraform-securitygroup-module"
    #source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "payment"
    sg_description = "for payment"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}



#mongodb open ports

# mongo-db accepting connections from vpn

resource "aws_security_group_rule" "mongo_vpn" {
count = length(var.mongodb-ports)
  type              = "ingress"
  from_port         = var.mongodb-ports[count.index]
  to_port           = var.mongodb-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.mongodb.sg_id

}
# mongo-db accepting connections from bastion
resource "aws_security_group_rule" "mongo_bastion" {
count = length(var.mongodb-ports)
  type              = "ingress"
  from_port         = var.mongodb-ports[count.index]
  to_port           = var.mongodb-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mongodb.sg_id

}
# mongodb allowing connections from catalogue
resource "aws_security_group_rule" "mongo_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id

}

#mongodb allowing connections from user
resource "aws_security_group_rule" "mongo_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.mongodb.sg_id

}

#redis open ports

#redis allowing connections from vpn
resource "aws_security_group_rule" "redis_vpn" {
count = length(var.redis-ports)
  type              = "ingress"
  from_port         = var.redis-ports[count.index]
  to_port           = var.redis-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.redis.sg_id

}

# redis allowing connections from bastion
resource "aws_security_group_rule" "redis_bastion" {
count = length(var.redis-ports)
  type              = "ingress"
  from_port         = var.redis-ports[count.index]
  to_port           = var.redis-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.redis.sg_id

}

# redis allowing connections from user
resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id

}
# redis allowing connections from cart
resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.redis.sg_id

}

# Mysql open ports
#mysql allowing connections from vpn
resource "aws_security_group_rule" "mysql_vpn" {
count = length(var.mysql-ports)
  type              = "ingress"
  from_port         = var.mysql-ports[count.index]
  to_port           = var.mysql-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.mysql.sg_id

}
#mysql allowing connections from bastion
resource "aws_security_group_rule" "mysql_bastion" {
count = length(var.mysql-ports)
  type              = "ingress"
  from_port         = var.mysql-ports[count.index]
  to_port           = var.mysql-ports[count.index]
  protocol          = "tcp"
   source_security_group_id = module.bastion.sg_id
  security_group_id = module.mysql.sg_id

}
#mysql allowing connections from shipping

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id

}

#Rabbitmq open ports

#rabbitmq allowing vpn

resource "aws_security_group_rule" "rabbitmq_vpn" {
count = length(var.rabbitmq-ports)
  type              = "ingress"
  from_port         = var.rabbitmq-ports[count.index]
  to_port           = var.rabbitmq-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.rabbitmq.sg_id

}
# rabbitmq alowing bastion
resource "aws_security_group_rule" "rabbitmq_bastion" {
count = length(var.rabbitmq-ports)
  type              = "ingress"
  from_port         = var.rabbitmq-ports[count.index]
  to_port           = var.rabbitmq-ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.rabbitmq.sg_id

}
# rabbitmq allowing payment

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.rabbitmq.sg_id
}

#catalogue

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
  source_security_group_id = module.backend_ALB_SG.sg_id
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

#User
resource "aws_security_group_rule" "user_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_ALB_SG.sg_id
  security_group_id = module.user.sg_id
}

#Cart
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_ALB_SG.sg_id
  security_group_id = module.cart.sg_id
}

#Shipping
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_ALB_SG.sg_id
  security_group_id = module.shipping.sg_id
}

#Payment
resource "aws_security_group_rule" "payment_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_ALB_SG.sg_id
  security_group_id = module.payment.sg_id
}

#Backend ALB

# backend ALB accepting connections from Bastion SG
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
  security_group_id = module.backend_ALB_SG.sg_id

}

resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id #Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
  security_group_id = module.backend_ALB_SG.sg_id

}



resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_ALB_SG.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend_ALB_SG.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend_ALB_SG.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend_ALB_SG.sg_id
}

#Frontend
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.VPN-SG.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_ALB_SG.sg_id
  security_group_id = module.frontend.sg_id
}

#frontend ALB

# frontend ALB accepting https connections from internet

resource "aws_security_group_rule" "frontned_ALB-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ] # frontend needs to accept connections from internet securely(443 for security - https)
  security_group_id = module.frontend_ALB_SG.sg_id

}
# frontend ALB accepting http connections from internet

resource "aws_security_group_rule" "frontned_ALB-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ] # frontend needs to accept connections from internet securely(443 for security - https)
  security_group_id = module.frontend_ALB_SG.sg_id

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

