# JSON API

Botnana Control uses the JSON API. [JSON-RPC 2.0](http://www.jsonrpc.org/specification) .

Applications communicate with Botnana Control using JSON over WebSocket. This API works with any language that provides JSON and WebSocket libraries, including:

* C#
* C++
* Python

## Public API Scope

This chapter is limited to the customer-facing methods exposed by the released
`botnana-apis` client libraries. Botnana Control contains additional methods for
the bundled browser HMI and internal service coordination; their presence in
the server does not make them public API. A method must first be released by
`botnana-apis` before this chapter can document it as a customer integration
contract.

The compatibility baseline for this chapter is the `botnana-apis` tag
`customer-release-2025-02-21`, source-equivalent commit `1946d8d28759`.

## Response Format

Botnana Control returns data in the form of

    tag1|value1|tag2|value2...

Note that the return format is not a JSON format.

## WebSocket Recommendations for Custom HMIs (Version 1.14.3)

Botnana Control 1.14.3 provides two rtForth user sessions for WebSocket
clients. An accepted `script.evaluate` request does not have a general success
or completion response. A custom HMI must not treat a successful WebSocket send
or the absence of an error as proof that the script ran.

Use the following client-side limits to reduce request backlog and make motion
commands easier to verify:

* Keep one persistent WebSocket per HMI application whenever possible. Close it
  cleanly, reconnect with a bounded delay, and avoid unused browser tabs or
  reconnect loops that occupy the two rtForth sessions.
* Route every bootstrap, heartbeat, read, and command through one outbound
  budget. Permit a burst of no more than five requests and a sustained rate of
  no more than 100 requests per second. This is a traffic recommendation, not
  a guaranteed rate for long-running rtForth scripts.
* Give operator and motion commands priority over polling, but do not let them
  bypass the request budget. Replace or discard superseded polling instead of
  sending a catch-up burst after a delay or reconnect.
* Poll only live values needed by the visible screen. Do not request stable
  configuration every 50 ms.
* Keep each read-only polling script within 512 UTF-8 bytes and 32 rtForth
  operations. Keep motion commands and configuration changes separate from
  polling batches.
* Process every server message, especially messages beginning with `error|`.
  `error|Scripts buffer is fulled.`, a timeout, or a disconnect means the HMI
  must reconcile controller state instead of assuming that the command ran.
* Allow only one state-changing script to await verification on a connection.
  Do not automatically retry a motion command after a missing response because
  the original command may already have run.

The selected axis group is shared by the rtForth user tasks. Put `group!` and
all commands that depend on that selection in the same `script.evaluate`
request. When the application needs confirmation, add an output-producing
readback to the same script. For example:

```json
{
  "jsonrpc": "2.0",
  "method": "script.evaluate",
  "params": {
    "script": "1 group! 100.0e mm/min vcmd! 1 .group"
  }
}
```

The response contains the `vcmd.1` field for group 1. This confirms the stored
command value; it does not by itself confirm physical velocity. The `vcmd!`
word intentionally has no effect on a Sine group, whose reported `vcmd` is its
configured sine velocity amplitude.

These limits are conservative recommendations for version 1.14.3. They reduce
exposure to request pressure but cannot repair a stalled connection or provide
exactly-once command execution.

## Version API

Programs can access a version of Botnana Control using the Version API.

    {
      "jsonrpc": "2.0",
      "method": "version.get"
    }

The following string will be returned:

    version|1.0.0

## Configuration API

The released client libraries expose configuration reads, configuration
setters, and `config.save`. Botnana Control 1.14.4-21 and later accepts these
released request shapes without requiring the client to negotiate the bundled
HMI's revision-aware configuration protocol.

Use only one configuration editor at a time. A legacy setter applies to the
current server draft when the request is processed, and parameterless
`config.save` saves the current draft. It cannot detect that another browser or
client changed the draft between requests. Do not edit configuration
concurrently through a customer HMI and the bundled HMI. Revision-aware bundled
HMI operations retain their stale-edit checks.

The parameter file setting is effective after restarting or re-reading the
parameter file.

### Modify Configuration Parameters

Modifying the parameter settings will not immediately save the settings to the parameter configuration file, nor will it affect the parameters currently used by each device.

#### EtherCAT Position and Alias

**EtherCAT Position**According to the EtherCAT network layout, the position closest to the main station is 1.

**EtherCAT Alias**Each EtherCAT slave can set a different name for a station number. There are generally two ways to set this name:

1. EEPROM within the EtherCAT slave,
2. The hard drive of EtherCAT slave.

When setting the parameter, if the alias is not 0, the alias is chosen by slave.


#### Set EtherCAT Slave Parameters: `config.slave.set`

The method:

    "method": "config.slave.set"

Parameters needed:

    "alias": Slave Alias.
    "position": Slave Position.
    "channel"Device Channel, counting from 1.

Each released setter sends exactly one value field. The released fields are:

- `homing_method`, `homing_speed_1`, `homing_speed_2`, and
  `homing_acceleration`;
- `profile_velocity`, `profile_acceleration`, and `profile_deceleration`; and
- `pdo_velocity_offset`, `pdo_torque_offset`, `pdo_digital_inputs`,
  `pdo_demand_position`, `pdo_demand_velocity`, `pdo_demand_torque`,
  `pdo_real_velocity`, and `pdo_real_torque`.

Wire example: set the homing method for channel 1 of the slave at position 1.

```json
{
  "jsonrpc": "2.0",
  "method": "config.slave.set",
  "params": {
    "alias": 0,
    "position": 1,
    "channel": 1,
    "homing_method": 33
  }
}
```


#### Set Motion-Control Parameters: `config.motion.set`

The method:

    "method": "config.motion.set"

Parameters needed:

    None


The released setters expose `period_us`, `group_capacity`, and `axis_capacity`,
one value per request.

Wire example:

```json
{
  "jsonrpc": "2.0",
  "method": "config.motion.set",
  "params": {
    "period_us": 2000
  }
}
```


#### Set Axis-Group Parameters: `config.group.set`

The method:

    "method": "config.group.set"

Parameters needed:

    "position": Specify axis group, counting from 1.

The released setters expose `name`, `gtype` with its required `mapping`,
`vmax`, `amax`, and `jmax`. Except for the paired group type and mapping, each
client helper sends one value per request.

Wire example: configure group 1 as a 2D group mapped to axes 1 and 2.

```json
{
  "jsonrpc": "2.0",
  "method": "config.group.set",
  "params": {
    "position": 1,
    "gtype": "2D",
    "mapping": [1, 2]
  }
}
```

#### Set Motion-Axis Parameters: `config.axis.set`

The method:

    "method": "config.axis.set"

Parameters needed:

    "position": Specify the motion axis, counting from 1.

Each released setter sends exactly one value field. The released fields are:

- `name`, `home_offset`, `encoder_ppu`, `encoder_length_unit`,
  `encoder_direction`, `vmax`, and `amax`;
- `ext_encoder_ppu`, `ext_encoder_direction`, `closed_loop_filter`, and
  `max_position_deviation`;
- `drive_alias`, `drive_slave_position`, and `drive_channel`; and
- `ext_encoder_alias`, `ext_encoder_slave_position`, and
  `ext_encoder_channel`.

Wire example:

```json
{
  "jsonrpc": "2.0",
  "method": "config.axis.set",
  "params": {
    "position": 1,
    "name": "X"
  }
}
```

### Retrieve Configuration Parameters

#### Get EtherCAT Slave Parameters: `config.slave.get`

The method:

    "method": "config.slave.get"

Parameters needed:

    "alias": Slave Alias.
    "position": Slave Position.
    "channel"Device Channel, counting from 1.

Example:

    {
      "jsonrpc": "2.0",
      "method": "config.slave.get",
      "params": {
        "alias": 0,
        "position": 1,
        "channel": 1
      }
    }

    The return package

    config_slave_alias.1|0
    |config_homing_method.1.1|33
    |config_homing_speed_1.1.1|1000
    |config_homing_speed_2.1.1|250
    |config_homing_acceleration.1.1|500
    |config_profile_velocity.1.1|1000000
    |config_profile_acceleration.1.1|50000
    |config_profile_deceleration.1.1|50000
    |config_baud_rate.1.1|6
    |config_data_frame.1.1|3
    |config_half_duplex.1.1|1
    |config_uart_p2p.1.1|0
    |config_tx_optimization.1.1|1


#### Get Motion-Control Parameters: `config.motion.get`

The method:

    "method": "config.motion.get"

Parameters needed:

    None


Example: Get the motion set

    {
      "jsonrpc": "2.0",
      "method": "config.motion.get"
    }

    The return package:

    config_period_us|2000
    |config_group_capacity|7
    |config_axis_capacity|10

#### Get Axis-Group Parameters: `config.group.get`

The method:

    "method": "config.group.get"

Parameters needed:

    "position": Specify axis group, counting from 1.


Example: Get set to Group 1

    {
      "jsonrpc": "2.0",
      "method": "config.group.get",
      "params": {
        "position": 1
      }
    }

    The return package

    config_group_name.1|BotnanaGo
    |config_group_type.1|2D
    |config_group_mapping.1|2,3
    |config_group_vmax.1|0.200
    |config_group_amax.1|5.000
    |config_group_jmax.1|40.000

#### Get Motion-Axis Parameters: `config.axis.get`

The method:

    "method": "config.axis.get"

Parameters needed:

    "position": Specify the motion axis, counting from 1.


Example: Achieving Axis 1

    {
      "jsonrpc": "2.0",
      "method": "config.axis.get",
      "params": {
        "position": 1
      }
    }


    The return package

    config_axis_name.1|Anonymous
    |config_axis_home_offset.1|0.0000
    |config_encoder_ppu.1|1000000.00000
    |config_encoder_length_unit.1|Meter
    |config_encoder_direction.1|1
    |config_slave_position.1|2
    |config_drive_channel.1|2


### Save Configuration Parameters

Storage settings parameter will instantly store the settings value in the parameter configuration file, but will not affect the parameters currently used by each device.

The system will use a new setting once the switch is restarted.

Example: Requires storage configuration:

    {
      "jsonrpc": "2.0",
      "method": "config.save"
    }


## Real-time Scripting API

Botnana Control provides real-time scripts in its real-time event loop to meet the needs of more complex programs.

* Script.evaluate: Interpreting real-time scripts. `script.evaluate` It's a real-time script to compile.
* Script.deploy: Compiled real-time scripts.

Real-time script command set Please see [Real-time scripting API](./real-time-script-api.md)

#### Evaluate a Real-Time Script: `script.evaluate`

The method:

    "method": "script.evaluate"

Parameters needed:

    "script":real-time script .


example: The following RPC calls for the JSON command to set the Drive channel 1 of Slave 1 method back to the original point.

    {
      "jsonrpc": "2.0",
      "method": "script.evaluate",
      "params": {
        "script": "33 1 1 homing-method!"
      }
    }


#### Deploy a Real-Time Script: `script.deploy`

This command transfers the script to the context-executed Task interpretation or compilation to avoid affecting Task and user interactions. It is commonly used to interpret and execute large scripts.


The method:

    "method": "script.deploy"

Parameters needed:

    "script": real-time script .


Example: The following RPC calls for the compilation of a program called p1. When p1 is executed, the Drive channel 1 of Slave 1 returns to the source method.

    {
      "jsonrpc": "2.0",
      "method": "script.deploy",
      "params": {
        "script": ": p1  33 1 1 homing-method! ;"
      }
    }
