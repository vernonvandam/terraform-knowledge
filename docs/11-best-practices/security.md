# Terraform Security Best Practices

## Overview

Security should be a foundational component of every Terraform implementation.

Infrastructure as Code provides significant operational benefits, but it also introduces unique risks. Security vulnerabilities can be rapidly replicated across environments when insecure configurations are deployed through automation.

A secure Terraform implementation should focus on:

- Least privilege
- Secure defaults
- Secret protection
- Governance
- Continuous validation
- Compliance
- Infrastructure hardening
- Secure deployment pipelines

Security should be incorporated throughout the Terraform lifecycle rather than added as an afterthought.

---

## Shared Responsibility

Terraform itself is not responsible for securing infrastructure.

Terraform provides the mechanism to define infrastructure, but teams remain responsible for:

- Security design
- Access controls
- Governance
- Compliance
- Monitoring
- Secure configurations

Terraform can automate good practices, but it cannot compensate for poor security decisions.

---

## Security by Design

Infrastructure should be designed securely from the outset.

Avoid:

```text
Deploy First
Secure Later
```

Prefer:

```text
Design
   │
   ▼
Validate
   │
   ▼
Deploy
```

Security requirements should be incorporated during planning and architecture phases.

---

# Principle of Least Privilege

## Overview

The Principle of Least Privilege (PoLP) states that identities should receive only the permissions necessary to perform their tasks.

Excessive permissions increase the impact of:

- Credential compromise
- Human error
- Insider threats
- Application vulnerabilities

---

## Terraform Identities

Terraform service accounts should have only the permissions required for deployment.

Avoid:

```text
Global Administrator
Owner
AdministratorAccess
```

when more granular roles are available.

Prefer:

```text
Network Contributor
Storage Contributor
Reader
Custom Roles
```

where appropriate.

---

## Module Design

Modules should support least-privilege designs.

Avoid creating modules that require excessive permissions for operation.

Document required permissions clearly.

---

# Secure Authentication

## Avoid Long-Lived Credentials

Long-lived credentials increase risk.

Examples:

```text
Client Secrets
Access Keys
Shared Passwords
```

These credentials are often:

- Forgotten
- Reused
- Exposed
- Difficult to rotate

---

## Preferred Authentication Methods

Use:

```text
Managed Identity
Workload Identity
OIDC Federation
Federated Credentials
```

Benefits:

- No secret storage
- Automatic rotation
- Reduced attack surface

---

## Eliminate Shared Accounts

Avoid:

```text
terraform-admin
shared-admin
platform-admin
```

used by multiple people.

Use individual identities whenever possible.

Benefits:

- Accountability
- Auditing
- Better governance

---

# Secure State Management

## Protect State Files

Terraform state may contain:

- Resource metadata
- Connection information
- Secrets
- Resource identifiers

Treat state as sensitive information.

---

## Use Remote State

Recommended backends:

```text
Azure Storage
Amazon S3
Terraform Cloud
HCP Terraform
```

Avoid local state for shared environments.

---

## Enable Encryption

State should always be encrypted.

Requirements:

- Encryption at rest
- Encryption in transit

This reduces the risk of data exposure.

---

## Restrict State Access

State access should be limited to:

- Platform engineers
- Deployment pipelines
- Authorized administrators

Avoid broad access.

---

## Enable State Locking

State locking prevents:

- Concurrent writes
- State corruption
- Deployment conflicts

Always use backends that support state locking.

---

# Protect Sensitive Information

## Never Hardcode Secrets

Avoid:

```hcl
password = "SuperSecretPassword"
```

Secrets should never exist in source code.

---

## Use Dedicated Secret Stores

Examples:

```text
Azure Key Vault
AWS Secrets Manager
HashiCorp Vault
Google Secret Manager
```

Terraform should retrieve secrets, not store them.

---

## Protect Pipeline Variables

Store secrets in:

```text
GitHub Secrets
Azure DevOps Variable Groups
GitLab Protected Variables
```

Avoid exposing secrets in pipeline definitions.

---

## Mark Sensitive Variables

Example:

```hcl
variable "password" {

  type      = string
  sensitive = true

}
```

Benefits:

- Prevents accidental console output
- Reduces exposure in logs

---

# Secure Terraform Code

## Pin Terraform Versions

Always define supported Terraform versions.

Example:

```hcl
terraform {
  required_version = "~> 1.13"
}
```

Version pinning reduces unexpected behaviour.

---

## Pin Provider Versions

Example:

```hcl
terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

  }
}
```

Benefits:

- Predictable deployment behaviour
- Controlled upgrades
- Reduced supply chain risk

---

## Use Approved Modules

Avoid consuming unknown modules directly from public sources without review.

Establish approved module repositories.

Benefits:

- Consistent standards
- Improved security
- Better governance

---

## Review External Modules

Before adoption:

Verify:

- Source credibility
- Maintenance activity
- Security controls
- Licensing
- Community reputation

Treat third-party modules like third-party software.

---

# Secure Resource Configuration

## Encrypt Everything

Enable encryption wherever available.

Examples:

- Storage accounts
- Databases
- Virtual disks
- Backups
- Secrets

Encryption should be the default.

---

## Enable Logging

Where supported:

- Platform logging
- Audit logging
- Diagnostic logging
- Activity logging

Logging supports:

- Monitoring
- Incident response
- Forensics
- Compliance

---

## Enable Monitoring

Infrastructure should be monitored continuously.

Examples:

```text
Azure Monitor
CloudWatch
Cloud Logging
Datadog
Splunk
```

Monitoring enables rapid identification of suspicious activity.

---

## Enable Backup and Recovery

Critical workloads should implement:

- Backups
- Recovery testing
- Retention policies
- Disaster recovery procedures

Availability is a security requirement.

---

# Network Security

## Apply Network Segmentation

Separate workloads appropriately.

Examples:

```text
Management
Application
Database
Shared Services
```

Segmentation reduces lateral movement opportunities.

---

## Restrict Public Access

Default position:

```text
Private By Default
```

Only expose services publicly when justified.

Review:

- Public IPs
- Internet-facing load balancers
- Public storage access

regularly.

---

## Implement Zero Trust Principles

Verify:

- Identity
- Device
- Permissions
- Network path

Do not trust resources simply because they are inside a private network.

---

## Use Secure Connectivity

Examples:

```text
VPN
Private Endpoints
Private Link
Direct Connect
ExpressRoute
```

Reduce reliance on the public internet where possible.

---

# Shift-Left Security

## Validate Early

Security should be checked before deployment.

Example:

```bash
terraform validate
```

Validation identifies configuration issues early.

---

## Implement Security Scanning

Recommended tools:

```text
Checkov
Trivy
tfsec
TFLint
```

Security scans should run automatically.

---

## Scan Pull Requests

Example workflow:

```text
Pull Request
      │
      ▼
Validation
      │
      ▼
Linting
      │
      ▼
Security Scan
      │
      ▼
Review
```

Security issues should be identified before deployment.

---

# Policy as Code

## Overview

Policy as Code allows security requirements to be enforced automatically.

Benefits:

- Consistency
- Automation
- Governance
- Reduced human error

---

## Common Policy Engines

Examples:

```text
Open Policy Agent (OPA)
Sentinel
Azure Policy
AWS Config
```

Policies can prevent insecure deployments.

---

## Typical Security Policies

Examples:

### Require Encryption

```text
Storage Must Be Encrypted
```

### Require Tags

```text
Environment
Owner
Cost Centre
```

### Block Public Resources

```text
No Public Storage Accounts
```

### Restrict Regions

```text
Deploy Only To Approved Regions
```

Policies improve compliance and governance.

---

# CI/CD Security

## Secure Pipelines

Terraform deployments should occur through controlled CI/CD pipelines.

Recommended process:

```text
Commit
   │
   ▼
Validation
   │
   ▼
Security Scan
   │
   ▼
Plan
   │
   ▼
Approval
