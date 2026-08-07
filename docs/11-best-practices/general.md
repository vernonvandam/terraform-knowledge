# Terraform Best Practices

## Overview

Terraform enables teams to manage infrastructure consistently, repeatedly, and reliably through Infrastructure as Code (IaC).

However, Terraform's effectiveness depends heavily on implementation quality, governance, and operational discipline.

This document outlines recommended best practices for building maintainable, scalable, secure, and enterprise-ready Terraform solutions.

---

## Follow Infrastructure as Code Principles

Terraform configurations should be treated like application source code.

Infrastructure code should be:

- Version controlled
- Peer reviewed
- Automated
- Tested
- Documented

Avoid managing infrastructure through manual portal changes whenever possible.

The Terraform configuration should remain the authoritative source of truth.

---

## Use Source Control

All Terraform code should be stored in a source control repository.

Benefits include:

- Change tracking
- Auditability
- Collaboration
- Rollback capabilities
- Peer review

Recommended workflow:

```text
Feature Branch
      │
      ▼
Pull Request
      │
      ▼
Review
      │
      ▼
Merge
      │
      ▼
Deployment
```

Direct commits to production branches should be restricted.

---

## Adopt a Consistent Repository Structure

A standard repository layout improves readability and maintainability.

Example:

```text
terraform-project/
│
├── environments/
├── modules/
├── examples/
├── docs/
├── tests/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

Teams should use consistent layouts across repositories.

---

## Keep Configurations Modular

Large Terraform configurations become difficult to maintain.

Split infrastructure into logical modules.

Example:

```text
modules/
├── networking
├── compute
├── storage
└── monitoring
```

Modules should represent reusable infrastructure capabilities.

---

## Prefer Reuse Over Duplication

Avoid copying and pasting Terraform code.

Poor:

```text
network-dev.tf
network-test.tf
network-prod.tf
```

Preferred:

```text
module "networking"
```

with environment-specific variables.

Reusable code reduces maintenance effort and improves consistency.

---

## Keep Modules Focused

Each module should have a single purpose.

Good examples:

- Virtual Network
- Kubernetes Cluster
- Resource Group
- Storage Account

Avoid large modules that provision entire platforms.

Smaller modules are easier to test, maintain, and reuse.

---

## Separate Environments

Development, test, staging, and production environments should maintain separate state.

Example:

```text
environments/
├── dev
├── test
├── prod
```

Benefits include:

- Isolation
- Reduced risk
- Independent deployments
- Improved governance

---

## Use Remote State

Local state should not be used for shared environments.

Recommended backends:

- Azure Storage
- Amazon S3
- Terraform Cloud
- HCP Terraform

Benefits:

- Centralisation
- State locking
- Auditability
- Team collaboration

---

## Enable State Locking

State locking prevents concurrent modifications.

Without locking:

```text
User A
   +
User B
```

may update state simultaneously.

This can result in:

- Corruption
- Invalid plans
- Resource conflicts

Always use a backend that supports locking.

---

## Version Pin Terraform

Always define a minimum Terraform version.

Example:

```hcl
terraform {
  required_version = "~> 1.13"
}
```

This ensures predictable behaviour across environments.

---

## Version Pin Providers

Provider versions should also be constrained.

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

Avoid unbounded versions.

---

## Validate Early

Validation should occur before deployment.

Example:

```bash
terraform fmt
terraform validate
```

Validation prevents many common deployment failures.

---

## Implement Linting

Use consistent linting standards.

Example tools:

- TFLint
- Checkov
- Trivy

Linting helps detect:

- Style issues
- Misconfigurations
- Unsupported practices

before deployment.

---

## Review Every Plan

Never apply infrastructure changes without inspecting the plan.

Generate plans explicitly:

```bash
terraform plan
```

Review:

- Resource creation
- Resource updates
- Resource destruction

Plans should be approved before deployment.

---

## Use CI/CD Pipelines

Deploy Terraform through automated pipelines.

Example:

```text
Commit
   │
   ▼
Validate
   │
   ▼
Lint
   │
   ▼
Plan
   │
   ▼
Approval
   │
   ▼
Apply
```

Avoid direct production deployments from developer workstations.

---

## Minimise Manual Changes

Manual portal changes create drift.

Avoid:

```text
Terraform
     +
Portal Changes
```

Prefer:

```text
Terraform Only
```

All infrastructure modifications should be reflected in code.

---

## Detect Drift Regularly

Implement scheduled drift detection.

Example:

```bash
terraform plan -detailed-exitcode
```

Run daily or weekly through CI/CD.

Investigate all unexpected changes.

---

## Use Meaningful Naming Standards

Resource names should be:

- Predictable
- Descriptive
- Consistent

Example:

```text
rg-platform-prod
```

instead of:

```text
test-rg
```

Consistent naming improves governance and operational support.

---

## Enforce Resource Tagging

Recommended tags often include:

- Environment
- Application
- Owner
- Cost Centre
- Managed By

Example:

```hcl
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
}
```

Tags improve governance, reporting, and cost management.

---

## Protect Production Resources

Critical resources may require additional safeguards.

Examples:

- Databases
- Shared networks
- DNS zones

Consider:

```hcl
prevent_destroy = true
```

where appropriate.

Use carefully.

---

## Keep Secrets Out Of Terraform Code

Never store secrets in:

- Git repositories
- Variables files
- Source code

Prefer:

- Azure Key Vault
- AWS Secrets Manager
- HashiCorp Vault

Terraform should reference secrets rather than define them directly.

---

## Use Principle of Least Privilege

Terraform service accounts should receive only the permissions required to perform deployments.

Avoid:

```text
Global Administrator
```

when narrower permissions are available.

---

## Document Everything

Terraform repositories should contain:

- README files
- Architecture overview
- Module documentation
- Operational procedures

Documentation assists onboarding, troubleshooting, and governance.

---

## Test Before Production

Validate infrastructure changes in lower environments.

Example:

```text
Development
    │
    ▼
Test
    │
    ▼
Production
```

Never use production as a test environment.

---

## Monitor Terraform Usage

Track:

- Deployments
- State access
- Pipeline activity
- Failed plans
- Drift events

Visibility improves governance and operational maturity.

---

## Continuously Improve

Terraform practices should evolve over time.

Regularly review:

- Terraform versions
- Provider versions
- Module quality
- Security controls
- CI/CD processes

Infrastructure engineering should be treated as an ongoing discipline.

---

## Best Practices Checklist

### Development

- Use source control
- Follow naming standards
- Use reusable modules
- Validate configurations
- Review plans

### Operations

- Use remote state
- Enable state locking
- Detect drift regularly
- Monitor deployments
- Protect critical resources

### Security

- Use least privilege
- Store secrets securely
- Scan infrastructure code
- Restrict production access
- Implement governance controls

### Delivery

- Use CI/CD
- Test in lower environments
- Require approvals
- Version pin providers
- Version pin Terraform

---

## Key Takeaways

- Terraform should be treated as production software.
- Infrastructure changes should be made through code and automation.
- Reusable modules improve maintainability and consistency.
- Remote state and locking are mandatory for team environments.
- Validation, linting, testing, and CI/CD improve reliability.
- Drift detection and governance controls help maintain infrastructure integrity.
- Security, documentation, and operational discipline are essential components of successful Terraform adoption.
- Mature Terraform implementations prioritise automation, consistency, and repeatability over manual processes.