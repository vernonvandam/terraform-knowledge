#!/usr/bin/env python3
"""
Bootstrap the terraform-knowledge repository structure.

Usage:
    python create_terraform_knowledge.py
    python create_terraform_knowledge.py ./terraform-knowledge
"""

from pathlib import Path
import argparse
import textwrap

REPO_NAME = "terraform-knowledge"

FILES = {
    "README.md": """# Terraform Knowledge

A structured knowledge base for Terraform concepts, patterns, best practices, and reusable examples.

## Repository Structure

- `docs/` — Terraform concepts and reference material
- `patterns/` — Reusable implementation patterns
- `examples/` — Working Terraform examples
- `.github/` — CI/CD and GitHub templates

## Purpose

This repository is vendor-neutral. Terraform-specific knowledge belongs here; provider- or platform-specific implementations should live in their respective repositories.
""",
    "CHANGELOG.md": """# Changelog

All notable changes to this repository will be documented here.

## Unreleased

- Initial repository structure created.
""",
    "ROADMAP.md": """# Roadmap

## Phase 1 — Foundation

- [ ] Document Terraform fundamentals
- [ ] Document Terraform language features
- [ ] Establish module design standards
- [ ] Establish state management guidance
- [ ] Establish project structure standards

## Phase 2 — Patterns

- [ ] Add reusable Terraform patterns
- [ ] Add CSV-driven resource examples
- [ ] Add module composition examples
- [ ] Add multi-environment examples

## Phase 3 — Engineering Practices

- [ ] Add testing guidance
- [ ] Add CI/CD guidance
- [ ] Add security and secrets guidance
- [ ] Add troubleshooting reference
""",
    "CONTRIBUTING.md": """# Contributing

## General Principles

- Keep documentation vendor-neutral unless a section explicitly targets a provider.
- Prefer practical examples over abstract explanations.
- Use clear Terraform terminology.
- Keep examples small and focused.
- Do not commit secrets, credentials, state files, or other sensitive material.

## Documentation

New topics should be added to the appropriate `docs/` section.

Reusable implementation techniques belong under `patterns/`.

Complete working examples belong under `examples/`.
""",
    "TERRAFORM-STANDARDS.md": """# Terraform Standards

This document defines the preferred Terraform engineering standards for this repository and projects derived from it.

## Principles

1. Prefer simple, readable Terraform.
2. Use reusable modules where they provide genuine value.
3. Pin Terraform and provider versions.
4. Treat state as critical infrastructure data.
5. Never hard-code secrets.
6. Prefer declarative Terraform resources over provisioners.
7. Use `for_each` when resources have stable logical identities.
8. Use meaningful variable, local, resource, and output names.
9. Keep provider-specific implementation details out of general-purpose knowledge.
10. Document non-obvious design decisions.

## Standard Decision Pattern

When Terraform offers multiple valid approaches:

1. Explain what Terraform supports.
2. Identify the generally recommended approach.
3. Define the repository/project standard.
4. Document exceptions and trade-offs.
""",
    "patterns/README.md": """# Terraform Patterns

Reusable implementation patterns for common Terraform problems.

Patterns should explain:

- The problem
- When to use the pattern
- When not to use it
- The implementation
- Trade-offs
- A working example
""",
}

DOC_SECTIONS = {
    "01-fundamentals": ["terraform-overview.md", "infrastructure-as-code.md", "providers.md", "resources.md", "data-sources.md", "terraform-lifecycle.md"],
    "02-language": ["variables.md", "locals.md", "outputs.md", "expressions.md", "functions.md", "conditionals.md", "for-each.md", "count.md", "dynamic-blocks.md"],
    "03-modules": ["module-structure.md", "module-design.md", "inputs-and-outputs.md", "module-composition.md", "module-versioning.md"],
    "04-state": ["state-overview.md", "remote-state.md", "state-locking.md", "state-migration.md", "terraform-import.md", "state-commands.md"],
    "05-providers": ["provider-configuration.md", "provider-versioning.md", "provider-aliases.md", "authentication.md"],
    "06-project-structure": ["repository-layout.md", "environment-strategy.md", "naming-standards.md", "configuration-management.md"],
    "07-cli": ["terraform-init.md", "terraform-plan.md", "terraform-apply.md", "terraform-destroy.md", "terraform-fmt.md", "terraform-validate.md", "terraform-console.md"],
    "08-testing": ["validation.md", "testing.md", "linting.md", "ci-cd.md"],
    "09-advanced": ["workspaces.md", "lifecycle.md", "dependency-graph.md", "import-blocks.md", "moved-blocks.md", "check-blocks.md"],
    "10-troubleshooting": ["common-errors.md", "debugging.md", "state-problems.md", "drift.md"],
    "11-best-practices": ["general.md", "security.md", "secrets.md", "version-pinning.md", "module-best-practices.md"],
}

PATTERNS = ["for-each", "csv-driven-resources", "nested-objects", "flattening", "reusable-modules", "multi-environment", "dependency-management"]
EXAMPLES = ["basics", "variables", "modules", "providers", "state", "advanced"]

GITHUB_FILES = {
    ".github/workflows/terraform-checks.yml": """name: Terraform Checks

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - name: Terraform Format Check
        run: terraform fmt -check -recursive
""",
    ".github/workflows/markdown-checks.yml": """name: Markdown Checks

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  markdown:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check Markdown files exist
        shell: bash
        run: |
          find . -name '*.md' -print >/dev/null
          echo "Markdown files discovered successfully."
""",
}

def build_file_map():
    files = dict(FILES)
    files.update(GITHUB_FILES)

    for section, filenames in DOC_SECTIONS.items():
        for filename in filenames:
            files[f"docs/{section}/{filename}"] = ""

    for pattern in PATTERNS:
        files[f"patterns/{pattern}/README.md"] = (
            f"# {pattern.replace('-', ' ').title()}\\n\\n"
            "Pattern documentation to be developed.\\n"
        )

    for example in EXAMPLES:
        files[f"examples/{example}/README.md"] = (
            f"# {example.replace('-', ' ').title()} Examples\\n\\n"
            "Working Terraform examples to be added here.\\n"
        )

    files[".github/ISSUE_TEMPLATE/.gitkeep"] = ""
    return files

def create_repository(target):
    target = Path(target).expanduser().resolve()
    target.mkdir(parents=True, exist_ok=True)

    created_files = []
    skipped_files = []

    for relative_path, content in build_file_map().items():
        path = target / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)

        if path.exists():
            skipped_files.append(relative_path)
            continue

        path.write_text(textwrap.dedent(content).lstrip(), encoding="utf-8")
        created_files.append(relative_path)

    print("\\nTerraform repository bootstrap complete.")
    print(f"Target: {target}")
    print(f"Created: {len(created_files)} file(s)")
    print(f"Skipped: {len(skipped_files)} existing file(s)")

    if created_files:
        print("\\nCreated:")
        for item in created_files:
            print(f"  + {item}")

    if skipped_files:
        print("\\nSkipped existing files:")
        for item in skipped_files:
            print(f"  = {item}")

    print("\\nThe script is safe to rerun; existing files are never overwritten.")

def main():
    parser = argparse.ArgumentParser(description="Create the terraform-knowledge repository structure.")
    parser.add_argument("target", nargs="?", default=REPO_NAME,
                        help="Directory in which to create the repository (default: terraform-knowledge)")
    args = parser.parse_args()
    create_repository(args.target)

if __name__ == "__main__":
    main()
