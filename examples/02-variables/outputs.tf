output "application_details" {
  description = "Application information provided through variables."
  value = {
    application = var.application_name
    environment = var.environment
  }
}

output "resource_id" {
  description = "Terraform data resource identifier."
  value       = terraform_data.application.id
}