# Infrastructure as code

Infrastructure as code stores desired infrastructure in version control instead of relying on console changes. It enables reviewable plans, repeatable environments, and an audit trail.

Terraform does not remove the need for sound design: use least privilege, protect state, review plans, and make ownership clear.

Recommended loop: change configuration, format and validate it, initialise without a backend where appropriate (`terraform init -backend=false`), review `terraform plan`, then apply through the approved workflow. Do not treat `-auto-approve` as the default interactive workflow.