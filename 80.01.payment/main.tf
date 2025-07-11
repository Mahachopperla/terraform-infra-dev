module "payment" {
  source = "../../terraform-roboshop-module"
  component = "payment"
  rule_priority = 30

}