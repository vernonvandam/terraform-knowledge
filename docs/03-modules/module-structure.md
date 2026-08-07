# Module structure

A module is a directory of Terraform files. The directory where Terraform runs is the root module; modules called by it are child modules.

A small reusable module commonly uses this layout:

```text
modules/service/
  main.tf
  variables.tf
  outputs.tf
  versions.tf
  README.md
```

Organise by responsibility, not file-count rules. Keep provider configuration and backend configuration in root modules. Child modules declare their provider requirements, inputs, resources, and outputs.

Use a module only when it represents a cohesive capability or stable ownership boundary. A module source can be local, a registry address, Git, HTTP, or an object store; pin remote sources deliberately.