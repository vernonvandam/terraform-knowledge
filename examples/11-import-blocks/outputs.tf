output "resource_id" {
  description = "Imported resource identifier."

  value = terraform_data.application.id
}

output "application_details" {
  description = "Application information."

  value = terraform_data.application.input
}