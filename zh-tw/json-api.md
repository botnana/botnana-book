# JSON API

Botnana Control 的 JSON API 採用 [JSON-RPC 2.0](http://www.jsonrpc.org/specification) 。

程式可以使用 JSON 格式和 Botnana Control 溝通。此一方法適用於各種支援 JSON 格式且具有 Websocket 函式庫的語言，例如：

* Java
* C#
* C++
* Python
* Ruby
* Go

以下程式語言雖然支援 JSON，但建議使用 Botnana Control 另行提供的 APIs：

* [Javascript API](./javascript-api.md)


## 回傳資料格式

Botnana Control 若回傳資料，格式一律為

    tag1|value1|tag2|value2...

注意回傳格式不是 JSON 格式。

## Version API

程式可以使用 Version API 取得 Botnana Control 的版本。

    {
      "jsonrpc": "2.0",
      "method": "version.get"
    }

會回傳以下字串：

    version|1.0.0

## Configuration API

程式可以使用 Configuration API 來處理參數設定檔。參數檔的設定，在重開機或重新讀取參數檔後生效。

### 修改設定參數

修改設定參數並不會立刻將設定值儲存至參數設定檔，也不會影響到各裝置目前使用的參數。

範例：修改 slave 1 的回歸原點方法。

    {
      "jsonrpc": "2.0",
      "method": "config.set_slave",
      "params": {
        "position": 1,
        "tag": "homing_method",
        "value": 33
      }
    }

範例： 修改  motion 參數。可以同時設定多個參數或是單獨一個參數。 

    {
      "jsonrpc": "2.0",
      "method": "config.motion.set",
      "params": {
        "period_us": 2000,
        "group_capacity": 5,
        "axis_capacity": 5
       }
    }

範例：修改 group 的設定，依據 position 設定對應的 group，可以同時設定多個參數或是單獨一個參數。 

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


    
範例：修改 axis 的設定，依據 position 設定對應的 axis，可以同時設定多個參數或是單獨一個參數，`encoder_length_unit`可以設定為 `Meter`, `Revolution`或是 `Pulse`。 

    {
      "jsonrpc": "2.0",
      "method": "config.axis.set",
      "params": {
        "position": 1,
        "name": "X",
        "home_offset": 0.05,
        "encoder_ppu": 2000000.0,
        "encoder_length_unit": "Meter",
        "encoder_direction": 1
      }
    }
    
### 取得設定參數

範例： 取得 motion 設定

    {
      "jsonrpc": "2.0",
      "method": "config.motion.get",
    }

輸出範例：
  
    config_period_us|2000|config_group_capacity|7|config_axis_capacity|10
  

範例： 取得 Group 1 設定

    {
      "jsonrpc": "2.0",
      "method": "config.group.get",
      "params": {
        "position": 1,
      }
    }

輸出範例：
    
    config_group_name.1|BotnanaGo|config_group_type.1|2D|config_group_mapping.1|2,3|config_group_vmax.1|0.200|config_group_amax.1|5.000|config_group_jmax.1|40.000

範例： 取得 Axis 1

    {
      "jsonrpc": "2.0",
      "method": "config.axis.get",
      "params": {
        "position": 1,
      }
    }


輸出範例：

    config_axis_name.1|X|config_axis_home_offset.1|0.0500|config_encoder_ppu.1|120000.00000|config_encoder_length_unit.1|Meter|config_encoder_direction.1|-1


### 儲存設定參數

儲存設定參數會立刻將設定值儲存至參數設定檔，但不會影響到各裝置目前使用的參數。

關機再開後系統會使用新的設定。

範例：要求儲存 configuration：

    {
      "jsonrpc": "2.0",
      "method": "config.save"
    }

## Slave API

### 讀取 Slave 狀態

使用者可以使用 get 取得所有參數。使用 get_diff 取得自上次執行 get 後被改變的狀態。
如果上次執行 get 後狀態都沒有改變，回傳資料為空字串。

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

    vendor.3|Delta|product.3|EC7062|dout.1.3|0|dout.2.3|0|dout.3.3|0|
    dout.4.3|0|dout.5.3|0|dout.6.3|0|dout.7.3|0|dout.8.3|0|dout.9.3|0|
    dout.10.3|0|dout.11.3|0|dout.12.3|0|dout.13.3|0|dout.14.3|0|
    dout.15.3|0|dout.16.3|0

其中的 dout.11.3 代表是第三個 Slave 的第 11 個數位輸出。

數位輸入回傳資料範例，以台達電 EC6022 為例：

    vendor.7|Delta|product.7|EC6022|din.1.7|0|din.2.7|0|din.3.7|0|
    din.4.7|0|din.5.7|0|din.6.7|0|din.7.7|0|din.8.7|0|din.9.7|0|
    din.10.7|0|din.11.7|0|din.12.7|0|din.13.7|0|din.14.7|0|din.15.7|0|
    din.16.7|0

其中的 din.15.7 代表是第七個 Slave 的第 15 個數位輸入。

類比輸出回傳資料範例，以台達電 EC9144 為例：

    vendor.5|Delta|product.5|EC9144|aout.1.5|0|aout.2.5|0|
    aout.3.5|0|aout.4.5|0

類比輸入回傳資料範例，以台達電 EC8124 為例：

    vendor.4|Delta|product.4|EC8124|ain.1.4|0|ain.2.4|0|
    ain.3.4|0|ain.4.4|0

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

## Real-time Scripting API

Botnana Control 在其 real-time event loop 提供 Real-time script 來滿足更複雜的程式需求。為此提供兩個 JSON-RPC：

* motion.evaluate: 解譯 real-time script。注意不可以使用 `motion.evaluate` 來編譯 real-time script。
* script.deploy: 編譯 real-time script。

TODO: 未來將改名為

* script.evaluate
* script.deploy

Real-time script 的指令集請見 [Real-time scripting API](./real-time-script-api.md)

範例：以下 RPC 呼叫設定 Slave 1 回歸原點方法的 JSON 命令。

    {
      "jsonrpc": "2.0",
      "method": "motion.evaluate",
      "params": {
        "script": "33 1 homing-method!"
      }
    }

範例：以下 RPC 呼叫編譯了一名為 p1 的程式。當 p1 執行時會設定 Slave 1 回歸原點方法。

    {
      "jsonrpc": "2.0",
      "method": "script.deploy",
      "params": {
        "script": ": p1  33 1 homing-method! ;"
      }
    }
