output "network_rules" {
  description = "Generated network rules."

  value = terraform_data.network_configuration.input.rules
}

output "rule_count" {
  description = "Number of generated rules."

  value = length(terraform_data.network_configuration.input.rules)
}