# State locking

Locking prevents concurrent operations from writing the same state and corrupting the record of managed objects. Use a backend with locking for shared state.

Terraform obtains a lock for operations that write state and releases it when the command finishes. If a run fails or is interrupted, inspect the active operation before using `terraform force-unlock`.

Never routinely use `-lock=false`; it trades a temporary error for a risk of state corruption. Resolve the competing run, verify the lock is stale and belongs to your state, then unlock only with the approval and audit trail appropriate to the environment.