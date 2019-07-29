### EtherCAT 指令集

#### `.ec-dc ( -- )`

顯示 EtherCAT 通訊時間同步的狀況。

命令範例:

    .dc-dc
    
回傳訊息:

    dc_adjust_ns|65|dc_diff_ns|-865935|reference_time_diff_ns|2003080
    |application_time_diff_ns|2052185

其中的：

    dc_adjust_ns:               EtherCAT 主站周期的調整量。
    dc_diff_ns:                 EtherCAT 主從站之間的時間相位差。
    reference_time_diff_ns:     EtherCAT 從站的周期。
    application_time_diff_ns:   EtherCAT 主站的周期。

#### `.ec-emcy ( n -- )`

顯示 EtherCAT Slave Position `n` 的emergemcy message 訊息。目前 Botnana-Control 會依據 status word 中的 fault bit 自動送出 ?ec-emcy 的命令。

命令範例:

    1 .ec-emcy  \ 取得 EtherCAT 第 1 個從站的 emergemcy message

回傳訊息:

    error_code.1|0x5441
    |error_register.1|0x20
    |error_data.1.1|0
    |error_data.2.1|19
    |error_data.3.1|0
    |error_data.4.1|0
    |error_data.5.1|0
    |error_message_cout|1

其中的：

    error code:                     等同於 Object 0x603F:00
    error register:                 等同於 Object 0x1001: 00
    error_data.1 ~ error_data.5:    為驅動器廠家定義的異警訊息。
                                    此範例為台達電A2-E 驅動器所回傳的訊息,
                                    error_data.2.1 = 19 表示異警碼 0x13 (緊急停止)

#### `.ec-links ( -- )`

顯示 EtherCAT 通訊的連線狀態

命令範例:

    .ec-links

回傳訊息:

    slaves_responding|3|al_states|8|link_up|1
    |input_wc|3|output_wc|3|input_wc_state|1|output_wc_state|1
    |input_wc_error|8187|output_wc_error|8233
    |waiting_sdos_len|0|ec_ready|1

其中的：

    slaves_responding:  EtherCAT 從站的連線數
    al_states:          所有 EtherCAT 從站的狀態。8 代表所有從站都在操作模式。
    input_wc:           Input Data Working Count。有處理 Input Data 的從站數。
    output_wc:          Output Data Working Count。有處理 Output Data 的從站數。
    input_wc_state:     Input Data Working Count 正常與否，1 表示正常。
    output_wc_state:    Output Data Working Count 正常與否，1 表示正常。
    input_wc_error:     計數 input_wc_state = 0 的周期數。
                        通常在開機時因為時間還不能同步，所以在開機初期會增加。
    output_wc_error:    計數 output_wc_state = 0 的周期數。
                        通常在開機時因為時間還不能同步，所以在開機初期會增加。
    waiting_sdos_len:   等待處理的 SDO 命令數。
    ec_ready:           1 表示 EtherCAT 通訊正常。

#### `.ec-wdt-proc-data ( n -- )`

顯示 EtherCAT Slave Position `n` 的 ESC Watchdog Time Process Data 的暫存器設定值。

命令範例:

    1 .ec-wdt-proc-data

回傳訊息:

    ec_wdt_proc_data.1|1000|ec_wdt_proc_data_busy.1|0|ec_wdt_proc_data_error.1|0

其中的：

    ec_wdt_proc_data:       ESC Watchdog Time Process Data 的暫存器設定值
    ec_wdt_proc_data_busy:  要求設定或是讀取的指令是否還在執行中?
    ec_wdt_proc_data_error: 要求設定或是讀取的指令是否執行失敗?

#### `.sdo ( n -- )`

顯示 EtherCAT Slave Position `n` 的 SDO 指令執行結果。

命令範例:

    2 .sdo

回傳訊息：

    sdo_index.2|0x6041
    |sdo_subindex.2|0x00
    |sdo_error.2|false
    |sdo_busy.2|false
    |sdo_data.2|24
    |sdo_data_hex.2|0x0018

其中的：

    以 sdo_index.2 為例, .2 表示第 2 個 slave。
    sdo_index   : EtherCAT object index。
    sdo_subindex: EtherCAT object subindex。
    sdo_error   : 此 sdo request 是否有問題,
                  可能原因有 index 錯誤, 資料型態錯誤 ... 等等。
    sdo_busy    : 此 SDO request 是否還在處理中。
    sdo_data    : Object 的值。
    sdo_data_hex: 以 16 進位表示 Object 的值。

#### `.slave ( n -- )`

顯示 EtherCAT Slave Position `n` 的資訊。

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

顯示 EtherCAT Slave Position `n` 的資訊。 只回傳與上次要求不同的資訊。

使用者可以使用 `.slave` 取得所有參數。使用 `.slave-diff` 取得自上次執行 `.slave`
或是 `.slave-diff` 後被改變的狀態。 如果上次執行 `.slave` 或 `.slave-diff` 後狀態都沒有改變，
回傳資料為空字串。

命令範例: 

    2 .slave-diff

#### `?ec-emcy ( n -- )`

當驅動器發生異警時，可以使用此命令讓驅動器將異警訊息（emergency message）傳送回來。

#### `@ec-wdt-proc-data ( n -- ) `

從 EtherCAT 從站 `n` 讀回 ESC Watchdog Time Process data 暫存器的值。此命令是要求 EtherCAT 從站將暫存器值傳送回來，不會馬上取得結果。
可以透過 `ec-wdt-proc-data-busy?` 的結果得知是否已經回傳。

#### `ec-a>n ( alias -- n )`

利用 EtherCAT slaves alias `alias` 找到對應的 Slave position `n`

Note:

1. `alias` 不可以為零
2. 假如 `alias` 不存在，則會回傳錯誤訊息

#### `ec-ain? ( ch n -- t )`

EtherCAT slave position `n` Channel `channel` 是否為類比輸入？

#### `ec-alias! ( alias n -- )`

設定 EtherCAT slave position `n` 的 alias 為 `alias`。

Note:

1. `alias` 除了 0 以外，不可重複。
2. 此設定命令是修改 SII EEPROM 對應的暫存器。如果是由硬體旋鈕控制的，就不需要由此命令設定。
3. 不可以有重複的 alias。
4. 此命令會造成 Real Time Cycle Overrun。要在所有驅動器 Servo OFF 情況執行。

#### `ec-alias? ( alias -- t )`

EtherCAT slave alias `alias` 是否存在？ 

#### `ec-aout? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為類比輸出？

#### `ec-din? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為數位輸入？

#### `ec-dout? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為數位輸出？

#### `ec-drive? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為馬達驅動器？

#### `ec-emcy-busy? ( n -- t )`

EtherCAT slave position `n` 的 `?ec-emcy` 是否等待執行中？

#### `ec-encoder? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為編碼器輸入模組？

#### `ec-gateway? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` 是否為閘道器 (Gateway) 模組？

#### `ec-load ( n -- )`

將 EtherCAT slave position `n` 的設定值回復到原廠預設值。相當設定 Object 0x1011:1 為 0x64616F6C (ASCII: l:0x6C, o:0x6F, a:61, d:64)。

如果 EtherCAT slave 有提供回復到原廠預設值功能，大部份會使用此方式。

#### `ec-ready? ( -- t )`

EtherCAT 通訊是否備妥或是正常？

#### `ec-save ( n -- )`

將 EtherCAT slave position `n` 目前的設定值存到 EEPROM。相當設定 Object 0x1010:1 為 0x65766173 (ASCII: s:0x73, a:0x61, v:76, e:65)。

如果 EtherCAT slave 有提供設定參數到 EEPROM 的功能，大部份會使用此方式。

#### `ec-uart?  ( ch n -- t ) `

EtherCAT slave position `n` Channel `ch` 是否為 UART 模組？

#### `ec-wdt-proc-data@  ( n -- interval )`

將 EtherCAT 從站 `n` 的 Watchdog time `interval` 放到整數堆疊上。

#### `ec-wdt-proc-data!  ( interval n -- )`

設定 EtherCAT 從站 `n` 的 Watchdog time 設定為 `interval`。其 `interval` 的時間必須參考從站的 Watchdog 設定。

如果要將 Watchdog 關閉就將 `interval` 設定為 0 。

#### `ec-wdt-proc-data-busy?  ( n -- t )`

是否正在執行 `@ec-wdt-proc-data` 中？

#### `ec-wdt-proc-data-error? ( n -- t )`

執行 `@ec-wdt-proc-data` 的結果是否有錯誤？

#### `list-slaves ( -- )`

顯示所以 EtherCAT 從站的 vendor id 與 product code。

測試範例： 第 1 個從站為台達電 A2-E驅動器 , 第 2 個從站為士林電機驅動器。

回傳訊息：

    slaves|477,271601776,1468,1

    台達電 A2-E:  vendor_id = 477 (0x1DD)
                 product_code =  271601776 (0x10305070)
    士林電機 SDP: vendor_id = 1468 (0x5BC)
                 product_code =  1 (0x1)

#### `sdo-busy? ( n -- t )`

EtherCAT slave  position `n` 的 SDO 命令是否等待執行？

命令範例 1: 

    2 sdo-busy?
   
命令範例 2: 讀取 Slave 2 0x6064:0x00 位址的值，等待該命令完成後輸出訊息。

    : test-sdo 0 $6064 2 sdo-upload-i32 
               begin 2 sdo-busy? while pause repeat
               2 .sdo ;
     deploy test-sdo ;deploy
     
     Note: 
     1. pause: 表示當下的命令暫停, 等待下一個real time cycle 執行時，再從命令暫停的地方開始執行。
     2. deploy test-sdo ;deploy : 將 test-sdo 指令放到背景執行。
            因為 test-sdo 所定義的命令中有含有等待的指令, 如在當前的 Task 執行，
            就無法再處理後續由 client 端送進來的指令。

#### `sdo-data@ ( n -- data )`

取得 EtherCAT slave  position `n` 的 SDO 命令的資料 `data`。

#### `sdo-error? ( n -- t )`

EtherCAT slave  position `n` 的 SDO 命令的執行結果是否有問題？

#### `sdo-download-i16 ( data subindex index n -- )`

將設定值 `data` 以 16 bits 有號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-download-i32 ( data subindex index n -- )`

將設定值 `data` 以 32 bits 有號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

命令範例：

    100 0 $60FF 2 sdo-download-i32 \ 將 `100` 寫到 slave position `2` Object `0x60ff`:`0`

#### `sdo-download-i8 ( data subindex index n -- )`

將設定值 `data` 以 8 bits 有號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-download-u16 ( data subindex index n -- )`

將設定值 `data` 以 16 bits 無號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-download-u32 ( data subindex index n -- )`

將設定值 `data` 以 32 bits 無號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-download-u8 ( data subindex index n -- )`

將設定值 `data` 以 8 bits 無號整數的型式透過 SDO 寫到 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-upload-i16 ( subindex index n -- )`

以 16 bits 有號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-upload-i32 ( subindex index n -- )`

以 32 bits 有號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

命令範例:

    0 $6064 2 sdo-upload-i32 \ 讀取 slave position `2` Object `0x6064`:`0`

#### `sdo-upload-i8  ( subindex index n -- )`

以 8 bits 有號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-upload-u16 ( subindex index n -- )`

以 16 bits 無號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-upload-u32 ( subindex index n -- )`

以 32 bits 無號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

#### `sdo-upload-u8  ( subindex index n -- )`

以 8 bits 無號整數的型式透過 SDO 讀取 EtherCAT slave `n` 的 Object Index `index`: subindex `subindex`。

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

#### `waiting-requests? ( -- t )`

是否所有的 SDO 命令都已經執行完畢 ？

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `.ec-dc`              | ( -- ) |
| `.ec-emcy`            | ( n -- ) |
| `.ec-links`           | ( -- ) |
| `.ec-wdt-proc-data`  | ( n -- ) |
| `.sdo`                | ( n --  ) |
| `.slave`              | ( n -- ) |
| `.slave-diff`         | ( n -- ) |
| `?ec-emcy`            | ( n -- ) |
| `@ec-wdt-proc-data` | ( n -- ) |
| `ec-a>n`              | ( alias -- n ) |
| `ec-ain?`             | ( ch n -- t ) |
| `ec-alias!`           | ( alias n -- ) |
| `ec-alias?`           | ( alias -- t ) |
| `ec-aout?`            | ( ch n -- t ) |
| `ec-din?`             | ( ch n -- t ) |
| `ec-dout?`            | ( ch n -- t ) |
| `ec-drive?`           | ( ch n -- t ) |
| `ec-emcy-busy?`       |( n -- t ) |
| `ec-encoder?`         | ( ch n -- t ) |
| `ec-gateway?`         | ( ch n -- t ) |
| `ec-load`             | ( n -- ) |
| `ec-ready?`           | ( -- t ) |
| `ec-save`             | ( n -- ) |
| `ec-uart?`            | ( ch n -- t ) |
| `ec-wdt-proc-data@` | ( n -- data ) |
| `ec-wdt-proc-data!` | ( cmd n -- ) |
| `ec-wdt-proc-data-busy?` | ( n -- t ) |
| `ec-wdt-proc-data-error?` | ( n -- t ) |
| `list-slaves`         | ( -- ) |
| `sdo-busy?`           | ( n -- t ) |
| `sdo-data@`           | ( n -- data ) |
| `sdo-error?`          | ( n -- t ) |
| `sdo-download-i16`    |( data subindex index n -- ) |
| `sdo-download-i32`    |( data subindex index n -- ) |
| `sdo-download-i8`     |( data subindex index n -- ) |
| `sdo-download-u16`    |( data subindex index n -- ) |
| `sdo-download-u32`    |( data subindex index n -- ) |
| `sdo-download-u8`     | ( data subindex index n -- ) |
| `sdo-upload-i16`      |( subindex index n -- ) |
| `sdo-upload-i32`      |( subindex index n -- ) |
| `sdo-upload-i8`       |( subindex index n -- ) |
| `sdo-upload-u16`      |( subindex index n -- ) |
| `sdo-upload-u32`      |( subindex index n -- ) |
| `sdo-upload-u8`       | ( subindex index n -- ) |
| `until-no-requests`   | ( -- ) |
| `waiting-requests?`   | ( -- t ) |
