output "resource_names" {
  description = "Names generated using count."
  value = [
    for resource in terraform_data.application :
    resource.input.name
  ]
}

output "resource_ids" {
  description = "Generated resource identifiers."
  value = [
    for resource in terraform_data.application :
    resource.id
  ]
}

output "resource_count" {
  description = "Number of created resources."
  value       = length(terraform_data.application)
}