# Terraform Moved Blocks

## Overview

Moved blocks provide a safe and declarative way to refactor Terraform configurations without destroying and recreating infrastructure.

Introduced in Terraform 1.1, moved blocks allow Terraform to understand that a resource has changed its address within the configuration while continuing to manage the same underlying infrastructure object.

This capability is particularly important when:

- Renaming resources
- Refactoring modules
- Reorganising code structures
- Introducing reusable modules
- Migrating resources between modules
- Improving naming standards

Without moved blocks, Terraform may interpret refactoring as resource deletion and recreation, potentially causing downtime and data loss.

---

## Why Moved Blocks Matter

Terraform tracks resources using addresses stored in state.

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Terraform stores the resource in state using:

```text
aws_s3_bucket.logs
```

If the resource is renamed:

```hcl
resource "aws_s3_bucket" "application_logs" {
  bucket = "company-logs"
}
```

Terraform sees:

```text
aws_s3_bucket.logs            → deleted
aws_s3_bucket.application_logs → created
```

Without additional instructions, Terraform assumes the old resource should be destroyed and a new one created.

Moved blocks solve this problem.

---

## Basic Syntax

A moved block consists of a source address and a target address.

Example:

```hcl
moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.application_logs
}
```

Terraform understands that the resource has simply been renamed rather than replaced.

---

## How Moved Blocks Work

Terraform performs the following process:

```text
Read Configuration
         │
         ▼
Detect Moved Block
         │
         ▼
Update State Mapping
         │
         ▼
Generate Plan
         │
         ▼
No Resource Recreation
```

The underlying infrastructure remains unchanged.

Only the Terraform state mapping is updated.

---

## Resource Rename Example

Original configuration:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Updated configuration:

```hcl
resource "aws_s3_bucket" "application_logs" {
  bucket = "company-logs"
}

moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.application_logs
}
```

Terraform interprets this as a state move rather than a delete-and-create operation.

---

## Before Moved Blocks

Historically, resource moves required manual state manipulation.

Example:

```bash
terraform state mv \
  aws_s3_bucket.logs \
  aws_s3_bucket.application_logs
```

Challenges included:

- Manual execution
- Difficult automation
- No version control
- Limited auditability
- Increased risk of mistakes

Moved blocks provide a safer and more maintainable approach.

---

## Refactoring into Modules

One of the most common use cases is moving resources into modules.

### Original Configuration

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

### New Configuration

```hcl
module "networking" {
  source = "./modules/networking"
}
```

Moved block:

```hcl
moved {
  from = aws_vpc.main
  to   = module.networking.aws_vpc.main
}
```

Terraform preserves the existing VPC while updating its state location.

---

## Moving Resources Between Modules

Resources can also be moved between modules.

Example:

```hcl
moved {
  from = module.shared.aws_security_group.web
  to   = module.networking.aws_security_group.web
}
```

Terraform tracks the relocation and updates state accordingly.

No infrastructure recreation occurs.

---

## Multiple Resource Moves

Large refactoring efforts often require several moved blocks.

Example:

```hcl
moved {
  from = aws_vpc.main
  to   = module.networking.aws_vpc.main
}

moved {
  from = aws_subnet.app
  to   = module.networking.aws_subnet.app
}

moved {
  from = aws_route_table.main
  to   = module.networking.aws_route_table.main
}
```

Terraform processes each move independently.

---

## Refactoring Large Environments

A typical enterprise migration might look like:

```text
Root Module
    │
    ▼
Network Resources
Compute Resources
Storage Resources
```

After refactoring:

```text
modules/
│
├── networking
├── compute
└── storage
```

Moved blocks allow this transformation without rebuilding infrastructure.

This significantly reduces migration risk.

---

## Terraform Plan Output

When Terraform detects a moved block, output may resemble:

```text
# aws_s3_bucket.logs has moved to
# aws_s3_bucket.application_logs
```

Terraform recognises the relocation automatically.

Instead of showing destruction and creation actions, it updates state references.

---

## Moved Blocks and State

A moved block does not:

- Modify infrastructure
- Change resource settings
- Recreate resources
- Trigger replacements

It only updates Terraform's understanding of resource addresses.

Think of moved blocks as:

```text
State Refactoring
```

rather than:

```text
Infrastructure Changes
```

---

## Moving Resources with for_each

Resources created with `for_each` can also be moved.

Example:

Original:

```hcl
resource "aws_s3_bucket" "storage" {
  for_each = var.buckets
}
```

Move:

```hcl
moved {
  from = aws_s3_bucket.storage["logs"]
  to   = module.storage.aws_s3_bucket.storage["logs"]
}
```

Terraform updates the specific instance referenced by the key.

---

## Moving Resources with count

Resources using `count` can also be relocated.

Example:

```hcl
moved {
  from = aws_instance.web[0]
  to   = module.compute.aws_instance.web[0]
}
```

Terraform maps the indexed instance accordingly.

---

## Limitations

### Resource Types Must Match

Valid:

```hcl
moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.application_logs
}
```

Invalid:

```hcl
moved {
  from = aws_s3_bucket.logs
  to   = aws_instance.logs
}
```

Moved blocks are not intended to convert one resource type into another.

---

### Resources Must Already Exist

Moved blocks only apply to resources tracked in state.

Terraform cannot move:

- Non-existent resources
- Unmanaged resources
- Resources not yet created

---

### Infrastructure Changes Still Apply

If configuration changes occur during the move, Terraform may still propose updates.

Example:

```hcl
resource "aws_s3_bucket" "application_logs" {
  bucket = "new-bucket-name"
}
```

Although the resource was moved successfully, Terraform may still propose configuration modifications.

---

## Moved Blocks vs State Commands

### State Command

```bash
terraform state mv
```

Advantages:

- Immediate
- Useful in emergencies

Disadvantages:

- Manual process
- Not version controlled
- Difficult to audit

---

### Moved Block

```hcl
moved {
  from = old.address
  to   = new.address
}
```

Advantages:

- Declarative
- Version controlled
- Reviewable
- Repeatable
- Team-friendly

Disadvantages:

- Requires updated Terraform versions

For most situations, moved blocks are the preferred approach.

---

## Refactoring Workflow

Recommended workflow:

```text
Existing Resource
          │
          ▼
Refactor Configuration
          │
          ▼
Add Moved Block
          │
          ▼
Terraform Plan
          │
          ▼
Review Changes
          │
          ▼
Terraform Apply
```

This minimises risk during restructuring activities.

---

## Enterprise Use Cases

### Module Adoption

Move standalone resources into reusable modules.

### Naming Standard Improvements

Rename resources to align with organisational standards.

### Repository Restructuring

Split monolithic Terraform configurations into logical modules.

### Platform Modernisation

Migrate legacy Terraform layouts to modern architectures.

### Shared Service Consolidation

Move resources between modules while preserving state history.

---

## Best Practices

### Do

- Use moved blocks during refactoring activities.
- Commit moved blocks to source control.
- Review plans carefully before applying.
- Test large migrations in non-production environments.
- Document significant state restructuring exercises.

### Don't

- Use manual state commands when declarative moves are possible.
- Remove moved blocks before migration is complete.
- Combine major infrastructure changes with complex refactoring.
- Ignore Terraform plan output during state migrations.
- Assume resource configuration changes are automatically excluded.

---

## Common Mistakes

### Forgetting the Moved Block

After renaming:

```hcl
resource "aws_s3_bucket" "application_logs" {}
```

Without:

```hcl
moved {
  from = aws_s3_bucket.logs
  to   = aws_s3_bucket.application_logs
}
```

Terraform plans to destroy and recreate the resource.

---

### Incorrect Addresses

Example:

```hcl
moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}
```

If the addresses do not match entries in state, Terraform cannot perform the move.

Always verify resource addresses before refactoring.

---

## Real-World Example

A team begins with:

```text
root/
├── networking.tf
├── compute.tf
└── storage.tf
```

As the environment grows, modules are introduced:

```text
modules/
├── networking
├── compute
└── storage
```

Moved blocks allow resources to transition into the new structure while preserving:

- State history
- Existing infrastructure
- Resource identities
- Deployment stability

No downtime or resource recreation is required.

---

## Key Takeaways

- Moved blocks provide a declarative mechanism for refactoring Terraform configurations.
- They allow resources to be renamed or relocated without recreating infrastructure.
- Moved blocks replace many manual `terraform state mv` operations.
- They are particularly valuable when adopting modules and restructuring large Terraform codebases.
- Terraform updates state mappings while preserving existing infrastructure.
- Moved blocks improve safety, auditability, and maintainability during Terraform refactoring.
- Enterprise Terraform teams should prefer moved blocks whenever significant configuration restructuring is required.