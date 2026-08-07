output "resource_id" {
  description = "Terraform resource identifier."

  value = terraform_data.application.id
}

output "application_details" {
  description = "Application details."

  value = terraform_data.application.input
}