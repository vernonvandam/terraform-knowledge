# `terraform validate`

`terraform validate` checks configuration syntax and internal consistency without contacting remote infrastructure.

```shell
terraform init -backend=false
terraform validate
```

Initialisation is required because validation needs installed providers and modules. Validation cannot prove a provider configuration, remote permissions, or a planned change is correct; run `terraform plan` for that.

Use it in CI for every Terraform root and example.