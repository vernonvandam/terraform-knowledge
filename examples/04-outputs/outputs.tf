output "application_name" {
  description = "Application name supplied to the configuration."
  value       = var.application_name
}

output "environment" {
  description = "Deployment environment."
  value       = var.environment
}

output "resource_name" {
  description = "Generated resource name."
  value       = local.resource_name
}

output "resource_id" {
  description = "Terraform-generated resource identifier."
  value       = terraform_data.application.id
}

output "resource_details" {
  description = "Complete resource input object."
  value       = terraform_data.application.input
}
