# Environment strategy

An environment strategy defines how development, test, and production configurations are isolated and promoted.

For production-like systems, use separate root modules and state per environment when credentials, policies, topology, or approvals differ. Share implementation through modules and pass environment-specific values through explicit inputs.

```text
live/
  development/
  production/
modules/
  service/
```

CLI workspaces can fit short-lived, structurally identical copies managed by one team and identity. They are not a substitute for state or access isolation. Plan and apply only the changed environment, and avoid an environment name that silently changes the identity or backend target.