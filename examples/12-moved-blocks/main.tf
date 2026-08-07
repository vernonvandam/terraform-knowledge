resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}

moved {
  from = terraform_data.app
  to   = terraform_data.application
}