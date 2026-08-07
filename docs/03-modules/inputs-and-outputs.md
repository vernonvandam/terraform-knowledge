# Module inputs and outputs

Inputs are variables defined by a module; outputs are the values it exposes to callers. Together they form the module API.

```hcl
variable "name" {
  description = "Stable service name."
  type        = string
}

output "id" {
  description = "Identifier of the managed service."
  value       = example_service.this.id
}
```

Use precise types, descriptions, and validation for inputs. Group related values in an object where that clarifies the contract, but avoid unnecessary nesting. Outputs should be stable, minimal, and meaningful to callers. Mark secret values sensitive, while protecting state separately.

Adding an optional input is generally compatible; changing an input type, removing an output, or changing output semantics is a breaking change.