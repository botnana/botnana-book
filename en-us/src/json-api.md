# JSON API

Botnana Control uses the JSON API. [JSON-RPC 2.0](http://www.jsonrpc.org/specification) .

Applications communicate with Botnana Control using JSON over WebSocket. This API works with any language that provides JSON and WebSocket libraries, including:

* C#
* C++
* Python

## Response Format

Botnana Control returns data in the form of

    tag1|value1|tag2|value2...

Note that the return format is not a JSON format.

## Version API

Programs can access a version of Botnana Control using the Version API.

    {
      "jsonrpc": "2.0",
      "method": "version.get"
    }

The following string will be returned:

    version|1.0.0

## Configuration API

The program can use the Configuration API to process the parameter configuration file. The parameter file setting is effective after restarting or re-reading the parameter file.

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

Can set parameters: Can set one or more parameters separately

    "homing_method" Homing method, reference to the description of drive 0x6098:0x00.
    "homing_speed_1" Speed during search for switch, reference to drive 0x6099:0x01 description.
    "homing_speed_2" Speed during search for zero. See description of the optional drive 0x6099:0x02.
    "homing_acceleration"Homing acceleration: See description of the optional drive 0x609A:0x00.
    "profile_velocity"Profile velocity: See description of the selected drive 0x6081:0x00.
    "profile_acceleration"Profile acceleration: See description of the selected drive 0x6083:0x00.
    "profile_deceleration"Profile deceleration: See description of the selected drive 0x6084:0x00.
    "baud_rate"UART baud rate: see Beckhoff EL600x or EL602X 0x8000:0x11 description.
    "data_frame": UART data frame. See Beckhoff's EL600x or EL602X 0x8000:0x15 description.
    "half_duplex"Uart Half Duplex Transmission: See also Beckhoff EL600x or EL602X 0x8000:0x06 description.
    "uart_p2p": UART point to point. See Beckhoff's description of EL600x or EL602X 0x8000:0x07.
    "tx_optimization"UART Tx optimization: see Beckhoff EL600x or EL602X 0x8000:0x07 description.


Example 1: Modify the return point method of the slave 1 channel 1 drive.

    {
      "jsonrpc": "2.0",
      "method": "config.slave.set",
      "params": {
        "alias": 0,
        "position": 1,
        "channel": 1,
        "homing_method" : 33,
      }
    }

Example 2: Modify the velocity and acceleration of the return point of the slave 2 channel 3 drive.

    {
      "jsonrpc": "2.0",
      "method": "config.slave.set",
      "params": {
        "alias": 0,
        "position": 2,
        "channel": 3,
        "homing_speed_1" : 10000,
        "homing_speed_2" : 100,
        "homing_acceleration": 5000,
      }
    }


#### Set Motion-Control Parameters: `config.motion.set`

The method:

    "method": "config.motion.set"

Parameters needed:

    None


Parameters can be set: one or more parameters can be set separately

    "period_us"The execution cycle: [us]
    "group_capacity"Axis group number
    "axis_capacity"Number of axes:

Example:

    {
      "jsonrpc": "2.0",
      "method": "config.motion.set",
      "params": {
        "period_us": 2000,
        "group_capacity": 5,
        "axis_capacity": 5
       }
    }


#### Set Axis-Group Parameters: `config.group.set`

The method:

    "method": "config.group.set"

Parameters needed:

    "position": Specify axis group, counting from 1.

Parameters can be set: one or more parameters can be set separately

    "name": axis group name
    "gtype"The axis group format can be set to: "1D","2D","3D","SINE"
    "mapping": Specify the corresponding motion axes, for example [1, 2] or [2, 1, 3]
    "vmax"Maximum speed: [m/s],[rad/s],[pulse/s]
    "amax"Maximum acceleration: [m/s^2],[rad/s^2],[pulse/s^2]
    "jmax"Maximum acceleration: [m/s^3],[rad/s^3],[pulse/s^3]

Example: Set the parameter for Group 1.

    {
      "jsonrpc": "2.0",
      "method": "config.group.set",
      "params": {
        "position": 1,
        "name": "BotnanaGo",
        "gtype": "2D",
        "mapping": [1, 2],
        "vmax": 0.5,
        "amax": 5.0,
        "jmax": 80.0,
      }
    }

#### Set Motion-Axis Parameters: `config.axis.set`

The method:

    "method": "config.axis.set"

Parameters needed:

    "position": Specify the motion axis, counting from 1.

Parameters can be set: one or more parameters can be set separately

    "name"The name of the movement axis:
    "home_offset": Home offset,
    "encoder_ppu": encoder pulses per unit [pulses]
    "encoder_length_unit": encoder length unit [m],[rev],[pulse]
    "encoder_direction": encode direction, 1 or -1
    "vmax"Maximum speed: [m/s],[rad/s],[pulse/s]
    "amax"Maximum acceleration: [m/s^2],[rad/s^2],[pulse/s^2]
    "slave_position"EtherCAT slave position of the corresponding drive
    "drive_channel"The first Channel on the corresponding drive. Generally set to 1, if it is a multi-axis drive of the Eastern motor AZ series, it is likely to be 2 to 3.

Example:

    {
      "jsonrpc": "2.0",
      "method": "config.axis.set",
      "params": {
        "position": 1,
        "name": "X",
        "home_offset": 0.05,
        "encoder_ppu": 2000000.0,
        "encoder_length_unit":"Meter",
        "encoder_direction": 1,
      }
    }

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
        "channel": 1,
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
      "method": "config.motion.get",
    }

    The return package:

    config_period_us|2000
    |config_group_capacity|7
    |config_axis_capacity|10

#### Get Axis-Group Parameters: `config.group.get`

The method:

    "method": "config.motion.get"

Parameters needed:

    "position": Specify axis group, counting from 1.


Example: Get set to Group 1

    {
      "jsonrpc": "2.0",
      "method": "config.group.get",
      "params": {
        "position": 1,
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
        "position": 1,
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


### Get the Pitch-Correction Table

The method:

    "method": "corrector.pitch.get"

Parameters needed:

    "name"The file name format is PXXXX-YY.sdx, where XXXX represents the position of the EtherCAT Slave Position (16 inches), and YY represents the first few drives (16 inches) on the EtherCAT Slave.


example: get the EtherCAT Slave Position 1 Drive Channel 1 replacement chart

    {
      "jsonrpc": "2.0",
      "method": "corrector.pitch.get",
      "params": {
        "name": "P0001-01.sdx",
      }
    }

### Set the Pitch-Correction Table

The method:

    "method": "corrector.pitch.set"

Parameters needed:

    "name"The file name format is PXXXX-YY.sdx, where XXXX represents the position of the EtherCAT Slave Position (16 inches), and YY represents the first few drives (16 inches) on the EtherCAT Slave.
    "script"Additional content:

Example: Get:

    {
      "jsonrpc": "2.0",
      "method": "corrector.pitch.set",
      "params": {
        "name": "P0001-01.sdx",
        "script": "The content example is as follows"
      }
    }


    For example:

    {
        "description": "example",
        "date": "date",
        "name": "P0001-01.sdx",
        "factor": 0.001,
        "entries": [
            {
                "position": 0.0,
                "forward": 0.0,
                "backward": 0.0
            },
            {
                "position": 10.0,
                "forward": 10.0,
                "backward": 10.0
            },
       ]
    }

    The axis motion command of Botnana-Control is axis command = drive._command + home offset,
             Use the drive when checking tables_command (avoid being affected by home offset adjustments)
    The forward represents the actual position in the direction of motion.
    Backward represents the actual position when moving in a negative direction.
    The factor indicates the unit coefficient of position, forward, backward conversion to Botnana-Control.
             In general, the units of Botnana-Control may be: [m], [rad], [pulse]


## Subscription API

### Subscription

```
{
    "jsonrpc": "2.0",
    "method": "ec_slave.subscribe",
    "params": {
        "alias": 0,
        "position": 1,
    }
}
```

### Unsubscription

```
{
    "jsonrpc": "2.0",
    "method": "ec_slave.subscribe",
    "params": {
        "alias": 0,
        "position": 1,
    }
}
```

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
