terraform {
  required_version = "~> 1.15.0"
}

resource "terraform_data" "example" {
  input = {
    name        = "terraform-knowledge"
    environment = "example"
  }
}

output "example_name" {
  description = "The name carried by the example resource."
  value       = terraform_data.example.output.name
}