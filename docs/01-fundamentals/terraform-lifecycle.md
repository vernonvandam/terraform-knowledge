# Terraform lifecycle

Terraform's normal lifecycle is initialise, format, validate, plan, apply, and maintain.

| Command | Purpose |
| --- | --- |
| `terraform init` | Install dependencies and initialise the backend. |
| `terraform fmt` | Format Terraform files. |
| `terraform validate` | Check configuration structure. |
| `terraform plan` | Calculate proposed changes. |
| `terraform apply` | Execute an approved plan. |

Review every plan. Treat `-target` as a recovery tool rather than routine deployment control. Detect drift with regular plans, decide which system owns the change, then align configuration or intentionally revert the remote change.