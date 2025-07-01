variable "frontend_sg_name" {
  type = string
  default = "frontend"
}

variable "frontend_sg_description" {
  type = string
  default = "Created sg for frontend instance"
}

variable "bastion_sg_name" {
  type = string
  default = "bastion"
}

variable "bastion_sg_description" {
  type = string
  default = "Created sg for bastion instance"
}

variable "ALB_sg_name" {
  type = string
  default = "ALB-SG"
}

variable "ALB_sg_description" {
  type = string
  default = "Created sg for Application Load Balancer"
}

variable "vpn_sg_name" {
  type = string
  default = "vpn-SG"
}

variable "vpn_sg_description" {
  type = string
  default = "Created sg for vpn"
}

variable "project" {
    type = string
    default = "roboshop"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "mongodb-ports" {
  type = list
  default = [22,27017]
}

variable "redis-ports" {
  type = list
  default = [22,6379]
}

variable "rabbitmq-ports" {
  type = list
  default = [22,5672]
}

variable "mysql-ports" {
  type = list
  default = [22,3306]
}