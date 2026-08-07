locals {
  resource_name = "${var.application_name}-${var.environment}"
}

resource "terraform_data" "application" {
  input = {
    name        = local.resource_name
    application = var.application_name
    environment = var.environment
  }
}