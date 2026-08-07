# `terraform fmt`

`terraform fmt` applies Terraform's canonical formatting to configuration files.

```shell
terraform fmt -recursive
terraform fmt -check -recursive
```

Run the first command before committing. Use `-check` in CI so unformatted changes fail without modifying the checkout. Formatting improves review quality but does not validate semantics; pair it with `terraform validate`.