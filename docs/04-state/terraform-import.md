# Importing existing infrastructure

Import connects an existing remote object to a Terraform resource address; it does not create complete configuration automatically.

Prefer an import block because it is reviewable and repeatable:

```hcl
import {
  to = aws_s3_bucket.logs
  id = "example-logs-bucket"
}
```

First write the resource configuration that represents the intended object, then plan and import. Review the post-import plan until it is empty or contains only intentional changes. Remove the import block after a successful apply if it is no longer needed.

Use `terraform import` only for an exceptional interactive workflow. Importing does not grant ownership in an organisational sense; confirm that Terraform should manage the object before adopting it.