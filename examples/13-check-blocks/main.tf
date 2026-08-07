locals {
  application_name = "customer-api"
  environment      = "dev"

  allowed_environments = [
    "dev",
    "test",
    "prod"
  ]
}

resource "terraform_data" "application" {
  input = {
    application = local.application_name
    environment = local.environment
  }
}

check "environment_validation" {

  assert {
    condition = contains(
      local.allowed_environments,
      terraform_data.application.input.environment
    )

    error_message = "Environment must be dev, test, or prod."
  }

}

check "application_name_validation" {

  assert {
    condition = length(
      terraform_data.application.input.application
    ) > 0

    error_message = "Application name cannot be empty."
  }

}