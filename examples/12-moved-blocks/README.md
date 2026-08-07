# Example 12: Moved Blocks

## Overview

This example demonstrates Terraform moved blocks.

Moved blocks allow resources to be renamed or relocated within a Terraform configuration without destroying and recreating infrastructure.

They provide a safe and declarative way to refactor Terraform code while preserving existing state.

---

## Files

```text
12-moved-blocks/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What moved blocks are
- Why moved blocks exist
- How Terraform tracks resource addresses
- How resource renaming affects state
- How to perform safe refactoring
- Why moved blocks are preferred over manual state operations

---

## The Problem

Terraform tracks resources using addresses stored in state.

Original configuration:

```hcl
resource "terraform_data" "app" {
  input = {
    application = "customer-api"
  }
}
```

Terraform stores:

```text
terraform_data.app
```

in state.

---

## Resource Rename

The resource is renamed:

```hcl
resource "terraform_data" "application" {
  input = {
    application = "customer-api"
  }
}
```

Terraform now sees:

```text
terraform_data.app
```

and:

```text
terraform_data.application
```

as different resources.

Without additional guidance Terraform plans:

```text
- Destroy old resource
+ Create new resource
```

---

## Using A Moved Block

A moved block tells Terraform that the resource address has changed.

Example:

```hcl
moved {
  from = terraform_data.app
  to   = terraform_data.application
}
```

Terraform updates its state mapping instead of recreating infrastructure.

---

## How Moved Blocks Work

Terraform performs:

```text
Read Configuration
        │
        ▼
Detect Moved Block
        │
        ▼
Update State Address
        │
        ▼
Generate Plan
```

The infrastructure remains unchanged.

Only the state mapping is modified.

---

## Example Refactoring

### Original Configuration

```hcl
resource "terraform_data" "app" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}
```

State:

```text
terraform_data.app
```

---

### Updated Configuration

```hcl
resource "terraform_data" "application" {
  input = {
    application = "customer-api"
    environment = "dev"
  }
}

moved {
  from = terraform_data.app
  to   = terraform_data.application
}
```

Terraform understands both resources represent the same object.

---

## Running The Example

> This example assumes the resource originally existed as `terraform_data.app` and has been renamed to `terraform_data.application`.

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

Terraform detects the moved block.

---

### Apply

```bash
terraform apply
```

Terraform updates state without recreating the resource.

---

## Example Plan Output

Terraform may display:

```text
# terraform_data.app has moved to
# terraform_data.application
```

Notice there is no destroy/create operation.

The resource identity has been preserved.

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

## Moving Resources Into Modules

One of the most common uses of moved blocks is module adoption.

Before:

```hcl
resource "terraform_data" "application" {

}
```

After:

```hcl
module "application" {

}
```

Moved block:

```hcl
moved {
  from = terraform_data.application
  to   = module.application.terraform_data.application
}
```

Terraform updates state rather than recreating resources.

---

## Multiple Resource Moves

Large refactoring projects often require multiple moved blocks.

Example:

```hcl
moved {
  from = terraform_data.app
  to   = terraform_data.application
}

moved {
  from = terraform_data.logs
  to   = terraform_data.logging
}

moved {
  from = terraform_data.network
  to   = terraform_data.platform_network
}
```

Terraform processes each move independently.

---

## Moved Blocks vs State Commands

Historically resource moves were performed using:

```bash
terraform state mv
```

Example:

```bash
terraform state mv \
  terraform_data.app \
  terraform_data.application
```

---

### Terraform State MV

Advantages:

```text
Immediate
Useful In Emergencies
```

Disadvantages:

```text
Manual
Not Version Controlled
Not Auditable
Difficult To Repeat
```

---

### Moved Blocks

Advantages:

```text
Declarative
Version Controlled
Reviewable
Reusable
Team Friendly
```

Disadvantages:

```text
Requires Updated Terraform Versions
```

In most cases moved blocks are the preferred solution.

---

## Common Refactoring Scenarios

### Resource Renaming

Example:

```text
app
```

becomes:

```text
application
```

---

### Module Adoption

Move resources into reusable modules.

---

### Module Reorganization

Move resources between modules.

---

### Naming Standard Improvements

Align resource names with organizational standards.

---

### Repository Restructuring

Break large Terraform configurations into smaller components.

---

## Common Mistakes

### Forgetting The Moved Block

Rename resource:

```hcl
resource "terraform_data" "application" {}
```

without:

```hcl
moved {

}
```

Terraform plans:

```text
Destroy Resource
Create Resource
```

instead of a state move.

---

### Incorrect Addresses

Example:

```hcl
moved {
  from = terraform_data.invalid
  to   = terraform_data.application
}
```

Terraform cannot move a resource that does not exist in state.

Always verify resource addresses.

---

### Combining Refactoring And Infrastructure Changes

Avoid:

```text
Rename Resources
+
Major Configuration Changes
```

in the same deployment.

Perform the move first.

Apply.

Then make additional changes.

This simplifies troubleshooting and reduces risk.

---

## Best Practices

### Do

- Use moved blocks during refactoring.
- Commit moved blocks to source control.
- Review plans before applying.
- Test large migrations first.
- Keep refactoring changes isolated.

### Don't

- Rename resources without moved blocks.
- Update state manually when a moved block can be used.
- Perform large infrastructure changes during refactoring.
- Ignore plan output.

---

## Enterprise Use Cases

Large organizations commonly use moved blocks when:

```text
Adopting Modules
Improving Naming Standards
Reorganizing Repositories
Modernizing Terraform Code
Splitting Monoliths
```

Moved blocks allow changes to Terraform structure without impacting running infrastructure.

---

## Key Takeaways

- Moved blocks allow Terraform resources to be renamed safely.
- Moved blocks update Terraform state without recreating infrastructure.
- They provide a declarative alternative to `terraform state mv`.
- Moved blocks are particularly useful during refactoring and module adoption.
- Infrastructure remains unchanged while Terraform updates resource addresses.
- Enterprise teams should prefer moved blocks whenever significant Terraform restructuring occurs.

---

## Next Example

Continue to:

```text
13-check-blocks
```

to learn how Terraform can validate assumptions about deployed infrastructure using runtime checks.