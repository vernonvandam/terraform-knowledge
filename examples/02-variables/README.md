# Example 02: Variables

## Overview

This example demonstrates how to use input variables to make Terraform configurations reusable and environment-independent.

Terraform variables allow values to be supplied externally rather than being hardcoded into the configuration.

---

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

---

## Learning Objectives

After completing this example you should understand:

- What Terraform variables are
- How to define variables
- How to specify variable types
- How to use default values
- How to validate variable input
- How to reference variables in resources
- How to provide values at runtime

---

## Variable Definitions

Variables are defined using the `variable` block.

Example:

```hcl
variable "application_name" {
  description = "Application name."
  type        = string
}
```

Variables act as inputs to a Terraform configuration.

---

## Using Variables

Variables are referenced using the `var` object.

Example:

```hcl
resource "terraform_data" "application" {

  input = {
    application = var.application_name
    environment = var.environment
  }

}
```

Terraform substitutes the supplied variable values during planning and deployment.

---

## Variable Types

Terraform supports multiple variable types.

Examples:

```hcl
string
number
bool
list(string)
map(string)
object({})
```

Strong typing improves validation and reduces errors.

Example:

```hcl
variable "instance_count" {
  type = number
}
```

---

## Default Values

Variables can include default values.

Example:

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

If no value is supplied, Terraform uses the default value automatically.

---

## Variable Validation

Terraform can validate variable input before deployment.

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

Benefits include:

- Earlier feedback
- Better error messages
- Reduced deployment failures

---

## Providing Variable Values

### Command Line

```bash
terraform plan \
  -var="application_name=customer-api"
```

---

### Variable File

Example file:

```hcl
application_name = "customer-api"
environment      = "dev"
```

Apply the configuration:

```bash
terraform apply \
  -var-file="terraform.tfvars"
```

---

### Environment Variables

Linux/macOS:

```bash
export TF_VAR_application_name="customer-api"
```

PowerShell:

```powershell
$env:TF_VAR_application_name="customer-api"
```

Terraform automatically reads environment variables that begin with:

```text
TF_VAR_
```

---

## Running the Example

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

### Destroy

```bash
terraform destroy \
  -var="application_name=customer-api"
```

---

## Example Output

```text
application_details = {
  application = "customer-api"
  environment = "dev"
}

resource_id = "..."
```

---

## Key Takeaways

- Variables make Terraform configurations reusable.
- Variables reduce hardcoded values.
- Variable validation improves reliability.
- Terraform supports multiple methods for supplying values.
- Strong typing and validation are recommended for all production-grade configurations.

---

## Next Example

Continue to:

```text
03-locals
```

to learn how local values can simplify expressions and reduce duplication within Terraform configurations.