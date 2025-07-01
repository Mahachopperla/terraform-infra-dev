#mongodb setup

resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id     = local.database_subnet_id
  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

#here terraform will create instance. upon instance creation ,we'll connect to isntance and run
resource "terraform_data" "mongodb" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.mongodb.id
  ]
    # to configure instance first we need to connect to server.so we are connecting usnig private ip

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host    = aws_instance.mongodb.private_ip
		}

    #below code block will copy bootstrap file from our local folder to /tmp inside server
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
        }

    # once copyied the code , we are giving it execute permission and running script 				  
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb"
        ]
  }
}

# redis setup

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id     = local.database_subnet_id
  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-redis"
    }
  )
}

#here terraform will create instance. upon instance creation ,we'll connect to isntance and run
resource "terraform_data" "redis" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.redis.id
  ]
    # to configure instance first we need to connect to server.so we are connecting usnig private ip

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host    = aws_instance.redis.private_ip
		}

    #below code block will copy bootstrap file from our local folder to /tmp inside server
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
        }

    # once copyied the code , we are giving it execute permission and running script 				  
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis"
        ]
  }
}

# mysql setup

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id     = local.database_subnet_id
  iam_instance_profile = "EC2allowedtoFetchSSMParams" # here we create a role to access ssm params and assigning it to mysql. so that it mysql instance can access ssm prams store to fetch passowrd
  # make sure u have required password in ssm parameter store 
  # we need to add passwords manually in ssm parameters in real time also
  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-mysql"
    }
  )
}

#here terraform will create instance. upon instance creation ,we'll connect to isntance and run
resource "terraform_data" "mysql" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.mysql.id
  ]
    # to configure instance first we need to connect to server.so we are connecting usnig private ip

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host    = aws_instance.mysql.private_ip
		}

    #below code block will copy bootstrap file from our local folder to /tmp inside server
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
        }

    # once copyied the code , we are giving it execute permission and running script 				  
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "pip3 install boto3 botocore",
        "sudo sh /tmp/bootstrap.sh mysql"
        ]
  }
}

# rabbitmq setup

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id     = local.database_subnet_id
  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}

#here terraform will create instance. upon instance creation ,we'll connect to isntance and run
resource "terraform_data" "rabbitmq" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
    # to configure instance first we need to connect to server.so we are connecting usnig private ip

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host    = aws_instance.rabbitmq.private_ip
		}

    #below code block will copy bootstrap file from our local folder to /tmp inside server
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
        }

    # once copyied the code , we are giving it execute permission and running script 				  
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh rabbitmq"
        ]
  }
}

# creating records for dabases created

resource "aws_route53_record" "mongodb" {
  zone_id = var.hosted_zone_id
  name    = "mongodb-dev.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.hosted_zone_id
  name    = "redis-dev.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  zone_id = var.hosted_zone_id
  name    = "mysql-dev.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.hosted_zone_id
  name    = "rabbitmq-dev.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}
