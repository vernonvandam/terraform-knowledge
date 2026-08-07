variable "applications" {
  description = "Applications to create."
  type = map(object({
    environment = string
  }))

  default = {
    customer-api = {
      environment = "dev"
    }

    inventory-api = {
      environment = "test"
    }

    billing-api = {
      environment = "prod"
    }
  }
}