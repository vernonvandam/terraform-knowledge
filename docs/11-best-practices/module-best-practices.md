# Terraform Module Best Practices

## Overview

Modules are the foundation of reusable Terraform architecture.

A well-designed module enables teams to:

- Standardise infrastructure deployments
- Reduce code duplication
- Improve maintainability
- Enforce engineering standards
- Accelerate delivery
- Improve consistency across environments

Poorly designed modules often become difficult to maintain, difficult to upgrade, and difficult to adopt.

This guide outlines best practices for designing, implementing, and maintaining Terraform modules at scale.

---

## Design Modules Around a Single Responsibility

A module should have one clear purpose.

Good examples:

```text
Virtual Network Module
Resource Group Module
Storage Module
Kubernetes Module
Virtual Machine Module
```

Avoid modules that attempt to build an entire environment.

Poor example:

```text
Production Platform Module

Creates:
- Networking
- Security
- Storage
- Compute
- Monitoring
- DNS
```

Large modules are harder to maintain, test, and reuse.

---

## Build for Reuse

Modules should be reusable across:

- Development
- Test
- Staging
- Production

Avoid environment-specific values.

Bad:

```hcl
location = "australiaeast"
```

Preferred:

```hcl
variable "location" {
  type = string
}
```

The consuming configuration should supply environment-specific values.

---

## Keep Module Interfaces Simple

Good modules are easy to understand.

Limit the number of required variables.

Bad:

```text
35 Required Variables
```

Preferred:

```text
Core Variables
+
Reasonable Defaults
```

Consumers should be able to deploy the module with minimal configuration.

---

## Provide Sensible Defaults

Variables should include defaults where appropriate.

Example:

```hcl
variable "sku" {
  type    = string
  default = "Standard"
}
```

Benefits:

- Reduced complexity
- Faster adoption
- Easier testing

Avoid defaults for values that must be explicitly chosen.

Examples:

- Passwords
- Environment names
- Resource names

---

## Validate Input Variables

All important inputs should include validation.

Example:

```hcl
variable "environment" {
  type = string

  validation {
    condition = contains(
      ["dev", "test", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, test, or prod."
  }
}
```

Benefits:

- Early failure detection
- Better error messages
- Improved reliability

---

## Minimise Input Parameters

Only expose configuration that consumers genuinely need.

Bad:

```text
50 Input Variables
```

Good:

```text
10-15 Well Defined Inputs
```

Too many inputs make modules difficult to understand and maintain.

---

## Minimise Outputs

Expose only useful information.

Good outputs:

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.this.id
}
```

Avoid exposing every attribute.

Too many outputs increase coupling between modules.

---

## Maintain Stable Interfaces

Changing module inputs or outputs can impact all consumers.

Avoid:

```hcl
variable "resource_group_name"
```

becoming:

```hcl
variable "rg_name"
```

without a migration strategy.

Module interfaces should evolve carefully.

---

## Use Semantic Versioning

Version modules consistently.

Example:

```text
v1.0.0
v1.1.0
v1.2.0
v2.0.0
```

Guidelines:

```text
MAJOR.MINOR.PATCH
```

Major:

```text
Breaking Changes
```

Minor:

```text
Backward Compatible Features
```

Patch:

```text
Bug Fixes
```

Consumers should pin module versions.

---

## Pin Module Versions

Avoid consuming modules directly from a branch.

Bad:

```hcl
source = "git::https://github.com/company/modules.git//networking"
```

Preferred:

```hcl
source = "git::https://github.com/company/modules.git//networking?ref=v1.2.0"
```

Benefits:

- Predictability
- Controlled upgrades
- Reduced deployment risk

---

## Follow Standard Terraform File Structure

Recommended module structure:

```text
module/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── README.md
├── examples/
└── tests/
```

Consistent structures reduce onboarding effort.

---

## Separate Logic From Configuration

Module logic belongs inside the module.

Environment values belong outside the module.

Good:

```hcl
module "networking" {

  source = "../modules/networking"

  location = var.location

}
```

Avoid embedding environment-specific decisions within modules.

---

## Use Strong Typing

Always specify variable types.

Bad:

```hcl
variable "tags" {}
```

Preferred:

```hcl
variable "tags" {
  type = map(string)
}
```

Benefits:

- Better validation
- Improved readability
- Reduced runtime errors

---

## Use Locals for Internal Logic

Keep resource definitions clean.

Example:

```hcl
locals {

  resource_name = "${var.project}-${var.environment}"

}
```

Use:

```hcl
name = local.resource_name
```

rather than repeating logic throughout resources.

---

## Avoid Hardcoded Values

Bad:

```hcl
resource_group_name = "rg-prod"
```

Preferred:

```hcl
resource_group_name = var.resource_group_name
```

Hardcoded values reduce module flexibility.

---

## Implement Consistent Naming

Resource naming should be predictable.

Example:

```text
rg-platform-prod
st-platform-prod
vnet-platform-prod
```

Use naming conventions consistently across all modules.

---

## Enforce Tagging Standards

Modules should support organisational tagging standards.

Example:

```hcl
tags = var.tags
```

Recommended tags:

- Environment
- Application
- Owner
- Cost Centre
- Managed By

Standardised tagging improves governance and reporting.

---

## Support Lifecycle Management Carefully

Use lifecycle controls only when justified.

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Appropriate for:

- Production databases
- Shared services
- Critical networking resources

Avoid embedding lifecycle controls that reduce module flexibility.

---

## Avoid Excessive Conditional Logic

Bad:

```hcl
terraform.workspace == "prod"
```

used repeatedly throughout a module.

Excessive conditionals increase complexity.

Prefer:

```hcl
variable-driven configuration
```

where possible.

---

## Limit Resource Counts

Large modules managing hundreds of resources become difficult to maintain.

Instead of:

```text
One Large Platform Module
```

Prefer:

```text
Networking Module
+
Compute Module
+
Storage Module
+
Monitoring Module
```

Smaller modules are easier to understand and test.

---

## Document Everything

Every module should include a README.

Recommended sections:

```text
Overview
Requirements
Inputs
Outputs
Examples
Version History
```

Good documentation significantly reduces support effort.

---

## Provide Usage Examples

Every module should include practical examples.

Structure:

```text
examples/
├── basic
├── advanced
└── production
```

Examples allow consumers to get started quickly.

---

## Test Modules

Modules should be tested independently.

Validate:

```bash
terraform fmt
terraform validate
tflint
```

Where possible:

- Unit testing
- Integration testing
- Deployment testing

Testing improves confidence and stability.

---

## Implement CI/CD Validation

Module repositories should automatically validate:

```text
Code Commit
      │
      ▼
Format Check
      │
      ▼
Validation
      │
      ▼
Linting
      │
      ▼
Security Scan
```

Automated quality gates reduce defects.

---

## Keep Modules Backward Compatible

Whenever possible:

- Add new variables with defaults
- Maintain existing outputs
- Avoid breaking interface changes

Backward compatibility reduces operational risk.

---

## Use Moved Blocks During Refactoring

When renaming resources or restructuring modules:

```hcl
moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.application_logs
}
```

This avoids resource recreation and downtime.

---

## Security Considerations

Modules should:

- Support least privilege
- Avoid storing secrets
- Use secure defaults
- Support encryption
- Support logging and monitoring

Security should be built into module design rather than added later.

---

## Common Module Anti-Patterns

### Platform Modules

Avoid modules that attempt to deploy entire environments.

### Hardcoded Values

Avoid environment-specific configuration.

### Excessive Inputs

Too many variables create unnecessary complexity.

### Excessive Outputs

Too many outputs create tight coupling.

### Breaking Changes

Avoid unnecessary interface changes.

### No Documentation

Undocumented modules have poor adoption and higher support costs.

---

## Example High-Quality Module Structure

```text
modules/
└── storage-account/
    │
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    ├── README.md
    │
    ├── examples/
    │   ├── basic
    │   └── production
    │
    └── tests/
```

This structure is simple, maintainable, and scalable.

---

## Module Design Checklist

### Design

- Single responsibility
- Reusable
- Environment agnostic
- Consistent naming

### Inputs

- Strongly typed
- Validated
- Well documented
- Minimal required inputs

### Outputs

- Useful
- Stable
- Documented

### Quality

- Tested
- Linted
- Documented
- Versioned

### Security

- No embedded secrets
- Secure defaults
- Least privilege support

---

## Key Takeaways

- Modules are the foundation of scalable Terraform implementations.
- Each module should have a single, clearly defined responsibility.
- Reusable modules reduce duplication and improve consistency.
- Strong typing, validation, and sensible defaults improve usability.
- Documentation, examples, and testing are essential for adoption.
- Module versions should be pinned and managed using semantic versioning.
- Good modules prioritise simplicity, maintainability, and stability.
- Enterprise Terraform platforms rely on well-designed modules to enforce standards, improve governance, and accelerate infrastructure delivery.