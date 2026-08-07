locals {
  generated_rules = [
    for rule in var.network_rules : {
      name     = rule.name
      priority = rule.priority
      action   = rule.action
    }
  ]
}

resource "terraform_data" "network_configuration" {
  input = {
    rules = local.generated_rules
  }
}