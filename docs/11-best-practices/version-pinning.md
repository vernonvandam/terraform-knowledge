# Terraform Version Pinning

## Overview

Version pinning is the practice of explicitly defining which versions of Terraform, providers, and modules are permitted within a Terraform configuration.

Proper version pinning is one of the most important practices for maintaining stable, predictable, and repeatable infrastructure deployments.

Without version pinning, Terraform deployments may behave differently over time as:

- New Terraform releases become available
- Providers introduce changes
- Modules are updated
- Features are deprecated
- Breaking changes are introduced

Version pinning ensures infrastructure deployments remain consistent across environments and over time.

---

## Why Version Pinning Matters

Terraform configurations depend on multiple components:

```text
Terraform CLI
        │
        ▼
Providers
        │
        ▼
Modules
        │
        ▼
Infrastructure
```

If any component changes unexpectedly, deployments may:

- Fail unexpectedly
- Produce different plans
- Introduce regressions
- Create configuration drift
- Cause outages

Version pinning reduces these risks.

---

## Risks of Unpinned Versions

### Unexpected Provider Upgrades

Example:

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
```

Terraform may automatically download a newer provider version.

Potential impacts:

- Behaviour changes
- New defaults
- Deprecated features
- Breaking changes

---

### Inconsistent Team Environments

Developer A:

```text
Terraform 1.12
```

Developer B:

```text
Terraform 1.13
```

Both may generate different plans from the same codebase.

Version pinning helps ensure consistency.

---

### Deployment Pipeline Differences

Example:

```text
Local Environment
     │
Terraform 1.12
```

CI/CD:

```text
Terraform 1.13
```

This can lead to unexpected results between development and production deployments.

---

## What Should Be Pinned?

Terraform implementations should pin:

### Terraform Version

```hcl
required_version
```

### Provider Versions

```hcl
required_providers
```

### Module Versions

```hcl
source + ref
```

Pinning all three layers provides the highest level of predictability.

---

# Terraform Version Pinning

## Required Terraform Version

Terraform versions should always be constrained.

Example:

```hcl
terraform {
  required_version = "~> 1.13"
}
```

Terraform will only allow compatible versions.

---

## Exact Version Pinning

Example:

```hcl
terraform {
  required_version = "= 1.13.2"
}
```

Only this exact version is accepted.

Benefits:

- Maximum consistency
- Fully predictable behaviour

Drawbacks:

- More maintenance
- Frequent updates required

---

## Minimum Version Constraint

Example:

```hcl
terraform {
  required_version = ">= 1.13"
}
```

This allows any newer version.

Risk:

Unexpected future versions may introduce incompatible behaviour.

Generally not recommended for production environments.

---

## Recommended Terraform Version Strategy

Most organizations adopt:

```hcl
required_version = "~> 1.13"
```

Benefits:

- Allows patch updates
- Prevents incompatible major upgrades
- Balances stability and flexibility

---

# Provider Version Pinning

## Why Pin Providers?

Providers contain the implementation logic that interacts with cloud platforms.

Examples:

- AzureRM
- AWS
- Google
- Kubernetes

Provider updates can introduce:

- New resources
- Changed defaults
- Feature removals
- API behaviour changes

Provider versions should always be pinned.

---

## Example Provider Constraint

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

This allows:

```text
4.0
4.1
4.2
4.5
```

But prevents:

```text
5.0
```

which may contain breaking changes.

---

## Avoid Unbounded Providers

Avoid:

```hcl
version = ">= 4.0"
```

or:

```hcl
source = "hashicorp/azurerm"
```

without a version constraint.

These approaches increase operational risk.

---

## Provider Lock Files

Terraform automatically generates:

```text
.terraform.lock.hcl
```

Example:

```text
.terraform.lock.hcl
```

This file records:

- Provider versions
- Checksums
- Installation metadata

---

## Commit Lock Files

The provider lock file should be committed to source control.

Benefits:

- Consistent deployments
- Reproducible builds
- Reduced supply-chain risk

Typical workflow:

```text
Developer
    │
    ▼
Provider Locked
    │
    ▼
Commit Lock File
    │
    ▼
Pipeline Uses Same Version
```

---

# Module Version Pinning

## Why Pin Modules?

Modules evolve over time.

Example:

```text
v1.0.0
v1.1.0
v2.0.0
```

A new release may introduce:

- New variables
- Modified outputs
- Resource changes
- Breaking changes

Consumers should explicitly choose module versions.

---

## Git Module Example

Preferred:

```hcl
module "networking" {

  source = "git::https://github.com/company/modules.git//networking?ref=v1.2.0"

}
```

This guarantees a known version.

---

## Registry Module Example

```hcl
module "networking" {

  source  = "company/networking/module"
  version = "1.2.0"

}
```

Terraform uses the specified module version.

---

## Avoid Branch References

Avoid:

```hcl
source = "git::https://github.com/company/modules.git//networking?ref=main"
```

Problems:

- Not repeatable
- Difficult troubleshooting
- Unexpected changes

Always use version tags.

---

# Understanding Version Constraints

Terraform supports several constraint operators.

---

## Exact Version

```hcl
version = "= 4.12.0"
```

Only:

```text
4.12.0
```

is allowed.

---

## Not Equal

```hcl
version = "!= 4.12.0"
```

Any version except:

```text
4.12.0
```

is allowed.

Useful when avoiding known bad releases.

---

## Greater Than

```hcl
version = "> 4.0"
```

Allows:

```text
4.1
4.5
5.0
6.0
```

Generally too broad for production use.

---

## Greater Than Or Equal

```hcl
version = ">= 4.0"
```

Allows any version beyond the specified minimum.

Higher operational risk.

---

## Less Than

```hcl
version = "< 5.0"
```

Prevents adoption of major version 5.

Often combined with minimum constraints.

---

## Combined Constraints

Example:

```hcl
version = ">= 4.0, < 5.0"
```

Allows:

```text
4.x
```

but blocks:

```text
5.x
```

---

## Pessimistic Operator (~>)

The most common approach.

Example:

```hcl
version = "~> 4.0"
```

Allows:

```text
4.0
4.1
4.2
4.99
```

Blocks:

```text
5.0
```

This is typically the recommended strategy.

---

# Upgrading Versions Safely

## Review Release Notes

Before upgrading:

Review:

- Terraform release notes
- Provider release notes
- Module release notes

Understand:

- Breaking changes
- Deprecations
- New requirements

---

## Test In Lower Environments

Upgrade path:

```text
Development
      │
      ▼
Test
      │
      ▼
Staging
      │
      ▼
Production
```

Never upgrade directly in production.

---

## Regenerate Plans

After upgrades:

```bash
terraform init -upgrade
```

Then:

```bash
terraform plan
```

Review all proposed changes carefully.

---

## Upgrade Incrementally

Avoid:

```text
Terraform 1.8
      │
      ▼
Terraform 1.13
```

in a single step.

Smaller upgrades reduce risk and simplify troubleshooting.

---

# Version Pinning in CI/CD

## Standardize Terraform Versions

CI/CD should use the same Terraform version as development environments.

Example:

```text
Developer Workstation
Terraform 1.13.2

CI/CD Pipeline
Terraform 1.13.2
```

Consistency reduces deployment surprises.

---

## Lock Provider Versions

Ensure pipelines utilize:

```text
.terraform.lock.hcl
```

committed to source control.

This guarantees consistent provider installs.

---

## Validate Version Requirements

During pipeline execution:

```bash
terraform init
terraform validate
```

Terraform will fail if incompatible versions are used.

This helps prevent invalid deployments.

---

# Enterprise Recommendations

Organizations should define:

### Approved Terraform Versions

Example:

```text
Terraform 1.13.x
```

---

### Approved Provider Versions

Example:

```text
AzureRM 4.x
AWS 6.x
```

---

### Approved Modules

Use:

```text
Internal Module Registry
```

or approved repositories.

---

### Upgrade Governance

Implement:

- Change approval
- Testing requirements
- Release reviews
- Documentation updates

This reduces upgrade-related risks.

---

# Common Version Pinning Mistakes

## No Version Constraints

Avoid:

```hcl
required_providers {
  azurerm = {
    source = "hashicorp/azurerm"
  }
}
```

---

## Ignoring Lock Files

Avoid deleting:

```text
.terraform.lock.hcl
```

without understanding the impact.

---

## Using Module Branches

Avoid:

```text
main
master
develop
```

references.


Use tagged