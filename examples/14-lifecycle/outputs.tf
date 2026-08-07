output "application" {
  description = "Application configuration."

  value = terraform_data.application.input
}

output "deployment" {
  description = "Deployment configuration."

  value = terraform_data.deployment.input
}

output "configuration" {
  description = "Configuration information."

  value = terraform_data.configuration.input
}