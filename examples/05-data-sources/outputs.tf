output "application_name" {
  description = "Application name retrieved from existing data."
  value       = local.application_name
}

output "environment" {
  description = "Environment retrieved from existing data."
  value       = local.environment
}

output "application_details" {
  description = "Complete data object."
  value       = terraform_data.application.input
}
