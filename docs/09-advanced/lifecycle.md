# Terraform Lifecycle Meta-Arguments

## Overview

Terraform provides lifecycle meta-arguments that allow engineers to influence how resources are created, updated, replaced, and destroyed.

Lifecycle settings are particularly useful when:

- Protecting critical resources
- Managing infrastructure replacement
- Avoiding downtime
- Controlling drift behaviour
- Handling provider limitations
- Managing dependencies during updates

Lifecycle configuration is applied within resource blocks and affects Terraform's execution behaviour.

---

## Lifecycle Block Syntax

Lifecycle settings are defined within a resource.

Example:

```hcl
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }

}
```

---

## Available Lifecycle Settings

Terraform supports several lifecycle controls:

- create_before_destroy
- prevent_destroy
- ignore_changes
- replace_triggered_by
- precondition
- postcondition

Each serves a specific purpose and should be used carefully.

---

## Create Before Destroy

### Purpose

By default, Terraform typically destroys a resource before creating its replacement when a replacement is required.

This behaviour may result in downtime.

Setting:

```hcl
create_before_destroy = true
```

Changes the behaviour to:

1. Create replacement resource
2. Update dependencies
3. Destroy old resource

Example:

```hcl
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }

}
```

---

### Benefits

- Reduces downtime
- Supports rolling replacements
- Improves availability
- Safer production deployments

---

### Considerations

Some resources cannot coexist simultaneously.

Potential issues include:

- Duplicate naming conflicts
- Resource quotas
- Additional temporary costs

Always verify provider capabilities before enabling this setting.

---

## Prevent Destroy

### Purpose

Protect critical resources from accidental deletion.

Setting:

```hcl
prevent_destroy = true
```

Example:

```hcl
resource "aws_db_instance" "production" {

  lifecycle {
    prevent_destroy = true
  }

}
```

If Terraform attempts to delete the resource:

```text
Error: Instance cannot be destroyed
Resource has lifecycle.prevent_destroy set
```

---

### Recommended Use Cases

- Production databases
- Shared networking resources
- DNS zones
- Security infrastructure
- Critical storage systems

---

### Considerations

While useful for protection, prevent_destroy can complicate resource replacement and decommissioning activities.

Use only where justified.

---

## Ignore Changes

### Purpose

Tell Terraform to ignore specific attribute changes detected during refresh.

Example:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Terraform will no longer attempt to correct tag changes made outside Terraform.

---

### Common Use Cases

#### Automatically Updated Tags

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

#### Provider Managed Attributes

```hcl
lifecycle {
  ignore_changes = [
    last_modified
  ]
}
```

#### External Management Systems

Some attributes may be managed by:

- Automation platforms
- Security tooling
- Cloud-native services

Ignoring selected attributes prevents unnecessary drift correction.

---

### Risks

Overuse of ignore_changes may hide configuration drift.

Poor example:

```hcl
ignore_changes = all
```

This effectively disables Terraform's management of a resource.

Use the smallest possible scope.

---

## Replace Triggered By

### Purpose

Force resource replacement when another resource or attribute changes.

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.web
    ]
  }

}
```

When the launch template changes, the instance is replaced even if Terraform does not otherwise detect a direct dependency requiring replacement.

---

### Typical Use Cases

- Immutable infrastructure
- Virtual machine rebuilds
- Launch template updates
- Golden image changes
- Configuration replacement patterns

---

## Preconditions

### Purpose

Validate assumptions before Terraform performs an action.

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    precondition {
      condition     = var.instance_count > 0
      error_message = "Instance count must be greater than zero."
    }

  }

}
```

Terraform stops execution if the condition evaluates to false.

---

### Benefits

- Early failure detection
- Better error messages
- Improved module reliability
- Reduced deployment risk

---

## Postconditions

### Purpose

Validate outcomes after a resource has been evaluated.

Example:

```hcl
resource "aws_instance" "web" {

  lifecycle {

    postcondition {
      condition     = self.instance_state == "running"
      error_message = "Instance did not reach a running state."
    }

  }

}
```

Postconditions provide additional deployment assurance.

---

## Real-World Example

Example production database:

```hcl
resource "aws_db_instance" "production" {

  identifier = "prod-sql"

  lifecycle {

    prevent_destroy = true

    ignore_changes = [
      tags
    ]

  }

}
```

This configuration:

- Protects the database from deletion
- Allows external tag management
- Maintains Terraform control of all other attributes

---

## Common Anti-Patterns

### Ignoring Everything

Avoid:

```hcl
ignore_changes = all
```

This defeats much of Terraform's value.

---

### Protecting Every Resource

Avoid:

```hcl
prevent_destroy = true
```

on every resource.

Resource deletion is sometimes necessary and should not be unnecessarily blocked.

---

### Using Lifecycle to Hide Design Problems

Lifecycle settings should not be used to compensate for:

- Poor module design
- Bad dependency management
- Incorrect resource modelling

Address root causes first.

---

## Best Practices

### Do

- Use create_before_destroy for high-availability workloads
- Protect critical resources with prevent_destroy
- Use preconditions for validation
- Keep ignore_changes scopes small
- Document lifecycle decisions

### Don't

- Ignore all changes
- Add lifecycle rules without justification
- Use prevent_destroy everywhere
- Hide drift using ignore_changes
- Replace sound architecture with lifecycle workarounds

---

## Key Takeaways

- Lifecycle meta-arguments control Terraform resource behaviour.
- create_before_destroy reduces downtime during replacement.
- prevent_destroy protects critical resources.
- ignore_changes allows Terraform to tolerate specific external modifications.
- replace_triggered_by forces controlled replacements.
- Preconditions and postconditions add validation safeguards.
- Lifecycle settings are powerful tools that should be used deliberately and documented clearly.