# Resources

A resource block declares an object Terraform manages. Its address is part of the state contract.

```hcl
resource "random_pet" "service_name" {
  length    = 2
  separator = "-"
}
```

Choose stable, descriptive local names. Prefer `for_each` for stable multiple instances, reference resource attributes to express dependencies, and use `moved` blocks when a refactor changes an existing address. Use a data source for an object Terraform should read but not own.