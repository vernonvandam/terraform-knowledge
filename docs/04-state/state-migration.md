# State migration

Migrate state deliberately when changing a backend, splitting a state boundary, or moving resource addresses.

For a backend change, update the backend block and run `terraform init -migrate-state`; review the prompt and confirm that the destination is correct. Back up or verify the existing state first.

Use `moved` blocks for configuration address refactors:

```hcl
moved {
  from = aws_instance.old_name
  to   = aws_instance.application
}
```

Do not edit state files by hand. For a state split or merge, plan the procedure, restrict concurrent changes, use targeted state commands only with a tested recovery plan, and validate the resulting plan before applying.