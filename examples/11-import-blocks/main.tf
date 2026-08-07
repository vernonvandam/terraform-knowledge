resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}

import {
  to = terraform_data.application
  id = "customer-api-dev"
}