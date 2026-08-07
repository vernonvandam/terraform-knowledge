# State overview

Terraform state maps configuration addresses to real infrastructure objects and stores attributes Terraform needs to plan changes. It is critical infrastructure data, not a disposable cache.

Protect state as carefully as credentials: it can contain identifiers, configuration values, and sensitive data. Use a remote backend for shared or production infrastructure, limit access, enable locking, and back it up according to the backend's capabilities.

A state boundary should match an independently deployed, permissioned, or recoverable system. Do not share one large state merely for convenience; it increases blast radius and contention.