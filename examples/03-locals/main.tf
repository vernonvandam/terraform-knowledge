resource "terraform_data" "application" {
  input = {
    application = var.application_name
    environment = var.environment
  }
}