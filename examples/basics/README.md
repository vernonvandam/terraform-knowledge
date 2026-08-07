# Basic Terraform example

A minimal executable root module demonstrating a Terraform version contract, a built-in `terraform_data` resource, an output, and a plan-only Terraform test. No provider, backend, cloud account, or credential is needed.

```shell
terraform init -backend=false
terraform fmt
terraform validate
terraform test
terraform plan
```