# State commands

State commands inspect or alter Terraform's record of object addresses. They are operational tools, not ordinary deployment commands.

| Command | Use |
| --- | --- |
| `terraform state list` | List tracked addresses. |
| `terraform state show ADDRESS` | Inspect one tracked object. |
| `terraform state mv FROM TO` | Move an address when a `moved` block cannot be used. |
| `terraform state rm ADDRESS` | Stop tracking an object without destroying it. |
| `terraform state pull` | Retrieve the current state for inspection. |

Run state commands only with a current backup, exclusive access, and a verified recovery path. Prefer declarative `moved` and `import` blocks because they are visible in code review. Always follow manual state work with `terraform plan`.