# Contributing

Keep guidance practical, vendor-neutral, and safe to apply.

- Follow [Terraform Standards](TERRAFORM-STANDARDS.md); never commit credentials, private endpoints, state, or `.terraform/` directories.
- Documentation explains the problem, recommendation, example, trade-offs, and related topics. Use `hcl` fences and relative links.
- Patterns belong under `patterns/<name>/README.md` and explain when to use and avoid them.
- Examples are self-contained root modules, include a short README, and validate without credentials.
- Update navigation and the changelog when a change is notable.

Before submitting, run `terraform fmt -check -recursive`, then initialise and validate changed examples with `terraform init -backend=false` and `terraform validate`.