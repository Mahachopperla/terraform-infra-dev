#!/bin/bash

#here terraform will create instance. upon instance creation ,we'll connect to isntance and run
#below script to configure servers.


# this script installs ansible and pull ansible roles into the server which is getting created
dnf install ansible -y
ansible-pull -U https://github.com/Mahachopperla/roboshop-ansible-roles.git -e component=$1 main.yaml