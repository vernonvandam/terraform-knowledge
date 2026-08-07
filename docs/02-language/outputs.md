# Outputs

Outputs expose selected values from a root module to operators or from a child module to its caller. They are part of a module contract.

```hcl
output "service_name" {
  description = "The generated service name."
  value       = random_pet.service.id
}
```

Expose only values consumers or operators need. Give each output a description and mark confidential values as `sensitive = true` to prevent routine CLI display. Sensitive outputs are still retained in state, so protect backend access.

Avoid exposing an entire resource when one stable attribute is enough. Changing or removing an output can break callers, including remote-state consumers.