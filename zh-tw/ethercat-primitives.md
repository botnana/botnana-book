### EtherCAT primitives

#### `.slave ( n -- )` Print information of slave n
    
命令範例:

    2 .slave

以第 2 個 slave 為士林電機 SDP 驅動器為例，
    
回傳訊息：

    vendor.2|0x000005BC
    |product.2|0x00000001
    |description.2|SDP-E CoE Drive
    |alias.2|0
    |device_type.2|0x00020192
    |profile_deceleration.1.2|50000
    |profile_acceleration.1.2|50000
    |profile_velocity.1.2|1000000
    |operation_mode.1.2|6
    |home_offset.1.2|0
    |homing_method.1.2|33
    |homing_speed_1.1.2|1000
    |homing_speed_2.1.2|250
    |homing_acceleration.1.2|500
    |supported_drive_mode.1.2|0x000003ED
    |control_word.1.2|0x0000
    |target_position.1.2|2641624
    |target_velocity.1.2|0
    |status_word.1.2|0x0050
    |real_position.1.2|2641624
    |digital_inputs.1.2|0x00000000
    |pds_state.1.2|Switch On Disabled
    |pds_goal.1.2|Switch On Disabled
    
 其中的
    
    vendor.2 表示第 2 個 slave 的 vendor id
    product.2 表示第 2 個 slave 的 product code
    description.2 表示第 2 個 slave 的 description
    device_type.2 表示第 2 個 slave 的 device type, 其值為 0x00020192
    profile_deceleration.1.2 表示第 2 個 slave 上第 1 個 drive 的 profile deceleration [pulse/s^2], 
    profile_acceleration.1.2 表示第 2 個 slave 上第 1 個 drive 的 profile acceleration [pulse/s^2],
    profile_velocity.1.2 表示第 2 個 slave 上第 1 個 drive 的 profile velocity [pulse/s],
    operation_mode.1.2 表示第 2 個 slave 上第 1 個 drive 的 operation mode, 目前有支援的模式如下：
        1: profile position mode
        3: profile velocity mode
        6: homing mode
        8: cycle sync. position mode
    homing_method.1.2 表示第 2 個 slave 上第 1 個 drive 的 homing method, 常用的模式有：
        1 : homing on negative limit and index pulse
        2 : homing on positive limit and index pulse
        3, 4 : homing on positive home switch and index pulse
        5, 6 : homing on negative home switch and index pulse
        33: homing on negative index pulse
        34: homing on positive index pulse
        35: homing on the current position
        其他: 參考驅動器 0x6098::0x00 的說明
    homing_speed_1.1.2 表示第 2 個 slave 上第 1 個 drive 的 speed for search switch [pulse/s]        
    homing_speed_2.1.2 表示第 2 個 slave 上第 1 個 drive 的 speed for search zero [pulse/s]
    homing_acceleration 表示第 2 個 slave 上第 1 個 drive 的 homing acceleration [pulse/s^2]    
    supported_drive_mode.1.2 表示第 2 個 slave 上第 1 個 drive 的 supported drive mode, 定義如下：
        Bit 0 : profile posiiton mode
        Bit 2 : profile velocity mode
        Bit 5 : homing  mode
        Bit 7 : cycle sync. position mode
        其他: 參考驅動器 0x6502::0x00 的說明    
    control_word.1.2 表示第 2 個 slave 上第 1 個 drive 的 control word, 定義如下：
        Bit 0 : switch on
        Bit 1 : enable voltage
        Bit 2 : quick stop
        Bit 3 : enable operation
        Bit 4~6 : operation mode specification
        Bit 7 : fault Reset
        Bit 8 : halt
        其他: 參考驅動器 0x6040::0x00 的說明       
    target_position.1.2 表示第 2 個 slave 上第 1 個 drive 的 target position [pulse]
    target_velocity.1.2 表示第 2 個 slave 上第 1 個 drive 的 target velocity [pulse/s]
    status_word.1.2  表示第 2 個 slave 上第 1 個 drive 的 status word, 定義如下：
        Bit 0 : ready to switch on
        Bit 1 : switch on
        Bit 2 : operation enabled (servo on)
        Bit 3 : fault
        Bit 4 : voltage enabled
        Bit 5 : quick stop
        Bit 6 : switch on disabled
        Bit 7 : warning
        Bit 10 : target reached
        其他: 參考驅動器 0x6041::0x00 的說明      
    real_position.1.2  表示第 2 個 slave 上第 1 個 drive 的 real position [pulse]
    digital_inputs.1.2 表示第 2 個 slave 上第 1 個 drive 的 digital inputs, 定義如下：
        Bit 0 : negative limit
        Bit 1 : positive limit
        Bit 2 : home switch
        其他: 參考驅動器 0x60FD::0x00 的說明 
    
    Note: 單位會因驅動器而有不同    
   
數位輸出回傳資料範例，以台達電 EC7062 為例：

    vendor.3|Delta|product.3|EC7062|dout.1.3|0|dout.2.3|0|dout.3.3|0|
    dout.4.3|0|dout.5.3|0|dout.6.3|0|dout.7.3|0|dout.8.3|0|dout.9.3|0|
    dout.10.3|0|dout.11.3|0|dout.12.3|0|dout.13.3|0|dout.14.3|0|
    dout.15.3|0|dout.16.3|0

    其中的 dout.11.3 代表是第 3 個 Slave 的第 11 個數位輸出。

數位輸入回傳資料範例，以台達電 EC6022 為例：

    vendor.7|Delta|product.7|EC6022|din.1.7|0|din.2.7|0|din.3.7|0|
    din.4.7|0|din.5.7|0|din.6.7|0|din.7.7|0|din.8.7|0|din.9.7|0|
    din.10.7|0|din.11.7|0|din.12.7|0|din.13.7|0|din.14.7|0|din.15.7|0|
    din.16.7|0

    其中的 din.15.7 代表是第 7 個 Slave 的第 15 個數位輸入。

類比輸出回傳資料範例，以台達電 EC9144 為例：

    vendor.5|Delta|product.5|EC9144|aout.1.5|0|aout.2.5|0|
    aout.3.5|0|aout.4.5|0

類比輸入回傳資料範例，以台達電 EC8124 為例：

    vendor.4|Delta|product.4|EC8124|ain.1.4|0|ain.2.4|0|
    ain.3.4|0|ain.4.4|0

#### `.slave-diff ( n -- )`

Print information difference of slave n
    
使用者可以使用 `.slave` 取得所有參數。使用 `.slave-diff` 取得自上次執行 `.slave`
或是 `.slave-diff` 後被改變的狀態。 如果上次執行 `.slave` 或 `.slave-diff` 後狀態都沒有改變，
回傳資料為空字串。
    
命令範例: 

    2 .slave-diff
    
#### `list-slaves ( -- )`

List vendor id and  product code of detected slaves. 

測試範例： 第 1 個 slave 為台達電 A2-E驅動器 , 第 2 個 slave 為士林電機驅動器, 

命令範例: 
    
    list-slaves

回傳訊息： 
    
    slaves|477,271601776,1468,1
    
    台達電 A2-E:  vendor_id = 477 (0x1DD)
                 product_code =  271601776 (0x10305070)
    士林電機 SDP: vendor_id = 1468 (0x5BC)
                 product_code =  1 (0x1)          

#### `sdo-upload-i32 ( subindex index n -- )`

Upload data (i32) of index:subidex of slave n by SDO.

命令範例: 使用 SDO 讀取 slave 2 位於 0x6064::0x00 的值。 假設 slave 2 是驅動器, 0 表示 subindex,
$6064 表示 index ($表示 16進位), 0x6064:0x00 的位址是 position actual value 其型態是 integer 32，
可以由此指令讀回 position actual value.
             
             
    0 $6064 2 sdo-upload-i32             

#### `sdo-upload-i16 ( subindex index n -- )`

Upload data (i16) of index:subidex of slave n by SDO.

#### `sdo-upload-i8  ( subindex index n -- )`

Upload data (i8) of index:subidex of slave n by SDO.

#### `sdo-upload-u32 ( subindex index n -- )`

Upload data (u32) of index:subidex of slave n by SDO.

#### `sdo-upload-u16 ( subindex index n -- )`

Upload data (u16) of index:subidex of slave n by SDO.

#### `sdo-upload-u8  ( subindex index n -- )`

Upload data (u8) of index:subidex of slave n by SDO.

#### `sdo-download-i32 ( data subindex index n -- )`

Download data (i32) of index:subidex of slave n by SDO.

命令範例: 使用 SDO 設定 slave 2 位於 0x60FF::0x00 的值為 100, 假設 slave 2 是驅動器, 0 表示 subindex,
$60FF 表示 index ($表示 16進位), 0x60FF:0x00 的位址是 target velocity 其型態是 integer 32，
可以由此指令設定 target velocity            

    100 0 $60FF 2 sdo-download-i32

#### `sdo-download-i16 ( data subindex index n -- )`

Download data (i16) of index:subidex of slave n by SDO.

#### `sdo-download-i8 ( data subindex index n -- )`

Download data (i8) of index:subidex of slave n by SDO.

#### `sdo-download-u32 ( data subindex index n -- )`

Download data (u32) of index:subidex of slave n by SDO.

#### `sdo-download-u16 ( data subindex index n -- )`

Download data (u16) of index:subidex of slave n by SDO.

#### `sdo-download-u8 ( data subindex index n -- )`

Download data (u8) of index:subidex fo slave n by SDO.

#### `sdo-data@ ( n -- data )`

Fetch SDO data of slave n to stack.

命令範例: 將 sdo-upload-i32, sdo-upload-i16, sdo-upload-i8, sdo-upload-u32, sdo-upload-u16,
sdo-upload-u8, sdo-download-i32, sdo-download-i16, sdo-download-i8, sdo-download-u32,
sdo-download-u16,sdo-download-u8 命令所讀取或是設定的值取出放入整數堆疊.

    2 sdo-data@                                                               

#### `sdo-error? ( n -- flag )`

Fetch error flag of SDO data of slave n to stack
    
命令範例:

    2 sdo-error? 

#### `sdo-busy? ( n -- flag )`

Fetch busy flag of SDO data of slave n to stack

命令範例 1: 

    2 sdo-busy? 
   
命令範例 2: 讀取 Slave 2 0x6064:0x00 位址的值，等待該命令完成後輸出訊息。

    : test-sdo 0 $6064 2 sdo-upload-i32 
               begin 2 sdo-busy? while pause repeat
               2 .sdo ;
     deploy test-sdo ;deploy
     
     Note: 
     pause: 表示當下的命令暫停, 等待下一個real time cycle 執行時
            再從命令暫停的地方開始執行。
     deploy test-sdo ;deploy : 表示將 test-sdo 指令放到背景執行。
            因為 test-sdo 所定義的命令中有含有等待的指令, 如在當前的 Task 執行，
            就無法再處理後續由 Client 端送進來的指令。                 

#### `.sdo ( n -- )`

Print SDO information of slave n.

命令範例: 輸出第 2 個 slave SDO Request 的結果
        
    2 .sdo
         
回傳訊息：
    
    sdo_index.2|0x6041
    |sdo_subindex.2|0x00
    |sdo_error.2|false
    |sdo_busy.2|false
    |sdo_data.2|24
    |sdo_data_hex.2|0x0018
    
    以 sdo_index.2 為例, .2 表示第 2 個 slave。
    sdo_index   : EtherCAT object index。
    sdo_subindex: EtherCAT object subindex。
    sdo_error   : 此 sdo request 是否有問題,
                  可能原因有 sdo_index 錯誤, 資料型態錯誤 ... 等等。
    sdo_busy    : 此 sdo request 是否還在處理中。
    sdo_data    : 該 位址 （index:subindex）的值。
    sdo_data_hex: 以 16 進位表示該位址的值。

#### `ec-ready? ( -- flag )`

Is EtherCAT Communication ready ?
     
#### `.ec-links ( -- )`

輸出 EtherCAT Communication 的狀態.

回傳訊息範例:

    slaves_responding|2       
    |al_states|8
    |link_up|1
    |input_wc|2
    |output_wc|2
    |input_wc_state|1
    |output_wc_state|1
    |input_wc_error|3547
    |output_wc_error|3568
             
    slaves_responding : EtherCAT slaves 的連線數
    al_states         : 所有的 EtherCAT slaves 的狀態指標，正常為 8
    input_wc          : input working count
    output_wc         : output working count
    input_wc_state    : 正常為 1
    output_wc_state   : 正常為 1
    input_wc_error    : input_wc_state 異常次數, 在開機初始化時會增加，
                        當 EtherCAT master 與 slave 交握成功後就不會再增加。
    output_wc_error   : output_wc_state 異常次數在開機初始化時會增加，
                        當 EtherCAT master 與 slave 交握成功後就不會再增加。
    
#### `waiting-requests? ( -- flag )` 

Is there any waiting sdo request?

#### `until-no-requests ( -- )`

等待所有的 SDO Requests 完成。

相當於
    
    : until-no-requests ( -- )
        ." log|until-no-requests" cr
        begin
            waiting-requests?
        while
            pause
        repeat ;

#### `?ec-emcy ( slave -- )`

當驅動器發生異警時，可以使用此命令讓驅動器將異警訊息（emergency message）傳送回來。

#### `ec-emcy-busy? ( slave -- flag )`

將 `?ec-emcy` 指令的執行狀況放到整數堆疊上 

#### `.ec-emcy ( slave -- )`

回傳 emergemcy message 訊息。目前 Botnana-Control
會依據 status word 中的 fault bit 自動送出 ?ec-emcy 的命令。

回傳訊息範例：

    error_code.1|0x5441
    |error_register.1|0x20
    |error_data.1.1|0
    |error_data.2.1|19
    |error_data.3.1|0
    |error_data.4.1|0
    |error_data.5.1|0
    |error_message_cout|1

    其中 error code 等同於 0x603F:00 
        error register 等同於 0x1001: 00
        error_data.1 ~ error_data.5 為驅動器廠家定義的異警訊息。
        此範例為台達電A2-E 驅動器所回傳的訊息, error_data.2.1 = 19 表示這是
        A2-E 異警碼 0x13 (緊急停止)

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `.slave` |( n -- ) |
| `.slave-diff` |( n -- ) |
| `list-slaves` |( -- )  |
| `sdo-upload-i32` |( subindex index n -- )  |
| `sdo-upload-i16` |( subindex index n -- )         |
| `sdo-upload-i8` |( subindex index n -- )          |
| `sdo-upload-u32` |( subindex index n -- )        |
| `sdo-upload-u16` |( subindex index n -- )        |
| `sdo-upload-u8` | ( subindex index n -- )         | 
| `sdo-download-i32` |( data subindex index n -- )  |
| `sdo-download-i16` |( data subindex index n -- )  |
| `sdo-download-i8` |( data subindex index n -- )   |
| `sdo-download-u32` |( data subindex index n -- )  |
| `sdo-download-u16` |( data subindex index n -- )  |
| `sdo-download-u8` | ( data subindex index n -- )  |
| `sdo-data@` | ( n -- data )        |
| `sdo-error?` | ( n -- flag )       |
| `sdo-busy?` | ( n -- flag )        |
| `.sdo` | ( n --  )                 |
| `ec-ready?` | ( -- flag )          |
| `.ec-links` | ( -- )               |
| `.ec-dc` | ( -- )                  |
| `ec-alias!` | ( alias n -- )      |
| `ec-alias?` | ( alias -- flag )   |
| `ec-a>n`     | ( alias -- n )      |
| `ec-save`     | ( -- )      |
| `ec-load`     | ( -- )      |
| `waiting-requests?` | ( -- flag ) |
| `until-no-requests` | ( -- )      |
| `ec-drive?` | ( channel n -- flag )  |
| `ec-uart?` | ( channel n -- flag )  |
| `ec-din?` | ( channel n -- flag )  |
| `ec-dout?` | ( channel n -- flag )  |
| `ec-ain?` | ( channel n -- flag )  |
| `ec-aout?` | ( channel n -- flag )  |
| `ec-encoder?` | ( channel n -- flag )  |
| `?ec-emcy` |( n -- ) |  
| `ec-emcy-busy?` |( n -- flag ) |
| `.ec-emcy` |( n -- ) |   

