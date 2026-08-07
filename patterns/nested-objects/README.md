# Nested objects

Use typed objects when related values form one domain concept.

```hcl
variable "services" {
  type = map(object({
    port   = number
    public = bool
    tags   = optional(map(string), {})
  }))
}
```

Add validation for meaningful rules. Avoid wrapping a single simple value in an object. Optional fields support deliberate backwards-compatible evolution; adding required fields can break callers.