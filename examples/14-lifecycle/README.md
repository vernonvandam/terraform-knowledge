# Example 14: Lifecycle

## Overview

This example demonstrates Terraform lifecycle meta-arguments.

Lifecycle settings allow you to control how Terraform creates, updates, replaces, and destroys resources.

Terraform normally follows its standard resource management behavior, but lifecycle rules provide additional control when specific operational requirements must be met.

Lifecycle settings are commonly used to:

- Protect critical resources
- Minimise downtime during replacements
- Ignore externally managed changes
- Force replacement when dependencies change
- Support operational and governance requirements

---

## Files

```text
14-lifecycle/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What lifecycle meta-arguments are
- Why lifecycle controls exist
- How `prevent_destroy` works
- How `create_before_destroy` works
- How `ignore_changes` works
- How `replace_triggered_by` works
- Common lifecycle use cases
- Lifecycle best practices

---

## What Is A Lifecycle Block?

Terraform resources can include a lifecycle block to customize resource management behaviour.

Example:

```hcl
resource "terraform_data" "application" {

  lifecycle {
    prevent_destroy = true
  }

}
```

Lifecycle settings influence how Terraform plans and applies changes.

---

## Available Lifecycle Meta-Arguments

Common lifecycle controls include:

```text
prevent_destroy

create_before_destroy

ignore_changes

replace_triggered_by
```

Each serves a different purpose and should be used intentionally.

---

# Prevent Destroy

## Purpose

Protect important resources from accidental deletion.

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

---

## Default Behaviour

Without lifecycle protection:

```text
terraform destroy
        │
        ▼
Resource Deleted
```

---

## Protected Behaviour

With:

```hcl
prevent_destroy = true
```

Terraform blocks deletion.

Example:

```text
Error: Instance cannot be destroyed
```

This protects critical infrastructure from accidental removal.

---

## Typical Use Cases

Examples include:

```text
Production Databases
Shared Networking
DNS Zones
Key Vaults
Critical Storage
Identity Resources
```

These are resources that should not be removed without explicit review.

---

## Advantages

Benefits include:

- Reduced risk of accidental deletion
- Additional operational safeguards
- Improved protection for critical infrastructure

---

## Considerations

Overusing:

```hcl
prevent_destroy = true
```

can make legitimate resource removal more difficult.

Use it selectively.

---

# Create Before Destroy

## Purpose

Minimise downtime during replacement operations.

Example:

```hcl
lifecycle {
  create_before_destroy = true
}
```

---

## Default Replacement Behaviour

Terraform normally performs:

```text
Destroy Old Resource
        │
        ▼
Create New Resource
```

This can result in service interruption.

---

## Create Before Destroy Behaviour

Terraform attempts:

```text
Create New Resource
        │
        ▼
Destroy Old Resource
```

This allows the replacement resource to exist before the original resource is removed.

---

## Typical Use Cases

Examples:

```text
Virtual Machines
Load Balancers
Application Services
Compute Instances
DNS Infrastructure
```

When supported by the platform, this can significantly reduce downtime.

---

## Considerations

Some cloud resources require globally unique names.

In these situations, Terraform may not be able to create the replacement resource before removing the original one.

Always test replacement scenarios.

---

# Ignore Changes

## Purpose

Tell Terraform to ignore modifications made to specific attributes.

Example:

```hcl
lifecycle {

  ignore_changes = [
    input["version"]
  ]

}
```

---

## Why Ignore Changes?

Some attributes may be managed outside Terraform.

Examples:

```text
Monitoring Systems
Automation Platforms
Security Tools
Third-Party Controllers
```

Terraform would normally detect these changes as drift.

---

## Example

Terraform configuration:

```text
version = 1.0.0
```

External process updates:

```text
version = 1.0.1
```

Without:

```hcl
ignore_changes
```

Terraform detects drift.

With:

```hcl
ignore_changes
```

Terraform ignores the update.

---

## Typical Use Cases

Examples:

```text
Generated Metadata
Externally Managed Tags
Timestamps
Monitoring Configuration
Dynamic Settings
```

---

## Risks

Ignoring too many attributes reduces Terraform's visibility.

Avoid:

```hcl
ignore_changes = all
```

Doing so effectively removes Terraform's ability to manage meaningful changes.

---

## Best Practice

Only ignore specific attributes that have a documented business or technical justification.

---

# Replace Triggered By

## Purpose

Force resource replacement when another resource changes.

Example:

```hcl
lifecycle {

  replace_triggered_by = [
    terraform_data.configuration
  ]

}
```

---

## Default Behaviour

Terraform normally replaces a resource only when that resource itself changes.

Example:

```text
Resource A Changes
        │
        ▼
Resource B Unchanged
```

Terraform leaves Resource B untouched.

---

## Triggered Replacement

With:

```hcl
replace_triggered_by
```

Terraform performs:

```text
Configuration Changes
          │
          ▼
Dependent Resource Replaced
```

This allows controlled replacement behaviour.

---

## Example Scenario

Configuration resource:

```hcl
resource "terraform_data" "configuration" {

}
```

Deployment resource:

```hcl
resource "terraform_data" "deployment" {

  lifecycle {

    replace_triggered_by = [
      terraform_data.configuration
    ]

  }

}
```

When configuration changes, Terraform replaces the deployment resource.

---

## Typical Use Cases

Examples:

```text
Configuration Updates
Certificate Rotation
Application Deployments
Image Updates
Template Changes
Dependency Refreshes
```

---

# Running The Example

## Initialize

```bash
terraform init
```

---

## Validate

```bash
terraform validate
```

---

## View Plan

```bash
terraform plan
```

---

## Apply

```bash
terraform apply
```

---

## Attempt Destroy

```bash
terraform destroy
```

Expected result:

```text
Error: Instance cannot be destroyed
```

because:

```hcl
prevent_destroy = true
```

is enabled on the application resource.

---

# Understanding The Example

The example contains three resources.

---

## Application Resource

```hcl
terraform_data.application
```

Demonstrates:

```text
prevent_destroy
ignore_changes
```

---

## Configuration Resource

```hcl
terraform_data.configuration
```

Represents configuration data that may change over time.

---

## Deployment Resource

```hcl
terraform_data.deployment
```

Demonstrates:

```text
replace_triggered_by
```

when configuration changes occur.

---

# Example Output

```text
application = {
  application = "customer-api"
  environment = "dev"
  version     = "1.0.0"
}
```

```text
configuration = {
  config_version = "1.0"
}
```

```text
deployment = {
  application = "customer-api"
}
```

---

# Real-World Examples

## Database Protection

```hcl
resource "azurerm_mssql_server" "database" {

  lifecycle {
    prevent_destroy = true
  }

}
```

Prevents accidental database deletion.

---

## Rolling Infrastructure Replacement

```hcl
resource "azurerm_linux_virtual_machine" "app" {

  lifecycle {
    create_before_destroy = true
  }

}
```

Reduces downtime during replacement operations.

---

## Managed Tags

```hcl
lifecycle {

  ignore_changes = [
    tags
  ]

}
```

Allows another platform to manage tagging.

---

## Certificate Rotation

```hcl
lifecycle {

  replace_triggered_by = [
    terraform_data.certificate
  ]

}
```

Forces replacement when certificates change.

---

# Common Enterprise Use Cases

Organizations frequently use lifecycle controls for:

```text
Production Databases
Critical Storage
Shared Services
Application Upgrades
Blue-Green Deployments
Infrastructure Refreshes
Governance Controls
```

Lifecycle settings provide additional operational safety and flexibility.

---

# Best Practices

## Do

- Protect critical resources with `prevent_destroy`.
- Use `create_before_destroy` when downtime reduction is important.
- Keep `ignore_changes` narrowly focused.
- Document lifecycle decisions.
- Test lifecycle behaviour in lower environments.

---

## Don't

- Use `ignore_changes = all`.
- Protect every resource with `prevent_destroy`.
- Use lifecycle settings without understanding the impact.
- Ignore Terraform plans involving resource replacement.
- Use lifecycle rules as a replacement for governance processes.

---

# Common Anti-Patterns

## Blanket Protection

Avoid:

```hcl
prevent_destroy = true
```

on every resource.

This often creates operational challenges.

---

## Excessive Ignore Changes

Avoid:

```hcl
ignore_changes = all
```

Terraform loses visibility into infrastructure changes.

---

## Unnecessary Replacements

Avoid using:

```hcl
replace_triggered_by
```

without a clear operational requirement.

Unnecessary replacements can increase deployment risk.

---

## Untested Lifecycle Rules

Lifecycle settings should always be tested before being introduced into production environments.

---

# Key Takeaways

- Lifecycle meta-arguments customize Terraform resource behaviour.
- `prevent_destroy` protects critical resources from accidental deletion.
- `create_before_destroy` helps minimise downtime during replacement operations.
- `ignore_changes` allows specific attributes to be managed outside Terraform.
- `replace_triggered_by` forces replacement when dependencies change.
- Lifecycle settings provide powerful operational controls and should be applied carefully.
- Enterprise Terraform implementations commonly use lifecycle controls to improve reliability, safety, and change management.

---

# Completion

Congratulations. You have completed all examples in this Terraform learning repository.

Recommended next steps:

```text
Review Documentation
        │
        ▼
Build Custom Modules
        │
        ▼
Implement Remote State
        │
        ▼
Create CI/CD Pipelines
        │
        ▼
Apply Security Controls
        │
        ▼
Implement Enterprise Best Practices
```

You should now have practical exposure to the core Terraform language, state management, modules, testing, troubleshooting, advanced features, and operational best practices.