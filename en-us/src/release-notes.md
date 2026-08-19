# Release Notes

## Version 1.14.4

Version 1.14.4 adds controller recovery and EtherCAT topology-maintenance
workflows, strengthens configuration and software-update handling, and bounds
HMI WebSocket traffic.

### EtherCAT Controller Lifecycle and Recovery

- A ready controller can rescan EtherCAT hardware without restarting the
  `bnc-motion` service. Live WebSocket sessions are rebound to the replacement
  runtime generation.
- Controller startup verifies the connected EtherCAT topology against the
  expected profile and reports its stage and retry countdown.
- An operator can stop a startup that is still waiting for the expected
  topology. This ends the current attempt; it does not restore the previous
  controller generation.
- If the controller is unavailable, the HMI can review the saved machine
  profile, correct it if necessary, and start a replacement controller from
  that exact saved version.
- Recovery source, stage, outcome, and availability are restored after an HMI
  reconnect.
- Botnana Control prevents another in-process start after uncertain controller
  cleanup. In that case, an authorized administrator must restart the
  `bnc-motion` service before trying again.

### EtherCAT Topology Maintenance

- The new topology-maintenance workflow supports deliberate slave additions,
  removals, replacements, and reordering.
- The HMI keeps configured slaves, detected slaves, a proposed topology, the
  saved profile, and the running controller separate.
- Scanning is read-only and never adopts connected hardware automatically. An
  operator must explicitly use the complete detected topology, review its
  consequences, save it while inactive, and apply the exact saved version.
- Device-specific settings and mappings affected by removed, replaced, moved,
  or ambiguously identified slaves must be reviewed before saving.
- Maintenance state is owned by the controller and can be restored after a
  browser reload or from another HMI session.

### Machine-Profile Editing and HMI

- The HMI now provides separate **Controller & Topology**, **Slave
  Configuration**, **Motion**, and **Axis Group** work areas through a common
  primary navigation bar.
- Profile edits remain available while the controller is unavailable,
  restarting, or starting, except while topology maintenance owns the profile.
- Draft and saved profile revisions prevent stale edits, saves, discards, and
  controller starts from another browser session.
- Profile changes are validated and applied atomically. A failed save retains
  the unsaved draft for correction or retry.
- **Motion** and **Axis Group** distinguish values used by the active controller
  from saved or draft configuration. Saving prepares values for a later
  controller start; it does not apply them to the running controller.
- EtherCAT vendor ID and product code remain read-only in ordinary **Slave
  Configuration** editing. Expected identity changes use the guided topology
  workflow.
- Server IP-address changes are validated, saved atomically, acknowledged by
  the HMI, and take effect after reboot.
- Spreadsheet layouts, profile status, action availability, and recovery
  controls have been revised for clearer operation on constrained displays.

### Software Updates and HMI Runtime

- The legacy Node.js HMI server has been replaced by a bounded Rust HTTP server.
- Debian packages are inspected before staging. The About page shows the exact
  package identity, version, architecture, classification, and SHA-256 for
  review.
- A reviewed Botnana Control package is staged for one installation attempt at
  the next boot. A pending package can be cancelled before installation starts.
- The About page reports the authoritative installation result after reboot.
- A failed, timed-out, interrupted, or incompletely recorded installation can
  block motion until a reviewed recovery package is installed successfully.
- The exact retained prior successful package can be reviewed and staged for a
  deliberate rollback when it is available.
- Botnana Control distinguishes its managed package from packages owned by an
  external updater.

### Bounded WebSocket Traffic

- The bundled HMI uses one outbound request budget for bootstrap, heartbeat,
  visible-value polling, and deliberate actions. It stores at most five request
  permissions and refills at 100 requests per second.
- Hidden work areas no longer continue high-frequency live polling. Superseded
  polling is replaced instead of accumulating into a catch-up burst.
- Deliberate operator and motion actions receive priority but remain inside the
  same request budget.
- The motion server independently applies per-connection admission. Recognized
  latest-value polls may be coalesced; mutations and unknown work are never
  silently discarded or repeated.
- When a request is not admitted, the server reports at most one overload
  indication during the one-second overload period:

  ```text
  error|WebSocket request limit exceeded. Non-admitted requests during the next 1 second have no effect; retry later.
  ```

- Excess request rate alone does not close the connection. One overloaded
  connection does not consume another connection's admission budget.
- The built-in HMI **Support diagnostics** view, opened from **About**, compares
  separate **Poll requests** and **Ordered requests** rates, admission totals,
  p95 receive-to-admit wait,
  class-specific outcomes, and output status for both active WebSocket clients.
  Closed clients are removed and their counters are not retained. Admission wait
  is not response or command-completion time.
- **Download diagnostic log** returns an operator-initiated ZIP with a summary,
  allowlisted runtime metadata, and categorized current/previous-boot records
  for `bnc-motion` and `bnc-hmi`. The ZIP is at most 10 MiB, reports omissions
  and truncation, is not retained, and is never uploaded automatically. The
  limit is a size bound, not a guaranteed number of log hours.
- The diagnostic download action remains fully visible above the dialog actions
  after scrolling at the desktop browser content height.
- WebSocket output no longer blocks the event loop, and closing a connection
  releases its socket, output worker, and assigned rtForth user task.

### Compatibility Notes

- The bundled HMI and motion server must be upgraded together. Bundled-HMI
  configuration mutations use protocol v2 and reject stale draft revisions.
- Release 1.14.4-21 and later also accepts the unchanged configuration setters
  and parameterless `config.save` emitted by the released customer libraries.
  Use only one configuration editor at a time because these legacy requests
  cannot detect concurrent draft changes.
- Existing JSON-RPC-over-WebSocket and pipe-delimited rtForth response formats
  remain in use, but clients that exceed the 1.14.4 admission boundary can now
  receive the explicit overload result shown above.
- Botnana Control still provides two rtForth user sessions for WebSocket
  clients.
- The **Support diagnostics** traffic comparison and diagnostic download are
  internal built-in-HMI functions, not additions to the supported customer JSON
  API.
- An accepted `script.evaluate` request still has no general success or
  completion acknowledgement. A successful WebSocket send or the absence of an
  error is not proof that a state-changing script ran.
- A custom HMI should keep group selection, a group-dependent command, and its
  readback in the same `script.evaluate` request. After overload, timeout, or
  disconnection, it must reconcile controller state before deciding whether a
  retry is safe.

See [Getting Started](./botnana-control-tutorial.md#diagnose-hmi-websocket-traffic)
for the built-in traffic comparison. See [JSON API](./json-api.md) for the
custom-HMI traffic and command-verification recommendations, and
[Software Updates](./update-software.md) for the package update procedure.

## Version 1.14.3

### Changes Since Version 1.14.1

- The WebSocket watchdog period increased from 4 to 10 seconds, improving
  tolerance for temporary communication delays.
- Conservative custom-HMI connection, polling, and command-verification
  recommendations were added for a server that did not yet enforce bounded
  per-connection admission.
