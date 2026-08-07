# Terraform Secrets Management

## Overview

Secrets are sensitive pieces of information that must be protected throughout their lifecycle.

Examples include:

- Passwords
- API keys
- Access tokens
- Database connection strings
- Certificates
- Encryption keys
- Client secrets

Improper secret management is one of the most common security weaknesses in Terraform implementations.

A secure Terraform solution should ensure that secrets are:

- Never exposed unnecessarily
- Stored securely
- Accessed using least privilege
- Rotated regularly
- Auditable
- Protected in transit and at rest

---

## Why Secrets Management Matters

Poor secret management can lead to:

- Data breaches
- Privilege escalation
- Unauthorized access
- Compliance violations
- Service compromise
- Production outages

Infrastructure as Code increases the risk of accidental secret exposure because infrastructure definitions are often:

- Shared across teams
- Stored in source control
- Processed by CI/CD pipelines
- Logged during deployments

For this reason, secrets management should be treated as a core Terraform design requirement.

---

## What Is Considered a Secret?

Common infrastructure secrets include:

### Authentication Credentials

Examples:

```text
Usernames
Passwords
SSH Keys
Client Secrets
```

---

### Database Credentials

Examples:

```text
Database Passwords
Connection Strings
Database Keys
```

---

### Cloud Access Credentials

Examples:

```text
AWS Access Keys
Azure Client Secrets
GCP Service Account Keys
```

---

### Application Secrets

Examples:

```text
API Keys
Webhook Secrets
OAuth Tokens
JWT Signing Keys
```

---

### Encryption Material

Examples:

```text
Certificates
Private Keys
Encryption Keys
TLS Keys
```

All sensitive information should be treated as a secret unless explicitly proven otherwise.

---

# Common Mistakes

## Hardcoding Secrets

Bad:

```hcl
resource "azurerm_sql_server" "main" {

  administrator_login_password = "P@ssw0rd123!"

}
```

Problems:

- Visible in source code
- Visible in pull requests
- Stored permanently in Git history
- Difficult to rotate

Never hardcode secrets in Terraform code.

---

## Storing Secrets in Variables Files

Bad:

```hcl
db_password = "P@ssw0rd123!"
```

inside:

```text
terraform.tfvars
```

Even if excluded from source control, accidental exposure is common.

---

## Storing Secrets in Git Repositories

Never store secrets in:

```text
Git Repositories
GitHub
Azure DevOps
GitLab
Bitbucket
```

Once committed, even deleted secrets often remain recoverable in repository history.

---

## Sharing Secrets Through Chat or Email

Avoid:

```text
Email
Teams Messages
Slack Messages
Wiki Pages
Documentation
```

Secrets should be distributed through approved secret management systems.

---

# Principles of Secure Secret Management

## Principle 1: Never Store Secrets in Code

Terraform code should reference secrets, not contain secrets.

Bad:

```hcl
password = "SuperSecret123!"
```

Good:

```hcl
password = data.azurerm_key_vault_secret.db_password.value
```

---

## Principle 2: Use Centralized Secret Stores

Store secrets in dedicated secret management platforms.

Examples:

```text
Azure Key Vault
AWS Secrets Manager
HashiCorp Vault
Google Secret Manager
```

Benefits:

- Encryption
- Access control
- Rotation
- Auditing
- Centralized management

---

## Principle 3: Apply Least Privilege

Access to secrets should be restricted.

Example:

```text
Application A
    │
    ▼
Database Password Only
```

Instead of:

```text
Application A
    │
    ▼
Access To All Secrets
```

Grant only the permissions required.

---

## Principle 4: Rotate Secrets Regularly

Secrets should have defined rotation schedules.

Examples:

```text
30 Days
60 Days
90 Days
```

depending on organizational requirements.

Automated rotation is preferred where supported.

---

## Principle 5: Audit Secret Access

Access to secrets should be logged.

Audit logs should record:

- Who accessed the secret
- When it was accessed
- What system accessed it
- Any modifications performed

Strong auditing supports governance and compliance requirements.

---

# Using Secret Management Systems

## Azure Key Vault

Example:

```hcl
data "azurerm_key_vault_secret" "db_password" {

  name         = "db-password"
  key_vault_id = azurerm_key_vault.main.id

}
```

Reference:

```hcl
administrator_login_password = data.azurerm_key_vault_secret.db_password.value
```

Benefits:

- Centralized storage
- Encryption
- RBAC integration
- Secret rotation support

---

## AWS Secrets Manager

Example:

```hcl
data "aws_secretsmanager_secret" "database" {
  name = "database-password"
}
```

Retrieves secrets securely without embedding values in code.

---

## HashiCorp Vault

Vault is commonly used in platform engineering environments.

Benefits:

- Dynamic secrets
- Secret leasing
- Rotation
- Fine-grained access control

Particularly useful in large enterprise environments.

---

# Terraform State and Secrets

## Secret Exposure in State Files

Many engineers assume:

```text
Secret Store = Secure
```

While true, Terraform state may still contain secret values.

Example:

```hcl
administrator_login_password
```

may appear in:

```text
terraform.tfstate
```

even if retrieved from a secret store.

State protection is therefore critical.

---

## Protect State Files

State should be:

- Encrypted at rest
- Encrypted in transit
- Access controlled
- Backed up securely
- Audited

Recommended backends:

```text
Azure Storage
Amazon S3
Terraform Cloud
HCP Terraform
```

---

## Never Commit State Files

Never commit:

```text
terraform.tfstate
terraform.tfstate.backup
```

to source control.

Add to:

```text
.gitignore
```

Example:

```gitignore
*.tfstate
*.tfstate.*
```

---

# Sensitive Variables

Terraform supports sensitive variables.

Example:

```hcl
variable "db_password" {

  type      = string
  sensitive = true

}
```

Benefits:

- Reduces accidental console exposure
- Hides values in standard output

Example:

```text
<sensitive>
```

instead of displaying the value.

---

## Sensitive Outputs

Outputs containing secrets should also be marked sensitive.

Example:

```hcl
output "database_password" {

  value     = var.db_password
  sensitive = true

}
```

Terraform will mask the output value.

---

## Important Limitation

Sensitive values may still be stored in state.

Sensitive variables:

```text
Hide Display
```

They do not:

```text
Encrypt State
```

State security remains essential.

---

# Secrets in CI/CD Pipelines

## Use Secure Pipeline Variables

Store pipeline secrets using platform-native secret stores.

Examples:

```text
GitHub Secrets
Azure DevOps Variable Groups
GitLab Protected Variables
```

Avoid:

```yaml
TF_VAR_password: SuperSecret123
```

hardcoded directly in pipeline definitions.

---

## Use Federated Identity

Whenever possible, avoid client secrets completely.

Preferred:

```text
Workload Identity Federation
Managed Identity
OIDC Federation
```

Benefits:

- No passwords
- No secret rotation
- Reduced risk
- Improved security

---

## Prevent Secret Logging

Avoid:

```bash
echo $PASSWORD
```

or:

```bash
printenv
```

Pipeline logs are often retained for long periods and may expose credentials.

---

## Restrict Pipeline Access

Limit who can:

- View variables
- Modify variables
- Trigger deployments
- Access logs

Strong pipeline governance reduces the risk of credential exposure.

---

# Secret Rotation

## Why Rotate Secrets?

Over time secrets may become:

- Exposed
- Shared
- Forgotten
- Cached
- Compromised

Regular rotation limits exposure.

---

## Rotation Strategy

Recommended process:

```text
Create New Secret
        │
        ▼
Update Secret Store
        │
        ▼
Validate Systems
        │
        ▼
Retire Old Secret
```

Automated rotation is preferred.

---

# Secrets and Module Design

Modules should never contain:

```hcl
default = "SuperSecretPassword"
```

Instead:

```hcl
variable "secret_name" {
  type = string
}
```

and retrieve the actual secret separately.

This improves:

- Reusability
- Security
- Environment portability

---

# Common Anti-Patterns

## Plain Text Passwords

Avoid:

```hcl
password = "Password123!"
```

---

## Secret Defaults

Avoid:

```hcl
variable "password" {

  default = "Password123!"

}
```

---

## Secret Outputs

Avoid exposing secrets unless absolutely necessary.

---

## Shared Administrative Credentials

Avoid:

```text
Shared Service Accounts
Shared Passwords
```

Use individual identities wherever possible.

---

## Long-Lived Secrets

Secrets that never rotate become increasingly risky over time.

Implement rotation policies.

---

# Enterprise Recommendations

Organizations should implement:

### Secret Storage

- Azure Key Vault
- AWS Secrets Manager
- HashiCorp Vault
- Google Secret Manager

### Access Controls

- RBAC
- Least privilege
- Approval workflows

### Monitoring

- Access auditing
- Alerting
- Security monitoring

### Rotation

- Automated rotation
- Regular reviews
- Secret expiry policies

### Governance

- No secrets in source control
- No secrets in documentation
- No secrets in code reviews

---

# Secrets Management Checklist

### Storage

- Use centralized secret stores
- Encrypt secrets
- Enable auditing

### Access

- Implement least privilege
- Use managed identities where possible
- Eliminate shared credentials

### Development

- Never hardcode secrets
- Never commit secrets
- Mark sensitive values appropriately

### CI/CD

- Use secure pipeline secrets
- Prevent secret logging
- Restrict pipeline permissions

### Operations

- Rotate secrets regularly
- Audit secret usage
- Monitor access patterns

---

# Key Takeaways

- Secrets should never be hardcoded into Terraform configurations.
- Terraform should reference secrets from dedicated secret management systems.
- State files may contain secret values and must be protected accordingly.
- Sensitive variables hide output but do not encrypt data in state.
- CI/CD pipelines should use secure secret storage and avoid exposing credentials in logs.
- Workload identities and federated authentication are preferred over long-lived secrets.
- Secret rotation, auditing, and least-privilege access are essential security practices.
- Mature Terraform platforms treat secrets as a critical security concern and implement layered controls to protect them throughout their lifecycle.