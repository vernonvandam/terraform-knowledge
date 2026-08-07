resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}

locals {
  application_name = terraform_data.application.input.application
  environment      = terraform_data.application.input.environment
}