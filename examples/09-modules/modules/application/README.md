# Application Module

## Overview

This module demonstrates the fundamental structure of a reusable Terraform module.

The module accepts application information as input variables, generates a standardized resource name, and exposes useful outputs for consumers.

Although this example uses the built-in `terraform_data` resource for simplicity, the same design principles apply to production modules that deploy:

- Virtual Machines
- Resource Groups
- Storage Accounts
- Kubernetes Clusters
- Databases
- Networking Components

---

## Module Structure

```text
application/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Inputs

| Name | Type | Description | Required |
|--------|--------|-------------|-----------|
| application_name | string | Application name | Yes |
| environment | string | Deployment environment | Yes |

---

## Outputs

| Name | Description |
|---------|-------------|
| resource_name | Generated resource name |
| application_id | Terraform-generated resource identifier |
| application_details | Application metadata and configuration |

---

## Usage

```hcl
module "application" {
  source = "./modules/application"

  application_name = "customer-api"
  environment      = "dev"
}
```

---

## Example Output

```text
resource_name = "customer-api-dev"
```

```text
application_details = {
  application = "customer-api"
  environment = "dev"
  name        = "customer-api-dev"
}
```

---

## How It Works

### Step 1: Accept Input Variables

The module receives values from the root module.

Example:

```hcl
module "application" {
  source = "./modules/application"

  application_name = "customer-api"
  environment      = "dev"
}
```

These values become available inside the module as:

```hcl
var.application_name
var.environment
```

---

### Step 2: Generate Local Values

The module creates a standardized resource name.

Example:

```hcl
locals {
  resource_name = "${var.application_name}-${var.environment}"
}
```

Result:

```text
customer-api-dev
```

Using locals helps centralize naming logic and avoid duplication.

---

### Step 3: Create Resources

The module creates a resource using the generated values.

Example:

```hcl
resource "terraform_data" "application" {
  input = {
    application = var.application_name
    environment = var.environment
    name        = local.resource_name
  }
}
```

In production modules this would typically create real infrastructure resources.

---

### Step 4: Expose Outputs

The module exposes useful information.

Example:

```hcl
output "resource_name" {
  value = local.resource_name
}
```

Consumers can access the output using:

```hcl
module.application.resource_name
```

---

## Example Deployment

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

---

## Design Principles Demonstrated

This module demonstrates several Terraform best practices:

- Single responsibility
- Strongly typed inputs
- Clear outputs
- Reusable design
- Environment-agnostic configuration
- Consistent naming
- Minimal complexity

---

## Best Practices

### Do

- Keep modules focused.
- Define clear inputs and outputs.
- Document module behaviour.
- Use locals for reusable logic.
- Use descriptive names.

### Don't

- Hardcode environment values.
- Embed secrets in module code.
- Expose unnecessary outputs.
- Create modules with multiple unrelated responsibilities.
- Make frequent breaking interface changes.

---

## Learning Objectives

After reviewing this module you should understand:

- Basic module structure
- Module inputs
- Module outputs
- Local values inside modules
- Module consumption patterns
- Reusable Terraform design principles

This module serves as a foundation for understanding more advanced Terraform module design and enterprise module development.