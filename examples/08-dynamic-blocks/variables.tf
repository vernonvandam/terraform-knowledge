variable "network_rules" {
  description = "Example network rules."

  type = list(object({
    name     = string
    priority = number
    action   = string
  }))

  default = [
    {
      name     = "allow-web"
      priority = 100
      action   = "Allow"
    },
    {
      name     = "allow-api"
      priority = 200
      action   = "Allow"
    }
  ]
}