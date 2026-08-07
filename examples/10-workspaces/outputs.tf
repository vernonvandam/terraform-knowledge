output "workspace" {
  description = "Current Terraform workspace."
  value       = terraform.workspace
}

output "resource_name" {
  description = "Generated workspace-specific resource name."
  value       = local.resource_name
}

output "instance_size" {
  description = "Workspace-specific instance size."
  value       = local.current_settings.instance_size
}

output "replicas" {
  description = "Workspace-specific replica count."
  value       = local.current_settings.replicas
}

output "resource_details" {
  description = "Resource configuration for the current workspace."
  value       = terraform_data.application.input
}