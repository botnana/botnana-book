# System Architecture

Botnana Control 1.14.4 separates browser delivery, configuration and lifecycle
coordination, privileged software updates, and real-time motion execution. A
controller-runtime failure therefore does not automatically remove the HMI or
the saved machine profile.

## Deployment at a Glance

```text
Operator browser                          Customer application
  | HTTP :3000       | WebSocket :3012        | WebSocket :3012
  v                  +--------------------+    |
+----------------------+                  v    v
| hmi-server           |             +------------------------+
| unprivileged HTTP    |             | motion-server          |
+----------+-----------+             | profile + lifecycle    |
           |                         +-----------+------------+
           | fixed local Unix socket             |
           v                           supervised runtime
+----------------------+                         |
| update-agent         |               +---------v------------+
| package inspection  |               | rtForth VM + motion  |
| and staging         |               | engine + EtherCAT HAL|
+----------------------+               +---------+------------+
                                                 |
                                       EtherCAT master / slaves
```

The browser makes two independent network connections to the controller:

- HTTP port `3000` retrieves the packaged HMI and handles the reviewed software
  update workflow.
- WebSocket port `3012` carries controller status, revision-aware profile work,
  live values, commands, and rtForth evaluation.

Customer applications connect directly to the motion WebSocket. The Rust
`hmi-server` does not proxy real-time traffic, and `motion-server` does not
serve browser files. The HMI JavaScript bundles are built before packaging; the
controller no longer needs a deployed Node.js HTTP server.

## Processes and Authority

systemd starts the installed components with separate responsibilities.

| Component | Responsibility and boundary |
|---|---|
| `bnc-update.service` | Runs the boot-only update decision before the normal HMI and motion services. It processes at most one confirmed managed package attempt. |
| `update-agent` daemon | Owns package inspection, revisioned update state, atomic staging, retained packages, and the motion-admission decision. Its fixed local socket does not accept arbitrary paths or shell commands. |
| `hmi-server` | Runs as a systemd dynamic user. It streams packaged static files, writes its bounded message log, and forwards only fixed update operations to `update-agent`. It has no package-manager or general root authority. |
| `motion-server` | Owns the WebSocket server, shared machine profile, EtherCAT topology workflow, runtime supervisor, and the current real-time controller generation. |
| EtherCAT service and master | Own the native EtherCAT master and device communication used by the hardware-abstraction layer. |

A boot update reaches a terminal decision before the HMI and motion are
admitted. A failed installation can leave a durable motion block: the HMI is
then started when possible so the operator can inspect the result and stage a
reviewed recovery package, while `motion-server` remains blocked.

## Motion Server and Replaceable Runtime Generations

`motion-server` contains a non-real-time server/control plane and a replaceable
real-time controller generation.

```text
WebSocket connections
        |
        v
+-----------------------------------------------------------+
| Non-real-time motion-server control plane                 |
|                                                           |
| Request admission     Shared MachineProfile               |
| LiveConnectionRegistry RuntimeSupervisor                  |
| Configuration and topology request coordinators          |
+-------------------------------+---------------------------+
                                |
                      generation-bound channels
                                |
+-------------------------------v---------------------------+
| Runtime generation N                                      |
| request/response tasks <-> rtForth VM tasks               |
| controller task -> motion engine -> hardware abstraction  |
+-----------------------------------------------+-----------+
                                                |
                                      EtherCAT master
```

The process-level server remains available while its controller generation is
starting, being replaced, or failed. This allows the HMI to continue showing
lifecycle status, retained topology evidence, and profile-editing recovery
controls without publishing unavailable live motion values as healthy.

The main ownership boundaries are:

- `MachineProfile` owns the saved profile and its revision-aware shared
  in-memory draft.
- `RuntimeSupervisor` owns the active generation, its lifecycle, the most
  recent Ready build plan, startup provenance, and the latest complete physical
  topology observation.
- `LiveConnectionRegistry` owns live WebSocket membership, assembles bounded
  traffic counters for active sessions, and detaches or rebinds each session
  when a generation changes.
- Each WebSocket session owns a generation-specific binding to one of the two
  rtForth user tasks. A stale binding cannot submit work to a replacement
  generation.

Incoming work is admitted per connection. Replaceable latest-value polling may
be coalesced, while non-admitted commands are never silently replayed. Each
connection also has a bounded output worker and queue, so a slow or saturated
client cannot block the WebSocket event loop for other clients. Botnana Control
continues to provide at most two live rtForth user sessions.

The built-in HMI **Support diagnostics** view, opened from **About**, can request
one payload-free snapshot of both active connections. The registry marks the
requesting browser, reports only connection duration and bounded
traffic/admission counters, and removes a row when that connection closes. It
does not retain traffic history or include peer addresses, request contents,
responses, or configuration values.

A separate same-origin HTTP action requests one fixed operation from the
root-owned local support capability. That capability reads only current and
previous boot records for `bnc-motion` and `bnc-hmi`, emits allowlisted
categorized records and metadata, and returns one in-memory ZIP no larger than
50 MiB. The unprivileged HMI cannot select a journal unit, boot, path, command,
or archive option. Neither this collaboration nor the live comparison is part
of the supported customer JSON API.

## Controller Startup and Readiness

Every controller generation is built from an immutable `ControllerBuildPlan`.
The plan contains the board, cycle period, Motion settings, axes, groups,
timers, EtherCAT slaves, and startup scripts selected for that attempt.

A generation becomes **Ready** only after this bounded sequence succeeds:

1. Scan the complete physical EtherCAT chain without adopting it.
2. Compare the observed vendor and product identity at every expected position.
3. Reserve the EtherCAT master and recheck link, responder count, identity, and
   settled PREOP state on the reserved runtime.
4. Configure required device mailbox operations and PDO mappings before the
   controller capability enters the VM.
5. Activate the master and run the real-time controller.
6. Wait for required startup mailbox work, stable OP state, and complete
   process-data working counters.
7. Publish **Ready**, then bind or rebind live WebSocket sessions to that exact
   generation.

A successful master activation alone is not readiness. If any required step
fails or the operator stops topology retry, the generation remains unavailable
and the server publishes the terminal lifecycle state instead of a false
**Ready** result.

## Restart, Recovery, and Topology Sources

Different operations deliberately select different controller plans:

| Operation | Controller source |
|---|---|
| Initial process startup | Profile loaded from `/etc/botnana-control/motion.toml` and configured startup scripts. |
| Normal **Rescan EtherCAT** | Immutable build plan from the most recently Ready generation (**Last working settings**). It does not apply newly saved profile edits. |
| Failed-state **Start controller** | Exact saved profile revision reviewed by the operator. Unsaved changes prevent this start. |
| **Approve, save, and start** topology change | Exact complete topology proposal and settings saved by the server-owned approval operation. |

For a normal runtime replacement, the supervisor stops accepting work for the
old generation, drains accepted requests, detaches live sessions, shuts down
the old generation, and builds the selected replacement. Healthy sessions are
rebound before **Ready** is announced. If one session cannot be rebound, only
that session is closed; unrelated sessions and the healthy controller remain
available.

Topology approval, durable save, and startup are coordinated on the controller.
The browser is a reviewer and command source, not the owner of a multi-request
save/start transaction.

## Configuration and Runtime State

The HMI displays several related states, but they have different owners and
lifetimes.

| State | Owner and durability | Meaning |
|---|---|---|
| Detected topology | Latest complete observation retained by `RuntimeSupervisor`; not a durable profile | Read-only evidence from a physical scan. Unknown topology is not reported as zero slaves. |
| Shared draft | `MachineProfile` memory with a draft revision | Validated pending edits shared by all HMI work areas. It is not durable until saved. |
| Saved profile | `/etc/botnana-control/motion.toml`, with the server's current saved revision | Durable intended configuration. Saving it does not modify the running controller. |
| Last working settings | Immutable Ready build plan retained by `RuntimeSupervisor` | Source for normal rescan and rollback from an unapproved topology draft. |
| Active controller | Current runtime generation | Values and hardware resources actually selected at successful startup. |
| Update state | Root-owned files under `/var/lib/botnana-control-update/` | Pending package, reports, retained archives, update revision, and motion block. |

Browser progress and cached rows are presentation state, not authority. A
refresh or reconnect replaces them with server-owned profile, topology,
lifecycle, and update state.

## Real-Time Execution

The runtime generation bridges WebSocket requests to the rtForth VM through
bounded generation-owned request and response channels. The VM has five
cooperative real-time tasks:

| Task | Role |
|---|---|
| NC task | Runs background numerical-control scripts and complex motion sequences. |
| User tasks 1 and 2 | Execute requests for the two live WebSocket application sessions. |
| Controller task | Runs the cyclic motion-control engine at the configured `period_us`. |
| SFC task | Runs sequential control logic. |

The motion engine owns axis and group coordination, limits, interpolation,
look-ahead, timers, and process I/O. The hardware-abstraction layer translates
those responsibilities to supported EtherCAT devices through the native
master. Configuration ownership stays outside the cyclic task until a new
controller generation is deliberately built.

## Software-Update Trust Boundary

The browser may provide Debian package bytes, but it never receives root or
package-manager authority. `hmi-server` bounds the HTTP upload and streams it
through a fixed Unix-socket protocol. The privileged update agent independently
checks package identity, architecture, size, metadata, and SHA-256, then binds
confirmation to the update-state revision the operator reviewed.

A confirmed Botnana Control package is revalidated and attempted once during
the next boot. The updater records a motion block before invoking `dpkg`; only a
successful managed installation clears that block. The HMI and motion services
therefore cannot mistake a partial package installation for a safe motion
runtime.

This boundary is not user authentication. Botnana Control 1.14.4 adds no TLS,
application login, or package-signature identity. Anyone who can reach the HMI
on the control network may submit a package for review, so deployment must rely
on a protected, site-controlled network and operating procedure.

## Failure Isolation

| Failure | Architectural effect |
|---|---|
| Controller generation fails | HTTP HMI and process-level WebSocket status/profile operations remain available; live runtime operations are unavailable. |
| `motion-server` service stops | The independent HMI HTTP service can still load, but controller WebSocket data is unavailable. |
| HMI HTTP service stops | It does not itself replace or stop the active controller generation; an already connected customer WebSocket is a separate path. |
| One WebSocket overloads or stops reading | Per-connection admission and output bounds isolate other connections; a saturated connection may be closed. |
| Runtime cleanup cannot be proven | In-process replacement is refused and the HMI requires an authorized `bnc-motion` service restart. |
| Managed package installation may be partial | Durable update state blocks motion while retaining the update/recovery boundary. |

## Customer API Boundary

The released `botnana-apis` libraries define the supported customer-facing
WebSocket API. Bundled-HMI profile revisions, controller recovery, topology
maintenance, connection-traffic diagnostics, and update protocols are internal
product collaborations unless a later public API release explicitly promotes
them. Implemented internal routes
must not be treated as customer API merely because they are visible on the
network.

For operational procedures, see [EtherCAT Controller Recovery](./ethercat-controller-recovery.md),
[Review and Configure the EtherCAT Topology](./ethercat-topology-maintenance.md),
and [Software Updates](./update-software.md). For the supported customer
integration boundary, see [JSON API](./json-api.md).
