locals {
  resource_name = "${var.application_name}-${var.environment}"
}

resource "terraform_data" "application" {
  input = {
    application = var.application_name
    environment = var.environment
    name        = local.resource_name
  }
}