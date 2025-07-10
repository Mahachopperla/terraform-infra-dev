module "compoenents" {
    source = "../../terraform-roboshop-module"
    for_each = var.components
    component = each.key
    rule_priority = each.value.rule_priority
  
}