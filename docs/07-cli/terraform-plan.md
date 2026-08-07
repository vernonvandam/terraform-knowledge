# `terraform plan`

`terraform plan` compares configuration, state, and remote infrastructure to calculate proposed changes.

```shell
terraform plan
terraform plan -out=tfplan
```

Review additions, changes, replacements, and destruction before applying. In controlled automation, save an approved plan and apply that same immutable plan file. Do not commit plan files: they can contain sensitive data and become stale when state changes.

Avoid routine `-target`; it can leave the dependency graph partially converged. Use it only for documented recovery or exceptional workflows.