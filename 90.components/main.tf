module "compoenents" {
    source = "git::https://github.com/Mahachopperla/terraform-roboshop-module.git?ref=main"
    for_each = var.components
    component = each.key
    rule_priority = each.value.rule_priority
  
}