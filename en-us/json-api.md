# JSON API

Botnana Control's JSON API uses [JSON-RPC 2.0](http://www.jsonrpc.org/specification) 。

Programs can use JSON format to communicatw with Botnana Control. 
This method suits languages that supports JSON format and uses Websocket library. e.g.

* Java
* C#
* C++
* Python
* Ruby
* Go

The following language supports JSON. But we recommend using APIs provided by Botnana Contorl:

* [Javascript API](./javascript-api.md)


## Data return format/回傳資料格式

The format of data returned by Botnana Control:

    tag1|value1|tag2|value2...

Note: Data return is not in JSON format.

## Version API

Programs can use Version API to obtain the version of Botnana Control.

    {
      "jsonrpc": "2.0",
      "method": "version.get"
    }

will return the following line：

    version|1.0.0

## Configuration API

Programs can use Configuration API to process parameter in configuration file. 
Parameter configuration takes effect after a reboot or 重新讀取參數檔.

### Editing parameter configuration/修改設定參數

Edits done to the configuration file will not immediately take effect, 
and will not affect parameters currently in use by devices.

e.g.: Editing slave 1's homing method

    {
      "jsonrpc": "2.0",
      "method": "config.set_slave",
      "params": {
        "position": 1,
        "tag": "homing_method",
        "value": 33
      }
    }

### Saving parameter configuration/儲存設定參數

Saving parameter configuration will immediately save set value to parameter 
configuration file. But will not affect parameter currently in use.

After restart, the system will use the new configuration.

e.g.: Request saving configuration：

    {
      "jsonrpc": "2.0",
      "method": "config.save"
    }

## Slave API

### Reading Slave status

Use `get` to obtian all parameters. Use `get_diff` to obtain the last modified 
value after using `get`. / 使用 get_diff 取得自行 上次執行 get 後被 改變的狀態。

If parameter has not changed, return value will be a blank string. /回傳資料為空字串。

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

驅動器回傳資料範例，

    vendor.1|Panasonic|product.1|MBDHT|control_word.1|0|status_word.1|1616|
    pds_state.1|Switch On Disabled|pds_goal.1|Switch On Disabled|
    operation_mode.1|home|real_position.1|0|target_position.1|0|
    home_offset.1|0|homing_method.1|33|homing_speed_1.1|1000|
    homing_speed_2.1|250|homing_acceleration.1|500|
    profile_velocity.1|500000|profile_acceleration.1|200|profile_deceleration.1|200

其中的 `.1` 代表資料來自位置為 1 的 slave。

數位輸出回傳資料範例，以台達電 EC7062 為例：

    vendor.3|Delta|product.3|EC7062|dout.3.1|0|dout.3.2|0|dout.3.3|0|
    dout.3.4|0|dout.3.5|0|dout.3.6|0|dout.3.7|0|dout.3.8|0|dout.3.9|0|
    dout.3.10|0|dout.3.11|0|dout.3.12|0|dout.3.13|0|dout.3.14|0|
    dout.3.15|0|dout.3.16|0

其中的 dout.3.11 代表是第三個 Slave 的第 11 個數位輸出。

數位輸入回傳資料範例，以台達電 EC6022 為例：

    vendor.7|Delta|product.7|EC6022|din.7.1|0|din.7.2|0|din.7.3|0|
    din.7.4|0|din.7.5|0|din.7.6|0|din.7.7|0|din.7.8|0|din.7.9|0|
    din.7.10|0|din.7.11|0|din.7.12|0|din.7.13|0|din.7.14|0|din.7.15|0|
    din.7.16|0

其中的 dout.7.15 代表是第七個 Slave 的第 15 個數位輸入。

類比輸出回傳資料範例，以台達電 EC9144 為例：

    vendor.5|Delta|product.5|EC9144|aout.5.1|0|aout.5.2|0|
    aout.5.3|0|aout.5.4|0

類比輸入回傳資料範例，以台達電 EC8124 為例：

    vendor.4|Delta|product.4|EC8124|ain.4.1|0|ain.4.2|0|
    ain.4.3|0|ain.4.4|0

### 設定馬達驅動器參數

和設定檔的 API 不同，此法設定的參數會立即生效。

馬達驅動器部份目前提供以下參數：

* `homing_method`
* `home_offset`
* `homing_speed_1`
* `homing_speed_2`
* `homing_acceleration`
* `profile_velocity`
* `profile_acceleration`
* `profile_deceleration`

使者用可以使用 set 命令設定這些參數。

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.set",
      "params": {
        "position": 1,
        "tag": "homing_method",
        "value": 33
      }
    }

### 清除馬達驅動器異警

範例，清除第一個 Slave 的異警：

    {
      "jsonrpc": "2.0",
      "method": "ethercat.slave.reset_fault",
      "params": {
          "position": 1,
      }
    }

### 設定 IO 點狀態

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
