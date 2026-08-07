locals {
  application_name = "customer-api"

  resource_name = "${local.application_name}-${terraform.workspace}"

  environment_settings = {
    dev = {
      instance_size = "small"
      replicas      = 1
    }

    test = {
      instance_size = "medium"
      replicas      = 2
    }

    prod = {
      instance_size = "large"
      replicas      = 3
    }
  }

  current_settings = lookup(
    local.environment_settings,
    terraform.workspace,
    {
      instance_size = "small"
      replicas      = 1
    }
  )
}

resource "terraform_data" "application" {
  input = {
    application   = local.application_name
    workspace     = terraform.workspace
    resource_name = local.resource_name
    instance_size = local.current_settings.instance_size
    replicas      = local.current_settings.replicas
  }
}