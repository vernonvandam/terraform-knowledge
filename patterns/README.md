# Terraform patterns

Patterns are reusable solutions to recurring Terraform design problems. Use the simplest one that preserves clear ownership and resource identity.

| Pattern | Use it when |
| --- | --- |
| [for_each](for-each/README.md) | Instances have stable, meaningful identities. |
| [CSV-driven resources](csv-driven-resources/README.md) | A versioned tabular source defines a predictable resource set. |
| [Nested objects](nested-objects/README.md) | A module needs a structured, validated input contract. |
| [Flattening](flattening/README.md) | Nested input becomes independently managed instances. |
| [Reusable modules](reusable-modules/README.md) | Consumers need a stable infrastructure interface. |
| [Multi-environment](multi-environment/README.md) | Environments need isolated state and approvals. |
| [Dependency management](dependency-management/README.md) | Ordering or cross-configuration dependencies must be explicit. |