# JSON API

Botnana Control's JSON API uses [JSON-RPC 2.0](http://www.jsonrpc.org/specification) 。

Software can use JSON format to communicate with Botnana Control. 
This method suits languages that supports JSON and Websocket. e.g.

* Java
* C#
* C++
* Python
* Ruby
* Go

The following language supports JSON. But we recommend using APIs provided by Botnana Control:

* [Javascript API](./javascript-api.md)


## Response format

The format of responses returned by Botnana Control:

    tag1|value1|tag2|value2...

Note: responses return is not in JSON format.

## Version API

Software can use Version API to obtain the version of Botnana Control.

    {
      "jsonrpc": "2.0",
      "method": "version.get"
    }

will return the following line：

    version|1.0.0

## Configuration API

Software can use Configuration API to process parameter in configuration file. 
Modification takes effect after a reboot or reload of configuration file.

### Modifying configuration

Changes to the configuration file will not take effect immediately, 
and will not affect parameters currently in use by devices.

e.g. editing slave 1's homing method:

    {
      "jsonrpc": "2.0",
      "method": "config.set_slave",
      "params": {
        "position": 1,
        "tag": "homing_method",
        "value": 33
      }
    }

### Saving configuration

Saving configuration will immediately save set value to
configuration file. But will not affect parameter currently in use.

After restart, the system will use the new configuration.

e.g.: Request saving configuration：

    {
      "jsonrpc": "2.0",
      "method": "config.save"
    }

## Slave API

### Reading Slave Info

Use `get` to obtain all slave info. 
Use `get_diff` to obtain changes after last time `get` or `get_diff` was used.

If parameter has not changed, return value will be a blank string.

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.get",
      "params": {
        "position": 1
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.get_diff",
      "params": {
        "position": 1
      }
    }

Drive response example

    vendor.1|Panasonic|product.1|MBDHT|control_word.1|0|status_word.1|1616|
    pds_state.1|Switch On Disabled|pds_goal.1|Switch On Disabled|
    operation_mode.1|home|real_position.1|0|target_position.1|0|
    home_offset.1|0|homing_method.1|33|homing_speed_1.1|1000|
    homing_speed_2.1|250|homing_acceleration.1|500|
    profile_velocity.1|500000|profile_acceleration.1|200|profile_deceleration.1|200

`.1` means response from slave 1

Digital output response, using Delta EC7062 as an example:

    vendor.3|Delta|product.3|EC7062|dout.3.1|0|dout.3.2|0|dout.3.3|0|
    dout.3.4|0|dout.3.5|0|dout.3.6|0|dout.3.7|0|dout.3.8|0|dout.3.9|0|
    dout.3.10|0|dout.3.11|0|dout.3.12|0|dout.3.13|0|dout.3.14|0|
    dout.3.15|0|dout.3.16|0

`dout.3.11` means the 11th digital output from the third slave.

Digital input response, using Delta EC6022 as an example:

    vendor.7|Delta|product.7|EC6022|din.7.1|0|din.7.2|0|din.7.3|0|
    din.7.4|0|din.7.5|0|din.7.6|0|din.7.7|0|din.7.8|0|din.7.9|0|
    din.7.10|0|din.7.11|0|din.7.12|0|din.7.13|0|din.7.14|0|din.7.15|0|
    din.7.16|0

`dout.7.15` means the 15th digital input from the 7th slave.

Analogue output response, using Delta EC9144 as an example:

    vendor.5|Delta|product.5|EC9144|aout.5.1|0|aout.5.2|0|
    aout.5.3|0|aout.5.4|0

Analogue input response, using Delta EC8124 as an example:

    vendor.4|Delta|product.4|EC8124|ain.4.1|0|ain.4.2|0|
    ain.4.3|0|ain.4.4|0

### Configuring motor drive

As opposed to configuration file API, 
this parameter configuration takes effect immediately.

Drive currently provides the following parameters:

* `homing_method`
* `home_offset`
* `homing_speed_1`
* `homing_speed_2`
* `homing_acceleration`
* `profile_velocity`
* `profile_acceleration`
* `profile_deceleration`

User can use `set` command to alter the parameters.

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.set",
      "params": {
        "position": 1,
        "tag": "homing_method",
        "value": 33
      }
    }

### Clear drive error

e.g. clear the first slave's error:

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.reset_fault",
      "params": {
          "position": 1,
      }
    }

### Modifying IO point settings

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.set_dout",
      "params": {
          "position": 1,
          "channel": 2,
          "value": 1,
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.set_aout",
      "params": {
          "position": 1,
          "channel": 2,
          "value": 20,
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.disable_aout",
      "params": {
          "position": 1,
          "channel": 2,
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.enable_aout",
      "params": {
          "position": 1,
          "channel": 2,
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.disable_ain",
      "params": {
          "position": 1,
          "channel": 2,
      }
    }

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.enable_ain",
      "params": {
          "position": 1,
          "channel": 2,
      }
    }
