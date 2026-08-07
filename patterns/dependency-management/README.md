# Dependency management

Prefer implicit dependencies expressed through references:

```hcl
resource "terraform_data" "producer" { input = "value" }
resource "terraform_data" "consumer" { input = terraform_data.producer.output }
```

Use `depends_on` only for a real ordering rule not visible in arguments, and document the reason. Connect root configurations through deliberate outputs and inputs; avoid remote-state coupling unless that output is a stable API.