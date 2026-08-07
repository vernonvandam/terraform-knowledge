# Terraform Linting

## Overview

Linting is the process of analysing Terraform code for potential errors, quality issues, style inconsistencies, and violations of engineering standards.

Unlike `terraform validate`, which focuses on configuration correctness, linting focuses on code quality, maintainability, and adherence to best practices.

Linting should be performed continuously throughout the development lifecycle and automated wherever possible.

---

## Why Linting Matters

Infrastructure code becomes difficult to maintain when teams follow inconsistent patterns.

Linting helps organisations:

- Enforce coding standards
- Improve readability
- Reduce configuration mistakes
- Maintain consistency across repositories
- Detect potential issues before deployment
- Reduce technical debt
- Improve developer productivity

A well-defined linting strategy is an essential component of Infrastructure as Code governance.

---

## Validation vs Linting

Validation and linting serve different purposes.

### Validation

Terraform validation checks whether Terraform can successfully interpret a configuration.

Example:

```bash
terraform validate
```

Validation focuses on:

- Syntax correctness
- Resource references
- Variable definitions
- Module structure

---

### Linting

Linting focuses on best practices and code quality.

Example:

```bash
tflint
```

Linting focuses on:

- Naming conventions
- Version management
- Deprecated features
- Provider recommendations
- Style consistency
- Potential misconfigurations

---

## Terraform Linting Tools

Several tools are available within the Terraform ecosystem.

### TFLint

TFLint is the most commonly used Terraform linter.

Features include:

- Terraform best practice checks
- Provider-specific rules
- Custom rule support
- Recursive scanning
- CI/CD integration

Example:

```bash
tflint
```

Recursive scan:

```bash
tflint --recursive
```

---

### Checkov

Checkov combines policy validation and security scanning.

Typical use cases:

- Security compliance
- Infrastructure governance
- Policy-as-code enforcement

Example:

```bash
checkov -d .
```

---

### Trivy

Trivy can identify infrastructure misconfigurations and security risks.

Example:

```bash
trivy config .
```

---

## Installing TFLint

Installation methods vary by operating system.

Once installed, verify the version:

```bash
tflint --version
```

Teams should standardise on approved TFLint versions to ensure consistent results.

---

## Basic TFLint Usage

Run against the current directory:

```bash
tflint
```

Run against all modules:

```bash
tflint --recursive
```

Use compact output:

```bash
tflint --format compact
```

---

## TFLint Configuration

Configuration is stored in:

```text
.tflint.hcl
```

Example:

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
```

Initialise plugins:

```bash
tflint --init
```

---

## Common Linting Rules

### Provider Version Constraints

Providers should always be versioned.

Recommended:

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

Avoid:

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
```

Unbounded provider versions can introduce unexpected changes.

---

### Terraform Version Constraints

Specify supported Terraform versions.

Example:

```hcl
terraform {
  required_version = ">= 1.10"
}
```

This prevents deployments from using unsupported Terraform versions.

---

### Unused Variables

Unused variables increase complexity and create confusion.

Example:

```hcl
variable "environment" {
  type = string
}
```

If the variable is never referenced, it should be removed.

---

### Unused Outputs

Outputs that are not consumed by users or dependent modules should be removed to reduce maintenance overhead.

---

### Deprecated Arguments

Terraform features evolve over time.

Linting helps identify:

- Deprecated resource arguments
- Legacy configuration patterns
- Obsolete syntax

Addressing these issues early simplifies upgrades.

---

## Naming Convention Enforcement

Consistent naming improves readability and maintainability.

Example:

```hcl
resource "azurerm_resource_group" "networking" {
  name = "rg-shared-networking-prod"
}
```

Preferred naming characteristics:

- Predictable
- Descriptive
- Environment aware
- Aligned to organisational standards

---

## Linting Repository Structure

Linting works most effectively when repositories follow a consistent structure.

Example:

```text
terraform-repository/
│
├── modules/
├── environments/
├── examples/
├── tests/
├── .tflint.hcl
└── README.md
```

This allows automated tooling to execute consistently across projects.

---

## Linting in Pull Requests

All pull requests should execute automated linting checks.

Typical workflow:

```text
Developer Commit
        │
        ▼
Pull Request
        │
        ▼
Terraform Validate
        │
        ▼
TFLint
        │
        ▼
Security Scanning
        │
        ▼
Review and Approval
```

Linting failures should prevent pull request completion until resolved.

---

## Linting Within CI/CD

Linting should never rely solely on local execution.

Pipeline execution ensures:

- Consistent results
- Shared standards
- Automated governance
- Reduced human error

Example pipeline sequence:

```text
terraform fmt
        │
terraform validate
        │
tflint
        │
security scans
        │
terraform plan
```

---

## Enterprise Linting Standards

Enterprise Terraform repositories should enforce:

### Mandatory Requirements

- Provider version constraints
- Terraform version constraints
- Standard directory structure
- Approved module sources
- Required documentation

### Recommended Requirements

- Consistent naming conventions
- Tagging standards
- Module ownership definitions
- Documentation completeness

---

## Common Linting Issues

### Missing Provider Versions

```hcl
provider "azurerm" {}
```

Problem:

- Uncontrolled upgrades

Solution:

```hcl
required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.0"
  }
}
```

---

### Hardcoded Values

Avoid:

```hcl
location = "australiaeast"
```

Prefer:

```hcl
location = var.location
```

Benefits include:

- Reusability
- Flexibility
- Environment portability

---

### Poor Resource Naming

Avoid:

```hcl
resource "azurerm_resource_group" "test" {}
```

Prefer:

```hcl
resource "azurerm_resource_group" "platform_networking" {}
```

Resource names should clearly communicate purpose.

---

## Best Practices

### Do

- Run linting before every commit
- Automate linting in CI/CD
- Use a shared linting configuration
- Regularly update rules and plugins
- Resolve warnings promptly

### Don't

- Ignore linting failures
- Hardcode environment-specific values
- Leave unused variables in code
- Use unpinned provider versions
- Bypass automated quality checks

---

## Key Takeaways

- Linting improves Terraform code quality and consistency.
- Linting complements but does not replace validation.
- TFLint is the primary linting tool used within most Terraform environments.
- Automated linting should be enforced through CI/CD pipelines.
- Consistent linting standards improve maintainability, governance, and deployment reliability.
- Enterprise Terraform repositories should treat linting failures as quality gate failures.

By incorporating linting into the development workflow, teams can identify issues early, enforce engineering standards, and maintain a high-quality Infrastructure as Code codebase.