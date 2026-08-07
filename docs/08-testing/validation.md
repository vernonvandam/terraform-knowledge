# Terraform Validation

## Overview

Validation is the process of verifying that Terraform configurations are syntactically correct, logically consistent, and compliant with defined engineering standards before infrastructure is deployed.

Validation provides an early feedback mechanism that helps prevent deployment failures, reduce rework, and improve infrastructure reliability.

Terraform validation should be performed throughout the development lifecycle, including local development, pull requests, CI/CD pipelines, and pre-deployment approval processes.

---

## Why Validation Matters

Infrastructure defects become increasingly expensive to fix as they move through the delivery pipeline.

Validation helps identify issues before resources are created, including:

- Syntax errors
- Invalid resource references
- Missing variables
- Incorrect module usage
- Configuration inconsistencies
- Standards violations

Benefits include:

- Faster developer feedback
- Reduced deployment failures
- Improved infrastructure quality
- Better consistency across teams
- Reduced operational risk
- Increased deployment confidence

---

## Validation in the Terraform Workflow

Validation should occur before planning and deployment activities.

Typical workflow:

```text
Author Terraform Code
          │
          ▼
Terraform Format Check
          │
          ▼
Terraform Validation
          │
          ▼
Linting & Security Scanning
          │
          ▼
Terraform Plan
          │
          ▼
Terraform Apply
```

Validation acts as an early quality gate within the infrastructure delivery process.

---

## Terraform Validate

Terraform provides a built-in validation command:

```bash
terraform validate
```

This command evaluates whether a configuration is internally consistent and ready for planning.

Before running validation:

```bash
terraform init
```

Example:

```bash
terraform init
terraform validate
```

Successful output:

```text
Success! The configuration is valid.
```

---

## What Terraform Validate Checks

Terraform validation verifies:

- Configuration syntax
- Resource references
- Input variable definitions
- Output definitions
- Module structure
- Provider configuration consistency
- Expression evaluation

Validation does not create, modify, or destroy infrastructure.

---

## What Terraform Validate Does Not Check

Terraform validation cannot verify:

- Resource availability
- Cloud permissions
- Runtime infrastructure behaviour
- Resource quotas
- Network connectivity
- Service availability

For example:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}
```

Terraform can validate the syntax, but it cannot determine whether the bucket name is already in use until deployment.

---

## Variable Validation

Terraform supports custom validation rules for input variables.

Variable validation allows developers to enforce constraints before deployments occur.

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

- Reduces user error
- Enforces organisational standards
- Improves module reliability
- Produces clearer error messages

---

## Numeric Validation

Input values should be validated wherever practical.

Example:

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count > 0
    error_message = "Instance count must be greater than zero."
  }
}
```

This prevents invalid infrastructure configurations from progressing further in the deployment lifecycle.

---

## String Pattern Validation

Validation can enforce naming conventions and approved formats.

Example:

```hcl
variable "resource_prefix" {
  type = string

  validation {
    condition = can(
      regex("^[a-z0-9-]+$", var.resource_prefix)
    )

    error_message = "Prefix must contain only lowercase letters, numbers, and hyphens."
  }
}
```

This helps maintain naming consistency across deployments.

---

## Collection Validation

Lists and sets can also be validated.

Example:

```hcl
variable "allowed_environments" {
  type = list(string)

  validation {
    condition     = length(var.allowed_environments) > 0
    error_message = "At least one environment must be specified."
  }
}
```

This prevents incomplete configurations from being deployed.

---

## Resource Preconditions

Terraform supports preconditions that validate assumptions before resource creation.

Example:

```hcl
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    precondition {
      condition     = var.instance_type != ""
      error_message = "Instance type must be specified."
    }
  }
}
```

Preconditions help prevent invalid deployments by enforcing requirements before infrastructure changes occur.

---

## Resource Postconditions

Postconditions validate expected outcomes after resource evaluation.

Example:

```hcl
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    postcondition {
      condition     = self.instance_state == "running"
      error_message = "Instance failed to reach running state."
    }
  }
}
```

Postconditions provide an additional layer of deployment assurance.

---

## Module Validation

Reusable modules should include validation routines to ensure predictable behaviour.

Areas commonly validated include:

- Input variables
- Required tags
- Environment values
- Naming standards
- Resource sizing
- Optional feature flags

Well-designed modules should reject invalid inputs as early as possible.

---

## Common Validation Scenarios

### Environment Validation

Restrict deployments to approved environments.

```hcl
validation {
  condition = contains(
    ["dev", "test", "staging", "prod"],
    var.environment
  )

  error_message = "Invalid environment."
}
```

---

### Region Validation

Restrict deployments to approved locations.

```hcl
validation {
  condition = contains(
    ["australiaeast", "australiasoutheast"],
    var.location
  )

  error_message = "Location is not approved."
}
```

---

### Tag Validation

Ensure mandatory tags are supplied.

Examples:

- Environment
- Application
- Cost Centre
- Owner
- Managed By

Tag validation supports governance, reporting, and cost management requirements.

---

## Validation in CI/CD

Validation should always be automated within CI/CD pipelines.

Typical implementation:

```bash
terraform fmt -check
terraform init
terraform validate
```

A pipeline should fail immediately when validation issues are detected.

Example workflow:

```text
Pull Request
      │
      ▼
terraform fmt
      │
      ▼
terraform validate
      │
      ▼
linting
      │
      ▼
security scanning
      │
      ▼
terraform plan
```

This prevents invalid configurations from progressing to deployment stages.

---

## Enterprise Validation Standards

Organisations should establish mandatory validation requirements.

Typical standards include:

### Required

- Terraform validation passes
- Approved Terraform versions
- Approved provider versions
- Variable validation rules
- Naming standard compliance

### Recommended

- Environment restrictions
- Tagging requirements
- Location restrictions
- Resource limit validation
- Module-level validation

---

## Common Validation Failures

### Missing Required Variable

```text
No value for required variable.
```

Cause:

Required input variable not supplied.

Resolution:

Provide the variable through:

- Variable files
- Command-line arguments
- Environment variables

---

### Invalid Reference

```text
Reference to undeclared resource.
```

Cause:

Terraform references a resource that does not exist.

Resolution:

Correct the resource name or create the missing resource