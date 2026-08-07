# Terraform Standards

These standards apply to this repository and are the recommended baseline for projects derived from it.

## Engineering principles

1. Prefer simple, declarative, readable configuration.
2. Treat state and credentials as critical infrastructure data.
3. Make dependencies, versions, inputs, and outputs explicit.
4. Use modules to create stable interfaces, not merely to reduce file count.
5. Review a plan before every apply.
6. Preserve resource identity and document non-obvious trade-offs.

## Configuration conventions

- Run `terraform fmt -recursive` and require `terraform validate` in automation.
- Declare `required_version` and provider source addresses in root modules.
- Keep provider version constraints in `required_providers`, not provider blocks.
- Commit `.terraform.lock.hcl` for every root module; never commit `.terraform/` or state files.
- Use `snake_case` identifiers, typed variables, meaningful descriptions, and validation where it improves safety.
- Put complex derived values in `locals`; expose only intentional module outputs.
- Mark secrets `sensitive = true`; sensitivity does not encrypt state.

## Change safety

- Prefer `for_each` with stable business keys; avoid list-indexed `count` when order can change.
- Use `moved` blocks for address refactors and `import` blocks for repeatable onboarding.
- Avoid provisioners. Use lifecycle arguments and `depends_on` only for real, documented constraints.
- Use remote state with locking for shared infrastructure and separate state boundaries for independently deployed or permissioned systems.
- Configure providers in root modules. Child modules declare requirements but normally inherit configuration.

## Documentation and review

Pages explain the purpose, recommendation, example, trade-offs, and related topics. Patterns also state when to use and avoid them. Review versions, resource addresses, state and secret handling, and the safety of the proposed plan.