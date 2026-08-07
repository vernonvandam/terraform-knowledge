# `terraform console`

`terraform console` opens an interactive expression evaluator in the current Terraform context.

```shell
terraform console
> merge({ environment = "development" }, { owner = "platform" })
```

Use it to test functions, collection transformations, types, and variable values before encoding an expression in configuration. It can read configured values and state context, so avoid pasting secret material into shared terminals or logs.

Exit with `exit` or end-of-file. Console is a debugging aid, not a substitute for validation or a reviewed plan.