## Configuration File

Botnana Control stores its durable machine profile in
`/etc/botnana-control/motion.toml`. The file uses the
[TOML](https://toml.io/) format.

Prefer the built-in HMI for supported profile changes. HMI edits are
revision-aware and are saved as one shared profile. Do not edit the file while
an HMI draft or topology-maintenance operation is active. Before an authorized
manual edit, stop the controller under the site's service procedure and back up
the complete file. A syntactically valid but incorrect profile can prevent the
controller from starting or can configure unintended motion.

Saving a profile does not alter the running controller. The **Active
controller** values remain those selected at its successful start until a later
controlled start selects the saved profile. A normal **Rescan EtherCAT** uses
the last-working settings rather than newly saved values.

### File and Server Sections

| TOML field | Meaning | Default |
|---|---|---|
| `[file].spec_version` | Machine-profile format version. | `"0.0.1"` |
| `[server].address` | Motion-server listen address. This is not the controller network-interface setting. | `"0.0.0.0:3012"` |

Use the HMI **About** procedure, not `[server].address`, to change the
controller's network address.

### Motion Section

The `[motion]` section owns controller-wide motion and EtherCAT-startup values.

| TOML field | Default and constraint | Effect |
|---|---|---|
| `period_us` | `2000`; integer greater than or equal to `1000` microseconds. | Real-time motion cycle. A shorter cycle requires a higher processing rate. |
| `axis_capacity` | `10`; integer from `1` through `24`. | Number of available axis profiles and upper bound for group mapping. |
| `group_capacity` | `2`; positive integer. | Number of available axis-group profiles. |
| `boot_retry_window_ms` | `120000`; non-negative integer in milliseconds. | EtherCAT-master acquisition retry window; not the complete readiness timeout. |

`boot_retry_window_ms` is not the complete controller-readiness timeout. After
an acceptable EtherCAT candidate is acquired, configuration, activation, and
readiness checks retain a later existing deadline or receive a fresh minimum
30-second readiness window.

### EtherCAT Slave and Device Sections

Each saved EtherCAT slave is represented by `[[slaves]]`.

| TOML field | Meaning |
|---|---|
| `protocol` | Slave protocol; EtherCAT slaves use `"EtherCAT"`. |
| `alias` | Configured EtherCAT alias. |
| `position` | One-based physical slave position. |
| `vendor_id` | Expected EtherCAT vendor identifier, stored as a decimal integer. |
| `product_code` | Expected EtherCAT product code, stored as a decimal integer. |
| `wd_proc_data_enabled` | Enables the slave process-data watchdog when `true`. |
| `devices` | Product-specific channel and device configuration. In TOML, populated entries are written as `[[slaves.devices]]`. |

Vendor ID and product code are permanently read-only in the built-in **Slave
Configuration** editor. Review a physical identity, order, or alias change
through the guided topology-maintenance workflow instead of editing those
values as ordinary profile settings.

Device fields depend on the detected product and may include homing method,
home offset, homing speeds, acceleration, profile limits, I/O selection,
encoder settings, or product-specific process-data configuration. Use only the
fields exposed for that device by **Slave Configuration** or the applicable
product commissioning instructions. Do not copy another product's device
block.

### Group Sections

Each `[[group]]` entry defines one coordinated axis group.

| TOML field | Meaning | New-group default or constraint |
|---|---|---|
| `position` | One-based group number. | Must be within `group_capacity`. |
| `name` | Operator-facing group name. | `"Anonymous"` |
| `gtype` | Group geometry. | `"1D"`; accepted values are `"1D"`, `"2D"`, `"3D"`, and `"SINE"`. |
| `mapping` | One-based axis numbers used by the group. | `[1]`; one axis for `1D` or `SINE`, two for `2D`, and three for `3D`. Every number must be within `axis_capacity`. |
| `vmax` | Maximum group velocity in the configured engineering units. | `0.1`; must be positive. |
| `amax` | Maximum group acceleration in the configured engineering units. | `5.0`; must be positive. |
| `jmax` | Maximum group jerk in the configured engineering units. | `80.0`; must be positive. |
| `ignorable_distance` | Remaining distance that may be treated as complete. | `0.0000005`; must be positive. |

### Axis Sections

Each `[[axis]]` entry defines one axis. **Axis Group** presents these fields in
functional groups.

| TOML fields | Meaning and constraints | New-axis defaults |
|---|---|---|
| `position`, `name`, `home_offset` | One-based axis number, operator-facing name, and home offset. Position must be within `axis_capacity`. | Name `"Anonymous"`; offset `0.0`. |
| `encoder_length_unit` | Axis engineering unit. Accepted forms represent meter, revolution, pulse, or user-defined units. | `"Meter"` |
| `encoder_ppu`, `encoder_direction` | Primary encoder pulses per unit and direction. Pulses per unit must be positive; direction is `1` or `-1`. | `1000000.0`, `1` |
| `ext_encoder_ppu`, `ext_encoder_direction` | Optional external-encoder scale and direction, with the same constraints. | `1000000.0`, `1` |
| `closed_loop_filter`, `max_position_deviation` | Fully closed-loop filter frequency in hertz and allowed position deviation. Both are non-negative. | `30.0`, `0.001` |
| `vmax`, `amax`, `ignorable_distance` | Axis velocity limit, acceleration limit, and completion tolerance in configured engineering units. Each must be positive. | `0.1`, `5.0`, `0.0000005` |
| `vff`, `vfactor`, `aff`, `afactor` | Velocity and acceleration feed-forward values and factors. | `0.0`, `1.0`, `0.0`, `1.0` |
| `drive_alias`, `drive_slave_position`, `drive_channel` | EtherCAT assignment for the axis drive. | Alias `0`, slave position equal to the new axis number, channel `1`. |
| `ext_encoder_alias`, `ext_encoder_slave_position`, `ext_encoder_channel` | EtherCAT assignment for an optional external encoder. | `0`, `0`, `0` |

Drive and encoder assignments refer to the saved topology but do not change a
slave's vendor ID or product code. Verify assignment, direction, scaling, and
limits with motion disabled after any controlled controller start.

### Timer Sections

A `[[timer]]` entry contains a one-based `position` and a `name`. Timer settings
are not shown in the 1.14.4 profile work areas; change them only when required
by the applicable integration instructions.

### Minimal Syntax Example

The following example shows file, server, and Motion syntax only. It is not a
complete machine profile and must not replace a commissioned controller file.

```toml
[file]
spec_version = "0.0.1"

[server]
address = "0.0.0.0:3012"

[motion]
period_us = 2000
axis_capacity = 10
group_capacity = 2
boot_retry_window_ms = 120000
```

Use **Slave Configuration**, **Motion**, and **Axis Group** to review supported
settings and their shared pending-change list before saving.
