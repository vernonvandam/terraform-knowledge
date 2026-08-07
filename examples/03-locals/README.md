# Example 02: Variables

## Overview

This example demonstrates how to use input variables to make Terraform configurations reusable and flexible.

Variables allow the same Terraform code to be deployed multiple times using different values.

## Files

```text
02-variables/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── versions.tf
└── README.md
```

## Why Variables?

Avoid hardcoding values such as:

```hcl
resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}
```

Instead, use variables:

```hcl
resource "terraform_data" "application" {
  input = {
    application = var.application_name
    environment = var.environment
  }
}
```

Benefits:

- Reusability
- Environment portability
- Easier maintenance
- Better module design

## Variable Definition

Variables are defined using the `variable` block.

Example:

```hcl
variable "application_name" {
  type = string
}
```

## Variable Types

Common Terraform variable types include:

```hcl
string
number
bool
list(string)
map(string)
object({})
```

Example:

```hcl
variable "tags" {
  type = map(string)
}
```

## Variable Defaults

Variables can provide default values.

Example:

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

If no value is supplied, Terraform uses the default.

## Variable Validation

Terraform supports input validation.

Example:

```hcl
validation {
  condition = contains(
    ["dev", "test", "prod"],
    var.environment
  )

  error_message = "Environment must be dev, test, or prod."
}
```

Benefits:

- Early feedback
- Reduced deployment errors
- Better user experience

## Supplying Variable Values

### Method 1: Command Line

```bash
terraform apply \
  -var="application_name=customer-api"
```

### Method 2: Variable File

```hcl
application_name = "customer-api"
environment      = "dev"
```

Apply:

```bash
terraform apply \
  -var-file="terraform.tfvars"
```

### Method 3: Environment Variables

Linux/macOS:

```bash
export TF_VAR_application_name="customer-api"
```

Windows PowerShell:

```powershell
$env:TF_VAR_application_name="customer-api"
```

Terraform automatically loads these values.

## Commands

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
terraform plan \
  -var="application_name=customer-api"
```

### Apply

```bash
terraform apply \
  -var="application_name=customer-api"
```

## Expected Output

Example:

```text
application_details = {
  application = "customer-api"
  environment = "dev"
}
```

## Learning Objectives

After completing this example you should understand:

- How to define variables
- Variable types
- Default values
- Variable validation
- Different methods of supplying variable values
- Why variables improve Terraform reuse

## Next Example

Continue to:

```text
03-locals
```

to learn how Terraform local values simplify configuration and reduce duplication.