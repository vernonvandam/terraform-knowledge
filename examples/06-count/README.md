# Example 06: Count

## Overview

This example demonstrates the Terraform `count` meta-argument.

`count` allows a resource to be created multiple times without duplicating code.

This is useful when several nearly identical resources are required.

---

## Files

```text
06-count/
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

- What `count` is
- How to create multiple resources
- How to use `count.index`
- How Terraform tracks counted resources
- When `count` should be used
- When `for_each` may be a better choice

---

## The Count Meta-Argument

Terraform supports:

```hcl
count = number
```

Example:

```hcl
resource "terraform_data" "application" {
  count = 3
}
```

Terraform creates:

```text
terraform_data.application[0]
terraform_data.application[1]
terraform_data.application[2]
```

---

## Using Count With Variables

A common pattern is:

```hcl
count = var.instance_count
```

This allows consumers to control the number of resources created.

Example:

```hcl
instance_count = 5
```

Terraform creates:

```text
5 resources
```

without modifying the Terraform code.

---

## Understanding count.index

Terraform automatically provides:

```hcl
count.index
```

during resource creation.

Example:

```hcl
name = "${var.application_name}-${count.index + 1}"
```

Output:

```text
customer-api-1
customer-api-2
customer-api-3
```

This is commonly used for naming resources.

---

## Resource Addresses

Resources created using count are indexed.

Example:

```text
terraform_data.application[0]
terraform_data.application[1]
terraform_data.application[2]
```

Terraform tracks each instance individually.

---

## Viewing the Plan

Initialize:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan \
  -var="application_name=customer-api"
```

Example output:

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

---

## Applying the Example

```bash
terraform apply \
  -var="application_name=customer-api"
```

Terraform creates three resources.

---

## Example Outputs

Example:

```text
resource_count = 3

resource_names = [
  "customer-api-1",
  "customer-api-2",
  "customer-api-3"
]
```

---

## Scaling Resources

Increase:

```hcl
instance_count = 5
```

Terraform plans:

```text
+ create application[3]
+ create application[4]
```

Only the new resources are created.

---

## Reducing Resources

Change:

```hcl
instance_count = 2
```

Terraform plans:

```text
- destroy application[2]
```

Terraform removes resources at the end of the list.

---

## Common Use Cases

Examples:

```text
Virtual Machines
Storage Accounts
Subnets
Application Instances
Development Environments
```

when resources are identical apart from naming or indexing.

---

## Limitations of Count

Consider:

```hcl
count = 3
```

Resources become:

```text
[0]
[1]
[2]
```

If one item is removed from the middle, Terraform may need to recreate resources because indexing shifts.

Example:

```text
[0]
[1]
[2]
```

becomes:

```text
[0]
[1]
```

This can create unnecessary changes.

---

## Count vs For_Each

### Count

Best for:

```text
Identical Resources
Sequential Resources
Simple Scaling
```

Example:

```hcl
count = 3
```

---

### For_Each

Best for:

```text
Named Resources
Independent Resources
Collections
Maps
```

Example:

```hcl
for_each = {
  dev  = "small"
  prod = "large"
}
```

`for_each` typically produces more stable resource addressing.

---

## Best Practices

### Do

- Use count for identical resources.
- Use variables to control resource quantity.
- Use count.index for naming.
- Validate count inputs.

### Don't

- Use count when each resource has a unique identity.
- Depend heavily on resource indexes.
- Mix count and for_each on the same resource.
- Use count for complex collections.

---

## Key Takeaways

- `count` creates multiple resource instances from a single resource block.
- Terraform assigns each instance an index.
- `count.index` can be used to create unique resource names.
- Resources created with count are stored using indexed addresses.
- Count works best for similar resources that differ only by number.
- For more complex collections, `for_each` is usually preferred.

---

## Next Example

Continue to:

```text
07-for-each
```

to learn how Terraform manages collections of uniquely identifiable resources.