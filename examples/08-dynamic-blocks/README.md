# Example 08: Dynamic Blocks

## Overview

This example demonstrates the concept of Terraform dynamic blocks.

Dynamic blocks allow Terraform to generate nested configuration blocks programmatically based on input data.

They are commonly used when:

- The number of nested blocks varies
- Configuration is data-driven
- Duplicate code would otherwise be required

Dynamic blocks are especially useful for networking, firewall rules, security groups, monitoring rules, and access policies.

---

## Files

```text
08-dynamic-blocks/
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

- What dynamic blocks are
- Why dynamic blocks exist
- How nested blocks can be generated
- How `for_each` works inside dynamic blocks
- Common dynamic block use cases
- When dynamic blocks should be avoided

---

## The Problem Dynamic Blocks Solve

Consider a resource that requires multiple nested blocks.

Example:

```hcl
security_rule {
  name = "allow-web"
}

security_rule {
  name = "allow-api"
}

security_rule {
  name = "deny-all"
}
```

This approach works but becomes difficult to maintain when rules change frequently.

---

## Dynamic Block Syntax

Terraform supports:

```hcl
dynamic "<block_name>" {

  for_each = collection

  content {

  }

}
```

Example:

```hcl
dynamic "security_rule" {

  for_each = var.security_rules

  content {
    name = security_rule.value.name
  }

}
```

Terraform creates one nested block for each item in the collection.

---

## Understanding The Iterator

Inside the dynamic block Terraform automatically provides:

```hcl
security_rule.value
```

Example:

```hcl
dynamic "security_rule" {

  for_each = var.security_rules

  content {
    name = security_rule.value.name
  }

}
```

Each iteration receives one element from the collection.

---

## Example Input Data

This example uses:

```hcl
network_rules = [
  {
    name     = "allow-web"
    priority = 100
    action   = "Allow"
  },

  {
    name     = "allow-api"
    priority = 200
    action   = "Allow"
  }
]
```

This collection drives the generated configuration.

---

## Simulating Dynamic Configuration

Because this repository uses provider-neutral examples, the rules are transformed into a reusable structure using a for-expression.

Example:

```hcl
locals {
  generated_rules = [
    for rule in var.network_rules : {
      name     = rule.name
      priority = rule.priority
      action   = rule.action
    }
  ]
}
```

The resulting data structure represents what a dynamic block would typically generate.

---

## Example Output

```text
rule_count = 2

network_rules = [
  {
    action   = "Allow"
    name     = "allow-web"
    priority = 100
  },
  {
    action   = "Allow"
    name     = "allow-api"
    priority = 200
  }
]
```

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

## Real-World Dynamic Block Example

A common Azure Network Security Group pattern:

```hcl
dynamic "security_rule" {

  for_each = var.security_rules

  content {
    name                       = security_rule.value.name
    priority                   = security_rule.value.priority
    access                     = security_rule.value.access
    destination_port_range     = security_rule.value.port
  }

}
```

Terraform generates one security rule block for each entry.

---

## Common Use Cases

Dynamic blocks are commonly used for:

```text
NSG Rules
Security Group Rules
Firewall Rules
IAM Policies
Role Assignments
Monitoring Rules
Load Balancer Rules
Kubernetes Configurations
```

Any resource with repeatable nested blocks may benefit.

---

## When To Use Dynamic Blocks

Use dynamic blocks when:

- Block counts vary
- Configuration is data-driven
- Duplication becomes excessive
- Inputs are collections

Example:

```text
5 Rules Today
20 Rules Tomorrow
```

The configuration automatically adapts.

---

## When Not To Use Dynamic Blocks

Avoid dynamic blocks when:

- Only one block is needed
- Configuration is simple
- Dynamic logic reduces readability

Bad:

```hcl
dynamic "something" {
  for_each = [1]
}
```

If a normal block is sufficient, use a normal block.

---

## Dynamic Blocks vs For_Each

### For_Each

Creates:

```text
Multiple Resources
```

Example:

```hcl
resource "terraform_data" "application" {
  for_each = var.applications
}
```

---

### Dynamic Blocks

Creates:

```text
Multiple Nested Blocks
```

Example:

```hcl
dynamic "security_rule" {
  for_each = var.security_rules
}
```

This distinction is important.

---

## Best Practices

### Do

- Keep dynamic blocks simple.
- Use strongly typed variables.
- Validate input structures.
- Prefer data-driven configuration.
- Document expected inputs.

### Don't

- Overuse dynamic blocks.
- Create deeply nested logic.
- Replace simple blocks unnecessarily.
- Sacrifice readability for cleverness.

---

## Key Takeaways

- Dynamic blocks generate nested configuration blocks dynamically.
- They are powered by `for_each`.
- Dynamic blocks reduce duplication in complex resources.
- The iterator object provides access to current values.
- Dynamic blocks are useful for firewall rules, policies, and networking configurations.
- Simpler configurations should use regular blocks.
- Well-designed dynamic blocks improve maintainability without reducing readability.

---

## Next Example

Continue to:

```text
09-modules
```

to learn how Terraform modules create reusable, scalable infrastructure building blocks.