resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/health"
    port = 8080
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id     = local.private_subnet_id
  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )
}


#configuring catalogue

resource "terraform_data" "catalogue" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.catalogue.id
  ]
    # to configure instance first we need to connect to server.so we are connecting usnig private ip

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host    = aws_instance.catalogue.private_ip
		}

    #below code block will copy bootstrap file from our local folder to /tmp inside server
    provisioner "file" {
        source      = "catalogue.sh"
        destination = "/tmp/catalogue.sh"
        }

    # once copyied the code , we are giving it execute permission and running script 				  
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/catalogue.sh",
        "sudo sh /tmp/catalogue.sh catalogue"
        ]
  }
}
