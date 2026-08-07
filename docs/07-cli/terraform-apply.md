# `terraform apply`

`terraform apply` performs the changes proposed by a plan.

```shell
terraform apply
terraform apply tfplan
```

Use the interactive form for normal local work so Terraform presents the plan before confirmation. In automation, apply a reviewed saved plan with an identity limited to the target environment. Do not make `-auto-approve` the default interactive habit.

An apply can partially succeed if a provider operation fails. Inspect the resulting state and run a new plan before retrying or attempting manual recovery.