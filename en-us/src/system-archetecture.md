# System Architecture

Botnana Control is a real-time motion control platform designed for industrial automation, semiconductor equipment, and precision machinery. The system features a clean, layered architecture separating the browser-based human-machine interface (Web HMI), the real-time motion engine, and the EtherCAT fieldbus communication layer to deliver maximum reliability, low latency, and ease of maintenance.

## System Architecture at a Glance

```text
+-----------------------+              +-----------------------+
| Operator Browser(HMI) |              | Customer Host App     |
+-----------+-----------+              +-----------+-----------+
            | HTTP :3000                           | WebSocket :3012
            | (Web UI & Updates)                   | (Real-time Motion API)
            v                                      v
+--------------------------------------------------------------+
|                    Botnana Control Controller                |
|                                                              |
|  [HMI Service] (HTTP :3000)                                  |
|    - Static web asset delivery                               |
|    - Debian package inspection and software updates          |
|                                                              |
|  [Motion Control Engine] (WebSocket :3012)                   |
|    - Low-latency JSON-RPC & rtForth script evaluation        |
|    - Multi-axis motion, path interpolation (1D/2D/3D/SINE)   |
|    - Machine configuration management (/etc/.../motion.toml) |
|    - Controller lifecycle supervision & startup diagnostics  |
|                                                              |
|  [EtherCAT Master Engine]                                    |
|    - Cyclic process data exchange (PDO, default 2ms period)  |
|    - Acyclic mailbox communication (SDO parameter access)    |
|    - Distributed Clocks (DC) sync & auto-recovery            |
+-------------------------------+------------------------------+
                                | EtherCAT Fieldbus
                                v
+--------------------------------------------------------------+
|                     EtherCAT Slave Devices                   |
|                                                              |
|  - Servo drives (Delta ASDA-A2/B3, Panasonic A5B/A6B, etc.)  |
|  - Multi-axis drivers (Oriental Motor AZD2B-KED, AZD4A-KED)  |
|  - Pulse drive modules (Syn-Tek / Delta R1-EC5621)           |
|  - Remote I/O modules (Delta / Syn-Tek R1, Beckhoff, etc.)   |
|  - Bus couplers, encoders, and communication gateways        |
+--------------------------------------------------------------+
```

## Network Ports and Communication Interfaces

The controller exposes two dedicated network ports:

1. **HTTP Port `3000` (Web HMI & Software Management)**
   - Used by field engineers and operators via modern web browsers (e.g., Google Chrome) for machine commissioning, live I/O diagnostics, configuration backup/restore, and software updates.
   - Zero installation required on the client device.

2. **WebSocket Port `3012` (Real-Time Motion Control API)**
   - Used by customer host applications (C#, Python, JavaScript, C++, etc.).
   - Employs standard JSON-RPC and real-time script evaluation with optimized low latency (`TCP_NODELAY` enabled, round-trip latency ~0.14 ms) for motion commands and telemetry.
   - Fully compatible with the official `botnana-apis` client library.

## Controller Lifecycle and Operational States

Botnana Control strictly manages operational states to ensure motion commands are executed only when the fieldbus is fully verified:

| Controller State | Description and Behavior |
|---|---|
| **Ready** | EtherCAT fieldbus is operational, all physical slaves have reached Operational (**OP**) state, and cyclic data exchange is active. Motion control and axis operations are permitted. |
| **Starting** | The controller is scanning the bus, verifying slave identities, executing startup SDO configurations, and transitioning slave states. Progress and remaining timeout are displayed. |
| **Unavailable / Fault** | The controller has not started, stopped, or timed out during startup. The system provides **attributable startup diagnostics**: upon timeout, the error explicitly pinpoints the lagging slave position and state (e.g., `slaves not in OP: Slave 8 (PREOP)`), dramatically accelerating field troubleshooting. |

Even when the controller is in the Unavailable state, the Web HMI and configuration management remain accessible, allowing operators to inspect detected hardware, review configurations, or initiate a bus rescan.

## Configuration Persistence and Operational Safety

All machine settings are stored in `/etc/botnana-control/motion.toml` (in TOML format), including:
- Motion cycle time (`period_us`), axis capacities, and group limits.
- EtherCAT slave inventory, product identities, channel assignments, and I/O mappings.
- Axis parameters (velocity, acceleration limits, homing methods, pulse-per-unit ratios).
- Coordinated axis group parameters (geometry type, axis mapping, jerk limits).

### Safety Principles:
1. **Packaging Protection**: Debian package upgrades 100% preserve existing `/etc/botnana-control/motion.toml` files, ensuring machine calibrations are never lost during software updates.
2. **Review & Save Workflow**: HMI configuration edits require review and confirmation. Saved configurations take effect on the next controlled startup, preventing unexpected mid-operation parameter jumps.
3. **Disaster Recovery & Backup**: Operators can export a configuration backup with a single click and restore it even from a disconnected browser session.

## EtherCAT Fieldbus Advantages

1. **Multi-Vendor Drive Support**: Supports standard CiA 402 drives as well as vendor-specific factory modes (such as Oriental Motor AZ series homing method 24).
2. **Automatic DC Clock Recovery**: Features automatic EtherCAT Distributed Clocks (DC) reference clock re-acquisition, maintaining synchronization even after physical bus reconnections.
3. **Live Slave AL State Observability**: The HMI Detected Slaves view shows live Application Layer states (`OP`, `SAFEOP`, `PREOP`, `INIT`) with clear status coloring, giving operators instant visibility into bus health.
