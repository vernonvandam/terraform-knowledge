resource "terraform_data" "application" {
  for_each = var.applications

  input = {
    application = each.key
    environment = each.value.environment
  }
}