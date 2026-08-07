# Provider authentication

Authenticate providers with short-lived, least-privilege credentials whenever possible. Prefer workload identity, federation, managed identities, or an approved credential process over long-lived static keys.

Keep credentials out of Terraform configuration, `*.tfvars`, plans, logs, and version control. Supply them through the provider's supported environment variables, external credential process, or CI identity. Restrict the identity to the operations the configuration needs and separate read-only plan identities from apply identities where appropriate.

State can contain sensitive provider-returned values. Protect backend access independently of input secrecy. Rotate compromised credentials, remove them from history where necessary, and review the plan after changing authentication or identity scope.