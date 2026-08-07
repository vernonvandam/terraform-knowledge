resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
    version     = "1.0.0"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      input["version"]
    ]
  }
}

resource "terraform_data" "configuration" {
  input = {
    config_version = "1.0"
  }
}

resource "terraform_data" "deployment" {
  input = {
    application = terraform_data.application.input.application
  }

  lifecycle {
    replace_triggered_by = [
      terraform_data.configuration
    ]
  }
}