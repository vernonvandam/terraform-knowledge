run "exposes_the_example_name" {
  command = apply

  assert {
    condition     = output.example_name == "terraform-knowledge"
    error_message = "The example should expose its configured name."
  }
}