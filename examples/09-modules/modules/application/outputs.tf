output "resource_name" {
  description = "Generated resource name."

  value = local.resource_name
}

output "application_id" {
  description = "Terraform-generated resource identifier."

  value = terraform_data.application.id
}

output "application_details" {
  description = "Application details."

  value = terraform_data.application.input
}