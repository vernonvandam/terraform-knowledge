# Example 09: Modules

## Overview

This example demonstrates how to create and consume Terraform modules.

Modules are reusable collections of Terraform configuration that allow infrastructure to be standardized, simplified, and managed consistently across environments.

Modules are one of the most important features of Terraform and form the foundation of most enterprise Terraform implementations.

---

## Files

```text
09-modules/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars.example
├── README.md
│
└── modules/
    └── application/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
```

---

## Learning Objectives

After completing this example you should understand:

- What Terraform modules are
- Why modules are used
- How to create a module
- How to pass inputs to a module
- How to consume module outputs
- How modules improve reusability
- How enterprise Terraform uses modules extensively

---

## What Is A Module?

A module is a collection of Terraform files that work together as a reusable unit.

Every Terraform configuration is technically a module.

Example:

```text
Root Module
```

When Terraform code is placed in a reusable folder and referenced elsewhere, it becomes a reusable module.

---

## Why Use Modules?

Without modules:

```text
network-dev.tf
network-test.tf
network-prod.tf
```

The same infrastructure is duplicated repeatedly.

With modules:

```text
Networking Module
       │
       ├── Dev
       ├── Test
       └── Prod
```

The code is written once and reused many times.

Benefits include:

- Reduced duplication
- Standardization
- Easier maintenance
- Better testing
- Improved governance

---

## Consuming A Module

Modules are declared using:

```hcl
module "application" {
  source = "./modules/application"

  application_name = var.application_name
  environment      = var.environment
}
```

Terraform loads the module and creates the resources defined within it.

---

## Module Inputs

Variables define the module interface.

Example:

```hcl
variable "application_name" {
  type = string
}
```

The consuming configuration supplies values:

```hcl
module "application" {

  application_name = "customer-api"

}
```

This allows the same module to be reused with different values.

---

## Module Outputs

Modules expose information through outputs.

Example:

```hcl
output "resource_name" {
  value = local.resource_name
}
```

The root configuration accesses the output:

```hcl
module.application.resource_name
```

Outputs form the public interface of a module.

---

## Module Resource Naming

The module generates:

```hcl
customer-api-dev
```

using:

```hcl
"${var.application_name}-${var.environment}"
```

This demonstrates how modules often enforce naming standards.

---

## Running The Example

### Initialize

```bash
terraform init
```

Terraform downloads and initializes the local module.

---

### Validate

```bash
terraform validate
```

---

### Plan

```bash
terraform plan \
  -var="application_name=customer-api"
```

---

### Apply

```bash
terraform apply \
  -var="application_name=customer-api"
```

---

### Destroy

```bash
terraform destroy \
  -var="application_name=customer-api"
```

---

## Example Output

```text
resource_name = "customer-api-dev"
```

Application details:

```text
application_details = {
  application = "customer-api"
  environment = "dev"
  name        = "customer-api-dev"
}
```

---

## Module Structure

A typical module structure:

```text
module/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

Larger modules may also include:

```text
README.md
examples/
tests/
```

---

## Root Module vs Child Module

### Root Module

The configuration you execute directly.

Example:

```bash
terraform apply
```

runs from the root module.

---

### Child Module

A reusable module consumed by another module.

Example:

```hcl
module "application" {
  source = "./modules/application"
}
```

---

## Module Reuse

The same module can be used multiple times.

Example:

```hcl
module "customer_api" {
  source = "./modules/application"

  application_name = "customer-api"
  environment      = "dev"
}

module "billing_api" {
  source = "./modules/application"

  application_name = "billing-api"
  environment      = "prod"
}
```

Each module instance remains independent.

---

## Common Enterprise Modules

Organizations typically create modules for:

```text
Networking
Virtual Machines
Storage
Kubernetes
Databases
Monitoring
Identity
DNS
```

These modules become the building blocks of the platform.

---

## Best Practices

### Do

- Keep modules focused.
- Define clear inputs and outputs.
- Use strong typing.
- Document module behavior.
- Reuse modules extensively.

### Don't

- Create giant platform modules.
- Hardcode environment values.
- Expose unnecessary outputs.
- Break module interfaces frequently.
- Duplicate infrastructure logic.

---

## Key Takeaways

- Modules are reusable Terraform building blocks.
- Modules improve consistency and maintainability.
- Variables define module inputs.
- Outputs define module outputs.
- Modules reduce duplication and standardize deployments.
- Most enterprise Terraform platforms are built around shared modules.
- Good module design is one of the most important Terraform skills.

---

## Next Example

Continue to:

```text
10-workspaces
```

to learn how Terraform workspaces allow multiple state instances to be managed from a single configuration.