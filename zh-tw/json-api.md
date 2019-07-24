# JSON API

Botnana Control 的 JSON API 採用 [JSON-RPC 2.0](http://www.jsonrpc.org/specification) 。

程式可以使用 JSON 格式和 Botnana Control 溝通。此一方法適用於各種支援 JSON 格式且具有 Websocket 函式庫的語言，例如：

* Java
* C#
* C++
* Python
* Ruby
* Go

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

#### EtherCAT Position 與 Alias 說明：

**EtherCAT Position**: 依據 EtherCAT 網路佈局，最靠近主站的 Position 為 1, 依序遞增。

**EtherCAT Alias**: 每一個 EtherCAT 從站都可以設定一個站號的別名。一般設定此別名的方法有兩種：

1. EtherCAT 從站內的 EEPROM，
2. EtherCAT 從站的硬體旋鈕。

在設定參數時,如果 alias 不為 0，就會以 alias 選擇從站。當 alias 為 0，就以 position 選擇從站。


#### 設定 EtherCAT Slave 參數 `config.slave.set`

方法：

    "method": "config.slave.set" 

必要參數：
    
    "alias": Slave Alis。
    "position": Slave Position。
    "channel": Device Channel，從 1 開始計數。

可設定參數：可以單獨設定一個或是多個
       
    "homing_method" : Homing method ,參考驅動器 0x6098:0x00 的描述。
    "homing_speed_1" : Speed during search for switch ,參考驅動器 0x6099:0x01 的描述。
    "homing_speed_2" : Speed during search for zero。參照選用驅動器 0x6099:0x02 的描述。
    "homing_acceleration": Homing acceleration。參照選用驅動器 0x609A:0x00 的描述。
    "profile_velocity": Profile velocity。參照選用驅動器 0x6081:0x00 的描述。
    "profile_acceleration": Profile acceleration。參照選用驅動器 0x6083:0x00 的描述。
    "profile_deceleration": Profile deceleration。參照選用驅動器 0x6084:0x00 的描述。
    "baud_rate": UART baud rate。參照 Beckhoff EL600x 或是 EL602X 0x8000:0x11 的描述。
    "data_frame": UART data frame。參照 Beckhoff EL600x 或是 EL602X 0x8000:0x15 的描述。
    "half_duplex": Uart Half Duplex Transmission。參照 Beckhoff EL600x 或是 EL602X 0x8000:0x06 的描述。
    "uart_p2p":  UART point to point。參照 Beckhoff EL600x 或是 EL602X 0x8000:0x07 的描述。
    "tx_optimization": UART Tx optimization。參照 Beckhoff EL600x 或是 EL602X 0x8000:0x07 的描述。
    

範例 1：修改 slave 1 channel 1 驅動器的回歸原點方法。

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
    
範例 2：修改 slave 2 channel 3 驅動器的回歸原點的速度與加速度。

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


#### 設定運動控制參數 `config.motion.set`

方法：

    "method": "config.motion.set" 
    
必要參數：
    
    None
    
    
可設定參數：可以單獨設定一個或是多個    
    
    "period_us": 執行周期 [us]
    "group_capacity": 軸組數
    "axis_capacity": 軸數
   
範例： 

    {
      "jsonrpc": "2.0",
      "method": "config.motion.set",
      "params": {
        "period_us": 2000,
        "group_capacity": 5,
        "axis_capacity": 5
       }
    }


#### 設定軸組參數 `config.group.set`

方法：

    "method": "config.group.set" 

必要參數：
    
    "position": 指定軸組，從 1 開始計數。
    
可設定參數：可以單獨設定一個或是多個    
    
    "name": 軸組名稱
    "gtype": 軸組型態，可以設定 "1D","2D","3D","SINE"
    "mapping": 指定對應的運動軸，例如 [1, 2] 或是 [2, 1, 3]
    "vmax": 最大速度 [m/s],[rad/s],[pulse/s]
    "amax": 最大加速度 [m/s^2],[rad/s^2],[pulse/s^2]
    "jmax": 最大加加速度 [m/s^3],[rad/s^3],[pulse/s^3]    

範例： 設定 Group 1 的參數 

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

#### 設定運動軸參數 `config.axis.set`

方法：

    "method": "config.axis.set" 

必要參數：
    
    "position": 指定運動軸，從 1 開始計數。
    
可設定參數：可以單獨設定一個或是多個    
    
    "name": 運動軸名稱,
    "home_offset": Home offset,
    "encoder_ppu": encoder pulses per unit [pulses]
    "encoder_length_unit": encoder length unit [m],[rev],[pulse]
    "encoder_direction": encode direction, 1 or -1
    "vmax": 最大速度 [m/s],[rad/s],[pulse/s]
    "amax": 最大加速度 [m/s^2],[rad/s^2],[pulse/s^2]
    "slave_position": 對應驅動器的 EtherCAT 從站位置。
    "drive_channel": 對應驅動器上的第幾個 Channel。一般設定為 1,如果是東方馬達AZ系列多軸驅動器，就有可能是 2~3 。
   
範例： 

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
    
### 取得設定參數

#### 取得 EtherCAT slave 參數 `config.slave.get`

方法：

    "method": "config.slave.get" 

必要參數：
    
    "alias": Slave Alias。
    "position": Slave Position。
    "channel": Device Channel，從 1 開始計數。

範例：

    {
      "jsonrpc": "2.0",
      "method": "config.slave.get",
      "params": {
        "alias": 0,
        "position": 1,
        "channel": 1,
      }
    }
    
    回傳封包

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


#### 取得運動參數 `config.motion.get`

方法：

    "method": "config.motion.get" 
    
必要參數：
    
    None


範例： 取得 motion 設定

    {
      "jsonrpc": "2.0",
      "method": "config.motion.get",
    }

    回傳封包:
  
    config_period_us|2000
    |config_group_capacity|7
    |config_axis_capacity|10
  
#### 取得軸組參數 `config.group.get`

方法：

    "method": "config.motion.get" 
    
必要參數：
    
    "position": 指定軸組，從 1 開始計數。


範例： 取得 Group 1 設定

    {
      "jsonrpc": "2.0",
      "method": "config.group.get",
      "params": {
        "position": 1,
      }
    }

    回傳封包
    
    config_group_name.1|BotnanaGo
    |config_group_type.1|2D
    |config_group_mapping.1|2,3
    |config_group_vmax.1|0.200
    |config_group_amax.1|5.000
    |config_group_jmax.1|40.000

#### 取得軸組參數 `config.axis.get`

方法：

    "method": "config.axis.get" 
    
必要參數：
    
    "position": 指定運動軸，從 1 開始計數。


範例： 取得 Axis 1

    {
      "jsonrpc": "2.0",
      "method": "config.axis.get",
      "params": {
        "position": 1,
      }
    }


    回傳封包

    config_axis_name.1|Anonymous
    |config_axis_home_offset.1|0.0000
    |config_encoder_ppu.1|1000000.00000
    |config_encoder_length_unit.1|Meter
    |config_encoder_direction.1|1
    |config_slave_position.1|2
    |config_drive_channel.1|2


### 儲存設定參數

儲存設定參數會立刻將設定值儲存至參數設定檔，但不會影響到各裝置目前使用的參數。

關機再開後系統會使用新的設定。

範例：要求儲存 configuration：

    {
      "jsonrpc": "2.0",
      "method": "config.save"
    }
    
    
### 取得 Pitch 補正表內容

方法：

    "method": "corrector.pitch.get" 
    
必要參數：
    
    "name": 補正表檔案名稱。檔案名稱格式為 PXXXX-YY.sdx，XXXX 表示 EtherCAT Slave Position 的位置（16 進位表示），YY 表示該  EtherCAT Slave 上的第幾個驅動器（16 進位表示）。


範例：取得 EtherCAT Slave Position 1 Drive Channel 1 的補正表

    {
      "jsonrpc": "2.0",
      "method": "corrector.pitch.get",
      "params": {
        "name": "P0001-01.sdx",
      }
    }
    
### 設定 Pitch 補正表內容

方法：

    "method": "corrector.pitch.set" 
    
必要參數：
    
    "name": 補正表檔案名稱。檔案名稱格式為 PXXXX-YY.sdx，XXXX 表示 EtherCAT Slave Position 的位置（16 進位表示），YY 表示該  EtherCAT Slave 上的第幾個驅動器（16 進位表示）。
    "script": 補正表內容

範例：取得：

    {
      "jsonrpc": "2.0",
      "method": "corrector.pitch.set",
      "params": {
        "name": "P0001-01.sdx",
        "script": "內容範例如下"
      }
    }        


    補正表內容範例：
    
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
    
    position 表示命令位置。 Botnana-Control 的軸運動命令是 axis command = drive_command + home offset,
             查表時是使用 drive_command （避免受 home offset 調整影響）。
    forward  表示正向運動時的實際位置。
    backward 表示負向運動時的實際位置。
    factor   表示 position, forward, backward 轉換到 Botnana-Control 的單位係數，
             一般 Botnana-Control 的單位可能會是 [m], [rad], [pulse]



## Real-time Scripting API

Botnana Control 在其 real-time event loop 提供 Real-time script 來滿足更複雜的程式需求。為此提供兩個 JSON-RPC：

* script.evaluate: 解譯 real-time script。注意不可以使用 `script.evaluate` 來編譯 real-time script。
* script.deploy: 編譯 real-time script。

Real-time script 的指令集請見 [Real-time scripting API](./real-time-script-api.md)

#### 解譯 real-time script `script.evaluate`

方法：

    "method": "script.evaluate" 
    
必要參數：
    
    "script":real-time script 。


範例：以下 RPC 呼叫設定 Drive channel 1 of Slave 1 回歸原點方法的 JSON 命令。

    {
      "jsonrpc": "2.0",
      "method": "script.evaluate",
      "params": {
        "script": "33 1 1 homing-method!"
      }
    }


#### 部署 real-time script `script.deploy`

此一命令將 script 轉交至背景執行的 Task 解譯或編譯，避免影響和使用者互動中的 Task。常用於大型 script 的解譯和執行。


方法：

    "method": "script.deploy" 
    
必要參數：
    
    "script": real-time script 。


範例：以下 RPC 呼叫編譯了一名為 p1 的程式。當 p1 執行時會設定 Drive channel 1 of Slave 1 回歸原點方法。

    {
      "jsonrpc": "2.0",
      "method": "script.deploy",
      "params": {
        "script": ": p1  33 1 1 homing-method! ;"
      }
    }
