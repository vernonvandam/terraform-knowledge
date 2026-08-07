# Example 07: For_Each

## Overview

This example demonstrates the Terraform `for_each` meta-argument.

`for_each` allows Terraform to create multiple resource instances from a collection such as a map, set, or object. Each resource receives a unique key that Terraform uses for tracking and state management.

Unlike `count`, which relies on numeric indexes, `for_each` uses meaningful identifiers. This makes infrastructure easier to understand, maintain, and update over time.

---

## Files

```text
07-for-each/
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

- What `for_each` is
- How `for_each` differs from `count`
- How to iterate over collections
- How `each.key` works
- How `each.value` works
- How Terraform tracks resources created with `for_each`
- When `for_each` should be used instead of `count`

---

## The For_Each Meta-Argument

Terraform can create multiple instances of a resource using:

```hcl
for_each = collection
```

Example:

```hcl
resource "terraform_data" "application" {
  for_each = var.applications

  input = {
    application = each.key
    environment = each.value.environment
  }
}
```

Terraform creates one resource instance for every element in the collection.

---

## Understanding The Collection

The example uses a map of applications:

```hcl
applications = {
  customer-api = {
    environment = "dev"
  }

  inventory-api = {
    environment = "test"
  }

  billing-api = {
    environment = "prod"
  }
}
```

Terraform creates three resources:

```text
customer-api
inventory-api
billing-api
```

Each map key becomes the resource identifier.

---

## Understanding each.key

Terraform automatically provides:

```hcl
each.key
```

This represents the current item's key.

Example:

```hcl
application = each.key
```

Values produced:

```text
customer-api
inventory-api
billing-api
```

---

## Understanding each.value

Terraform also provides:

```hcl
each.value
```

This contains the current item's value.

Example:

```hcl
environment = each.value.environment
```

Results:

```text
dev
test
prod
```

---

## Resource Addresses

Resources created with `for_each` are stored using keys rather than indexes.

Terraform creates:

```text
terraform_data.application["customer-api"]

terraform_data.application["inventory-api"]

terraform_data.application["billing-api"]
```

These addresses are descriptive and easy to understand.

---

## Why Resource Keys Matter

Consider the following applications:

```text
customer-api
inventory-api
billing-api
```

With `for_each`, Terraform can directly identify each resource.

Example:

```text
terraform_data.application["customer-api"]
```

This is significantly more meaningful than:

```text
terraform_data.application[0]
```

used by `count`.

---

## Running The Example

### Initialize Terraform

```bash
terraform init
```

---

### Validate The Configuration

```bash
terraform validate
```

---

### View The Execution Plan

```bash
terraform plan
```

---

### Apply The Configuration

```bash
terraform apply
```

---

### Destroy The Resources

```bash
terraform destroy
```

---

## Example Plan Output

Terraform will create:

```text
terraform_data.application["billing-api"]

terraform_data.application["customer-api"]

terraform_data.application["inventory-api"]
```

Plan summary:

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

---

## Example Outputs

Example:

```text
application_count = 3

application_names = [
  "billing-api",
  "customer-api",
  "inventory-api"
]
```

Applications object:

```text
applications = {
  "billing-api" = {
    "application" = "billing-api"
    "environment" = "prod"
  }

  "customer-api" = {
    "application" = "customer-api"
    "environment" = "dev"
  }

  "inventory-api" = {
    "application" = "inventory-api"
    "environment" = "test"
  }
}
```

---

## Adding Resources

Add a new application:

```hcl
reporting-api = {
  environment = "dev"
}
```

Terraform plans:

```text
+ create reporting-api
```

Only the new resource is created.

Existing resources remain unchanged.

---

## Removing Resources

Remove:

```hcl
inventory-api = {
  environment = "test"
}
```

Terraform plans:

```text
- destroy inventory-api
```

Only that resource is removed.

The remaining resources continue to use their original addresses.

---

## Updating Resources

Modify:

```hcl
billing-api = {
  environment = "prod"
}
```

to:

```hcl
billing-api = {
  environment = "test"
}
```

Terraform updates only:

```text
billing-api
```

Other resources remain untouched.

---

## Accessing Individual Resources

A specific resource can be referenced directly.

Example:

```hcl
terraform_data.application["customer-api"].id
```

or:

```hcl
terraform_data.application["customer-api"].input.environment
```

This makes dependent configurations easier to read.

---

## Count vs For_Each

### Count

Example:

```hcl
count = 3
```

Creates:

```text
resource[0]
resource[1]
resource[2]
```

Best suited for:

- Identical resources
- Sequential numbering
- Simple scaling

---

### For_Each

Example:

```hcl
for_each = var.applications
```

Creates:

```text
resource["customer-api"]
resource["inventory-api"]
resource["billing-api"]
```

Best suited for:

- Named resources
- Maps
- Objects
- Distinct configurations
- Long-lived infrastructure

---

## Why For_Each Is Usually Preferred

Suppose the middle resource is removed.

With `count`:

```text
resource[0]
resource[1]
resource[2]
```

becomes:

```text
resource[0]
resource[1]
```

Terraform may need to recreate resources because indexes change.

With `for_each`:

```text
customer-api
inventory-api
billing-api
```

Removing:

```text
inventory-api
```

does not affect:

```text
customer-api
billing-api
```

Resource identities remain stable.

---

## Common Enterprise Use Cases

`for_each` is commonly used for:

```text
Resource Groups
Storage Accounts
Virtual Machines
Application Services
DNS Records
Firewall Rules
User Accounts
Network Security Rules
Kubernetes Namespaces
```

Any resource with a unique identity is a good candidate for `for_each`.

---

## Best Practices

### Do

- Use meaningful keys.
- Use maps and objects.
- Keep resource keys stable.
- Prefer `for_each` for named resources.
- Use descriptive identifiers.

### Don't

- Frequently rename keys.
- Use random values as keys.
- Use `count` for uniquely identifiable resources.
- Mix `count` and `for_each` on the same resource.
- Depend on unstable collection values.

---

## Common Pattern

A common enterprise pattern:

```hcl
variable "applications" {

  type = map(object({
    environment = string
  }))

}
```

Then:

```hcl
resource "terraform_data" "application" {
  for_each = var.applications
}
```

This allows infrastructure to scale simply by updating data structures rather than duplicating resource blocks.

---

## Key Takeaways

- `for_each` creates resources from collections.
- Resources are identified by keys instead of numeric indexes.
- `each.key` provides access to the current collection key.
- `each.value` provides access to the current collection value.
- Resource addresses remain stable when collections change.
- `for_each` generally produces safer and more maintainable infrastructure than `count`.
- Most enterprise Terraform implementations prefer `for_each` for resources with meaningful identities.

---

## Next Example

Continue to:

```text
08-dynamic-blocks
```

to learn how Terraform can dynamically generate nested configuration blocks from collections of data.