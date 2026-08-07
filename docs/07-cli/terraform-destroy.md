# `terraform destroy`

`terraform destroy` proposes removal of every managed object in the current root and state.

```shell
terraform destroy
```

Treat destruction as a high-risk, reviewed operation. Confirm the selected backend, environment, and workspace before proceeding, then inspect the destroy plan carefully. Retain backups or exports required by the service's recovery and retention policies.

For normal lifecycle changes, remove or alter configuration and use `terraform plan`; do not use destroy as a shortcut for a targeted replacement.