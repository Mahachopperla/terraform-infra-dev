module "vpc" {
    #we can use this modules directly from git repo using "syntax: "git::git-repo-url?ref=main""
    source = "git::https://github.com/Mahachopperla/terraform-vpc-module.git?ref=main"
    project = var.main_project
    environment = var.main_environment
    public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr = [ "10.0.11.0/24" , "10.0.12.0/24" ]
    database_subnet_cidr = [ "10.0.21.0/24" , "10.0.22.0/24" ]

    is_peering_required = false
    #if we want to enable peering then we will set it's value to true. by default it was set to false in module
}