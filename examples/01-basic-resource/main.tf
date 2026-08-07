resource "terraform_data" "example" {
  input = {
    name        = "example-resource"
    environment = "dev"
  }
}