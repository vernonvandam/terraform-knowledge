# Example 13: Check Blocks

## Overview

This example demonstrates Terraform check blocks.

Check blocks allow Terraform to validate assumptions about configuration, resources, and infrastructure state during planning and deployment.

Checks provide an additional layer of validation beyond variables, helping to ensure that infrastructure meets expected requirements before a deployment is considered successful.

They are useful for validating:

- Environment configuration
- Naming standards
- Resource properties
- Security settings
- Required tags
- Organizational standards
- Infrastructure assumptions

---

## Files

```text
13-check-blocks/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What check blocks are
- Why check blocks exist
- How assertions work
- When checks are evaluated
- The difference between variable validation and check blocks
- Common uses for runtime validation

---

## What Is A Check Block?

A check block allows Terraform to verify that a condition evaluates to:

```text
true
```

If the condition evaluates to:

```text
false
```

Terraform reports a failure message.

Basic syntax:

```hcl
check "example" {

  assert {
    condition     = true
    error_message = "Validation failed."
  }

}
```

---

## Why Use Check Blocks?

Terraform may successfully parse and validate a configuration while still producing infrastructure that does not meet organizational requirements.

Checks help answer questions such as:

```text
Is the environment valid?

Is encryption enabled?

Are required tags present?

Is the resource name compliant?

Is the deployment targeting an approved workspace?
```

Checks provide additional deployment confidence.

---

## How Checks Work

Terraform evaluates check blocks during planning and apply operations.

Process:

```text
Configuration
      │
      ▼
Terraform Validation
      │
      ▼
Infrastructure Evaluation
      │
      ▼
Check Execution
      │
      ▼
Success Or Failure
```

If a check fails, Terraform reports the error and highlights the failed validation.

---

## Check Block Structure

A check consists of:

### Check Name

```hcl
check "environment_validation" {

}
```

Used to identify the validation.

---

### Assertion

```hcl
assert {

}
```

Contains the condition being evaluated.

---

### Condition

```hcl
condition = expression
```

Must evaluate to:

```text
true
```

for the check to pass.

---

### Error Message

```hcl
error_message = "Validation failed."
```

Displayed when the assertion fails.

Error messages should clearly describe the problem and how to resolve it.

---

## Example Environment Validation

The example validates that the selected environment is allowed.

Allowed values:

```hcl
[
  "dev",
  "test",
  "prod"
]
```

Validation:

```hcl
contains(
  local.allowed_environments,
  terraform_data.application.input.environment
)
```

If the environment exists in the list, the check succeeds.

---

## Example Application Name Validation

The example also validates the application name.

Condition:

```hcl
length(
  terraform_data.application.input.application
) > 0
```

This ensures that an application name has been supplied.

---

## Running The Example

### Initialize

```bash
terraform init
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Destroy

```bash
terraform destroy
```

---

## Successful Execution

When all checks pass:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Terraform proceeds normally.

Example output:

```text
application_details = {
  application = "customer-api"
  environment = "dev"
}
```

---

## Failed Execution Example

Suppose the environment is changed to:

```hcl
environment = "production"
```

but the allowed environments are:

```hcl
[
  "dev",
  "test",
  "prod"
]
```

Terraform reports:

```text
Error: Environment must be dev, test, or prod.
```

This immediately identifies the configuration issue.

---

## Multiple Assertions

A single check block may contain multiple assertions.

Example:

```hcl
check "application_validation" {

  assert {
    condition = length(
      terraform_data.application.input.application
    ) > 0

    error_message = "Application name cannot be empty."
  }

  assert {
    condition = contains(
      ["dev", "test", "prod"],
      terraform_data.application.input.environment
    )

    error_message = "Environment is invalid."
  }

}
```

All assertions must pass.

---

## Variable Validation vs Check Blocks

These features solve different problems.

### Variable Validation

Validates:

```text
User Input
```

Example:

```hcl
variable "environment" {

  validation {

  }

}
```

Runs before resource evaluation.

---

### Check Blocks

Validates:

```text
Resource Results
Infrastructure Conditions
Runtime Assumptions
```

Runs after Terraform evaluates the configuration.

---

## Preconditions vs Check Blocks

Terraform also supports preconditions.

### Preconditions

Applied directly to a resource.

Example:

```hcl
resource "terraform_data" "application" {

  lifecycle {

    precondition {
      condition     = true
      error_message = "Validation failed."
    }

  }

}
```

---

### Check Blocks

Applied at the configuration level.

Example:

```hcl
check "environment_validation" {

}
```

Checks are generally used for broader infrastructure validation.

---

## Common Real-World Use Cases

### Environment Validation

```hcl
check "environment" {

  assert {
    condition = contains(
      ["dev", "test", "prod"],
      terraform.workspace
    )

    error_message = "Unsupported environment."
  }

}
```

---

### Naming Standards

```hcl
check "resource_name" {

  assert {
    condition = startswith(
      local.resource_name,
      "app-"
    )

    error_message = "Resource must begin with app-."
  }

}
```

---

### Required Tags

```hcl
check "tags" {

  assert {
    condition = contains(
      keys(local.tags),
      "Environment"
    )

    error_message = "Environment tag is required."
  }

}
```

---

### Security Validation

Examples:

```text
Encryption Enabled
Private Networking Enabled
Diagnostics Enabled
Approved Regions Used
```

Checks can help enforce operational standards.

---

## Enterprise Use Cases

Organizations commonly use checks to verify:

```text
Naming Standards
Required Tags
Approved Locations
Allowed SKUs
Encryption Settings
Cost Control Requirements
Environment Rules
```

Checks provide a self-documenting validation layer within Terraform configurations.

---

## Benefits Of Check Blocks

Checks help:

- Detect invalid configurations early
- Improve deployment quality
- Reduce operational risk
- Increase deployment confidence
 