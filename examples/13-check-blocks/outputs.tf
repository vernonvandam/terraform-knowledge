output "application_details" {
  description = "Application information."

  value = terraform_data.application.input
}

output "resource_id" {
  description = "Terraform resource identifier."

  value = terraform_data.application.id
}