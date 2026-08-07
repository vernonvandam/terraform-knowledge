output "resource_name" {
  description = "Generated resource name."

  value = module.application.resource_name
}

output "application_details" {
  description = "Application information."

  value = module.application.application_details
}
