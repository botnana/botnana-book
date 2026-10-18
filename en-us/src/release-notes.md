# Release Notes

## Version 1.14.19

Version 1.14.19 delivers complete mixed Digital and Analog I/O slice commissioning for MOONS' MET2-EC00 modular couplers, ETG.5001 slot-based PDO address resolution, upfront SDO `0xF050`/`0xF030` physical slice discovery, flexible 2-byte UINT subindex 0 SDO uploads, and structured `startupError` reporting in EtherCAT topology diagnostics.

### MOONS' MET2-EC00 Mixed Digital & Analog I/O Expansion
- **Full Slice Family Support**: Official profile and commissioning support for the MOONS' MET2 modular slice system connected to the `MET2-EC00` (`0x00000168:0x00000132`) EtherCAT coupler:
  - `MET2-DI16` (`0x00008221`): 16-channel digital input slice supporting `WORD` (16-bit), `BYTE` (8-bit), and `BIT` (1-bit) modes.
  - `MET2-DO16-N` (`0x00008222`) / `MET2-DO16-P` (`0x00008225`): 16-channel digital output slices (NPN / PNP) supporting `WORD`, `BYTE`, and `BIT` modes.
  - `MET2-AI04` (`0x00008223`): 4-channel 16-bit analog input slice supporting signed `INT` and unsigned `UINT` representations.
  - `MET2-AO04` (`0x00008224`): 4-channel 16-bit analog output slice supporting signed `INT` and unsigned `UINT` representations.
- **ETG.5001 Slot-Increment PDO Resolution**: Resolves modular slot PDO addressing based on `SlotPdoIncrement = 0x10` and `SlotIndexIncrement = 0x10`. Maps slot `s` to `0x1A00 + 0x10*s` (inputs) and `0x1600 + 0x10*s` (outputs). Correctly navigates non-consecutive PDO tables, gracefully skipping unassigned intermediate indices (e.g. `0x1A01:00` Capability absent) without failing startup.
- **Diagnostic Register & Mode Compatibility**: Automatically handles the per-slot 16-bit `Err` status register mapped at subindex `:0x01` across all MET2 slice types, correctly identifying true I/O payloads at subindex `:0x02`.
- **Targeted CiA 402 Filtering**: Restricts CiA 402 denylist checks to drive axes, eliminating false-positive rejections of ETG.5001 digital I/O slices situated in Slot 4 (`0x6040`) and Slot 6 (`0x6060`).

### Upfront Module Discovery & Flexible Subindex 0 SDO Upload
- **Upfront Backplane Slice Discovery**: Reads SDO `0xF050` (detected modules) and `0xF030` (configured modules) upfront during startup, decoupled from PDO mapping queries. Guarantees that physical backplane inventory is always recorded in topology diagnostics even if subsequent PDO mapping encounters errors.
- **Flexible Subindex 0 SDO Buffer Capacity**: Replaces 1-byte buffer allocations (`RequestValue::U8`) with 32-bit requests (`RequestValue::U32`) for reading subindex `0` count entries on `0x1C12`, `0x1C13`, `0x16xx`, and `0x1Axx`. Fully accommodates 2-byte `UINT` and expedited 4-byte responses, eliminating buffer overflow errors (`-EOVERFLOW` / `-75`).

### Structured Startup Mailbox Error Diagnostics
- **Detailed `startupError` in Topology Evidence**: `ethercat/topology.json` now includes a `startupError` field on failing slaves that captures the exact SDO abort code or mailbox error message (e.g. `"slave 1 startup mailbox error: Failed to read entry count for PDO 0x1A01:00: Capability absent"`), enabling immediate field diagnosis without trial-and-error log parsing.
- **Classified Journal Logging**: Motion server logs now format CoE discovery failures (`event: "coeDiscoveryFailed"`) and startup mailbox errors (`event: "startupMailboxError"`) with structured `error` severity and syslog priority prefixes, ensuring they are clearly preserved in support diagnostic archives.

## Version 1.14.17

Version 1.14.17 delivers official support for MOONS' MET2-EC00 modular couplers, non-panicking modular gateway startup dispatch, and robust support diagnostics with EtherCAT topology evidence collection and clock-adjustment resilience (SD-REQ-001-r4, SD-REQ-001-r5).

### MOONS' MET2-EC00 Modular Coupler & Safe Gateway Routing
- **Compound Gateway Priority Dispatch**: Compound modular gateways are dispatched to dynamic CoE discovery prior to generic device-type checks. Prevents ETG.5001 modular devices (`0x00001389`) from erroneously matching encoder catch-all rules.
- **Accurate Product Identification**: Canonical vendor ID and product code `0x00000168:0x00000132` correctly assigned for MOONS' MET2-EC00.
- **Fail-Safe Startup Mailbox Errors**: Replaces unhandled panic traps in encoder module configuration with descriptive startup mailbox errors identifying the exact slave position and identity.

### Robust Support Diagnostics & EtherCAT Topology Evidence
- **Packaged EtherCAT Topology Evidence**: Support diagnostic archives now package `/run/botnana-control-motion/ethercat-topology.json` into `ethercat/topology.json`, capturing slave identities, sync managers, assigned PDOs, detected modules, and mapping fingerprints across runtime restarts.
- **Journalctl Path Fallback**: The diagnostic collector resolves `journalctl` via `PATH` and falls back from `/usr/bin/journalctl` to `/bin/journalctl`, ensuring complete log capture on Debian systems with unmerged `/usr`.
- **Clock-Adjustment Resilience**: Journal record ordering is evaluated against journald boot-relative monotonic time (`__MONOTONIC_TIMESTAMP`) rather than wall-clock time. Avoids archive generation failures (`HTTP 503`) when NTP or `systemd-timesyncd` steps the clock back, accurately reporting `clockAdjusted: true` in the diagnostic manifest and summary.

## Version 1.14.16

Version 1.14.16 delivers Dynamic CoE I/O Discovery, compound gateway topology fingerprinting, and a declarative device profile engine (ADR-015), significantly enhancing fieldbus modularity, dynamic I/O discovery, and startup safety.

### Dynamic CoE PDO Discovery & Semantic Channel Typing
- **Fallible CoE Dictionary Traversal**: Implements fallible CoE PDO object dictionary traversal, extracting actual bit lengths and accumulating bit offsets across multiple PDO entries.
- **Dynamic Digital & Analog I/O Classification**: Dynamically classifies digital (DIN/DOUT) and analog (AIN/AOUT) channels without hardcoded slave offsets.
- **SDO 0x1008 Device Name Upload**: Bounded timeout upload of manufacturer device names (SDO 0x1008) with safe string slicing, accurately distinguishing compound gateways from standard modular couplers.

### Compound Gateway Topology Fingerprinting
- **Deterministic Topology Fingerprint Verification**: Computes and validates ordered topology fingerprints (vendor, product, revision, serial, and module layout) for modular gateway racks. Halts startup cleanly in a fail-closed manner if physical backplane slices do not match commissioned configuration.
- **Ordered Startup SDO Execution**: Declarative startup SDO writes execute strictly during PREOP -> SAFEOP transition after topology fingerprint verification passes, guarded by strict integer range validation across U8/U16/U32 and I8/I16/I32 types.

### Declarative Device Profiles Engine & HMI Decoupling
- **TOML Declarative Device Profiles**: Introduces schema-validated declarative device profiles in TOML, eliminating imperative drive and coupler hardcoding.
- **Dynamic I/O Labels & Editor Safety**: Decouples HMI slave descriptors from fixed configuration schemas, synthesizing live slave positioning and I/O channel labels while preserving `kind = "configurable"` whenever child devices are configured to keep drive, serial, and encoder configuration editors fully accessible.

## Version 1.14.15

Version 1.14.15 delivers the streamlined HMI configuration platform (ADR-014), introducing direct spreadsheet cell editing, a persistent floating bottom commit bar with diff review, mode-driven drive parameter display in a unified table, and protocol gating.

### Direct Spreadsheet Cell Editing & Auto-Drafting
- **In-Place Cell Editing**: Configuration grids across Motion, AxisGroup, and Slave Configuration support direct inline cell editing, permanently retiring modal dialogs and the legacy "Edit profile" mode.
- **Unified Dual-Effect Tuning**: Editing a cell dispatches live volatile SDO tuning immediately when the controller is running, while automatically queuing the persistent change into the shared draft without premature disk mutations.

### Floating Bottom Configuration Commit Bar & Diff Review
- **Persistent Change Tracking**: A floating bottom commit bar dynamically indicates the number of unsaved changes across all configuration screens with one-click **Save to Disk** and **Discard Changes** actions.
- **Collapsible Diff Review Drawer**: Clicking **Review Changes** expands a review drawer displaying before-and-after values with strikethrough comparison across all modified screens. Discarded edits are safely preserved in draft memory.
- **Dynamic Table Resizing**: The spreadsheet table automatically tracks commit bar and drawer dimensions via `ResizeObserver`, ensuring no rows are obscured when the review drawer is toggled.

### Mode-Driven Drive Parameters in Unified Table
- **Context-Aware Parameter Display**: Replaces the legacy parameter group toggle with a single unified table. Parameters automatically reflect the active drive channel's reported operation mode: 5 homing parameters in `home` mode, or 3 profile motion parameters in `pp`, `pv`, or `csp` modes. Multi-channel drives resolve each channel independently.
- **Offline / Telemetry Disconnection Grace**: When disconnected from the controller or when telemetry is null, an explicit "Unavailable" placeholder is presented, revealing all 8 parameters for offline drafting while ensuring inert command boundaries.

### Protocol Safety & Lifecycle Protection
- **Protocol Gating**: Configurable inputs are strictly disabled and edits dropped if configuration protocol version 2 is not negotiated or signals `upgrade-required`.
- **Relocated Configuration Utilities**: JSON configuration backup and disaster-recovery upload buttons are relocated to the About dialog under Machine configuration.

## Version 1.14.13

Version 1.14.13 introduces the dual-loop "Tune Live -> Adopt to Profile" architecture, eliminates UI mode ambiguities, provides interactive drive parameter tuning, adds guided controller restart upon profile save, and delivers robust warm-boot master discovery resilience.

### Dual-Loop "Tune Live -> Adopt to Profile" Architecture
- **Interactive Live Drive Tuning**: When in live view (read-only mode), motion parameters (Profile Velocity, Profile Acceleration, Profile Deceleration) can be adjusted interactively and committed directly to volatile drive RAM via Enter key or Blur. Intermediate keystrokes are suppressed and disk configuration remains untouched.
- **Revision-Safe "Adopt Live Values"**: In profile-editing mode, a single-click "Adopt Live Values" action pulls active drive velocity and acceleration into the shared draft, sequentially chaining updates with strict revision safety across single- and multi-axis drives (Delta ASDA-A2-E, Oriental Motor AZD2B/AZD4A).
- **Parameter Group & Live Mode Decoupling**: Completely eliminates the ambiguous "Mode" dropdown from configuration table cells, replacing it with an explicit parameter group selector (`[ Homing Parameters ]` / `[ Profile Motion (PP) Parameters ]`). Live operation mode selection is strictly isolated to live view.

### Lifecycle-Aware Guided Controller Restart
- **Actionable Post-Save Banner**: Saving profile changes renders a high-visibility status banner (`Configuration saved to disk. [Restart Controller to Apply]`).
- **Lifecycle Routing**: Clicking the action dynamically routes to `ethercat.rescan` when the controller is Ready, or `ethercat.recover` when in a Failed state per ADR-001.

### Warm-Boot Master Discovery Resilience
- **Pre-Op Convergence Loop**: Bounded pre-op settling loop continuously holds the reserved EtherCAT master during slave convergence on host warm reboots (`sudo reboot`), eliminating reservation teardown thrashing and race conditions. All powered slaves automatically return to PREOP and transition smoothly to OP without manual cable replugging or manual rescan.

### Strict Dead-Code Hygiene
- Eradicated all test-only helper exports, unused export aliases, and vestigial test scaffolding to satisfy strict Phase 6 qualification requirements.

## Version 1.14.12

Version 1.14.12 is a production-hardened release delivering multi-axis drive integration, boot diagnostic visibility, low-latency communication optimizations, and configuration preservation guarantees.

### Startup Diagnostics & Slave Telemetry Visibility
- **Per-Slave AL State Telemetry**: The Detected Slaves table in HMI features an `AL State` column, displaying live Application Layer states (`OP`, `SAFEOP`, `PREOP`, `INIT`) with clear status coloring.
- **Attributable Startup Timeout Diagnostics**: When startup fails to reach OP within the deadline, the error message pinpoints the exact unready slave positions and states (e.g., `slaves not in OP: Slave 8 (PREOP)`), accelerating field troubleshooting.
- **Uncommissioned Machine Guidance**: Clear banner appears when a controller boots with an empty configuration, offering one-click topology adoption or profile upload.

### Hardware Catalog Expansion
- **Oriental Motor Multi-Axis Drivers**: Full support for AZD2B-KED (2-axis) and AZD4A-KED (4-axis) drivers with supported factory homing method 24 and dynamic Profile Position (PP) parameters.
- **Delta / Syn-Tek R1 Series**: Comprehensive 16-tuple catalog support for R1 bus couplers (R1-EC5500), 1-axis pulse drive modules (R1-EC5621), digital inputs (R1-EC6002/6022), digital outputs (R1-EC7062/70E2), analog inputs (R1-EC8124), and analog outputs (R1-EC9144).

### Configuration Safety & Disaster Recovery
- **Upgrade Protection**: Debian package upgrades 100% preserve existing `/etc/botnana-control/motion.toml` configuration files without overwrite.
- **HMI Backup & Restore**: One-click configuration download and disaster-recovery upload directly accessible through the browser.

### Fieldbus & Real-Time Performance
- **Low-Latency WebSocket Transport**: Enabled `TCP_NODELAY` on WebSocket connections, reducing round-trip communication latency to 0.14 ms for responsive HMI and host interactions.
- **EtherCAT Distributed Clocks (DC) Recovery**: Automatic reference clock re-acquisition upon bus re-attachment.
- **HMI Live Control Guarding**: Restored digital/analog output editing and fail-closed dispatch guarding against offline or unmapped slaves.

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
  for `bnc-motion` and `bnc-hmi`. The ZIP is at most 50 MiB, reports omissions
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
