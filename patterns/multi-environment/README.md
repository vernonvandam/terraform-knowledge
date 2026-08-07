# Multi-environment configuration

Use separate root configurations and state boundaries where environments have different permissions, topology, approval processes, or recovery requirements.

```text
live/
  development/
  production/
modules/
  service/
```

Share logic through modules, not shared state. CLI workspaces can suit short-lived, structurally identical copies managed by one team, but are not a substitute for production isolation.