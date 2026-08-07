output "resource_input" {
  description = "Input values stored in the terraform_data resource."
  value       = terraform_data.example.input
}

output "resource_id" {
  description = "Generated resource identifier."
  value       = terraform_data.example.id
}