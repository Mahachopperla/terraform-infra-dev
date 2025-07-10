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
        "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
        ]
  }
}

# stopping instance
resource "aws_ec2_instance_state" "catalogue-stop" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.catalogue ] # this will make sure that stop block will only executed only after successful execution of configuration block(terraform data)
}

# creating ami from fully configured catalogue instance
resource "aws_ami_from_instance" "catalogue-ami" {
  name               = "${var.project}-${var.environment}-catalogue_ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue-stop ]
}

# once ami is created we no longer require catalogue instance. hence terminating it
# there is no terraform resource that terminates ec2 so we are using cmnd line from local exec

resource "terraform_data" "catalogue-terminate" {
    # we are informing terraform to trigger this particular block whenver mongodb instance is created
  triggers_replace = [
    aws_instance.catalogue.id
  ]
   

     # make sure you have aws configure in your laptop				  
    provisioner "local-exec" {
       command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
  depends_on = [ aws_ami_from_instance.catalogue-ami ]
}


# now we need to launch template using created ami

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue_template"

  image_id = aws_ami_from_instance.catalogue-ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = [local.catalogue_sg_id]

#   here we dont have direct tags. here during launch template and instance and volume will also be created.
# 			so for each resource we need to specify tags separately

    #instance tags
  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-catalogue_template"
    }
    )
  }
  # volume tags
  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-catalogue_template"
    }
    )
  }
    #launch template tags
    tags = merge(local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-catalogue_template"
    }
    )
    update_default_version = true

}

# once launch template is ready , using this we need to create autoscaling group

resource "aws_autoscaling_group" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue_ASG"
  max_size                  = 5
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 120
  health_check_type         = "ELB"
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  vpc_zone_identifier = local.private_subnet_ids

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  dynamic "tag" {
			for_each = merge(
			  local.common_Tags,
			  {
				Name = "${var.project}-${var.environment}-catalogue_instance"
			  }
			)
			content{
			  key                 = tag.key
			  value               = tag.value
			  propagate_at_launch = true
			}
			
		  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 75
    }
    triggers = ["launch_template"]
  }

  timeouts {
    delete = "15m"
  }
}

#Now , let's setup autoscaling policy -> means giving instruction to autoscaling when it should scale pur ot scale-in resources

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${var.project}-${var.environment}-catalogue_asgpolicy"
  policy_type            = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }


}

#listener rule -> whenver user hit on catalogue domain what should happen internally we need to set here

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-${var.environment}.${var.hosted_zone_name}"]
    }
  }
}

