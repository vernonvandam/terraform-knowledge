output "applications" {
  description = "Applications created using for_each."

  value = {
    for key, resource in terraform_data.application :
    key => resource.input
  }
}

output "application_names" {
  description = "Application names."

  value = keys(terraform_data.application)
}

output "application_count" {
  description = "Total number of applications."

  value = length(terraform_data.application)
}