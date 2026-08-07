resource "terraform_data" "application" {
  count = var.instance_count

  input = {
    name  = "${var.application_name}-${count.index + 1}"
    index = count.index
  }
}