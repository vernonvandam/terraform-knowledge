# Terraform Knowledge

A practical, vendor-neutral handbook for designing, reviewing, and operating Terraform configurations.

Start with the [documentation index](docs/README.md), follow the [Terraform standards](TERRAFORM-STANDARDS.md), review the [version and provider assumptions](docs/06-project-structure/version-and-provider-assumptions.md), and reuse the [patterns library](patterns/README.md).

## Repository structure

| Area | Purpose |
| --- | --- |
| `docs/` | Explanations and reference guidance, from fundamentals to advanced topics. |
| `patterns/` | Reusable approaches with context and trade-offs. |
| `examples/` | Small, executable configurations. |
| `.github/` | Automation for documentation and examples. |

## Learning path

1. Read the [fundamentals](docs/01-fundamentals/README.md).
2. Learn the language, modules, and state.
3. Apply the repository standards to a real configuration.
4. Start with the [basic example](examples/basics/README.md).

This is Terraform-focused and provider-neutral. Provider-specific configuration and credentials belong with the platform they manage. Content is checked on every pull request and push to `main`.