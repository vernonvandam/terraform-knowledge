# Repository layout

A Terraform repository should make deployment boundaries, modules, and operational ownership obvious.

```text
modules/
  network/
  service/
live/
  development/
  production/
```

Each deployable root has its own backend configuration, provider configuration, inputs, and lock file. Shared modules contain reusable implementation, not environment-specific credentials or backend settings. Keep documentation close to concepts and examples close to runnable roots.

Choose a layout that matches ownership and release boundaries. Do not force unrelated systems into one root merely because they share a repository.