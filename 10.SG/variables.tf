variable "frontend_sg_name" {
  type = string
  default = "frontend"
}

variable "project" {
    type = string
    default = "roboshop"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "frontend_sg_description" {
  type = string
  default = "Created sg for frontend instance"
}