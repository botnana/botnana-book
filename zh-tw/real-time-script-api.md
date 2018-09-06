

Botnana Control 在其 real-time event loop 中使用了 Forth VM 以滿足更複雜的程式需求。透過 Forth 執行的命令會立刻影響裝置的行為。一般使用者並不需要使用此一 API。

## 指令集

除了標準的 Forth 指令，Botnana Control 增加了以下 Forth 指令集。

###1. Host primitives

* `#dins ( -- n )` Digital input count
* `#douts ( -- n )` Digital output count
* `dout@ ( n -- t=on )` Read digital output
* `dout! ( t=on n -- )` Write digital output
* `din@ ( n -- t=on )` Read digital input
* `time-msec ( -- n )` Current time in milliseconds

###2. EtherCAT primitives

####2.1 `.slave ( n -- )`

Print information of slave n
    
命令範例:

    2 .slave

以第2個 slave 為士林電機 SDP 驅動器為例，
    
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
    profile_deceleration.1.2 表示第 2 個 slave上第 1 個 Drive 的 profile deceleration [pulse/s^2], 
    profile_acceleration.1.2 表示第 2 個 slave上第 1 個 Drive 的 profile acceleration [pulse/s^2],
    profile_velocity.1.2 表示第 2 個 slave上第 1 個 Drive 的 profile velocity [pulse/s],
    operation_mode.1.2 表示第 2 個 slave上第 1 個 Drive 的 operation mode, 目前有支援的模式如下：
        1: Profile Position Mode
        3: Profile Velocity Mode
        6: Homing Mode
        8: Cycle Sync. Position Mode
    homing_method.1.2 表示第 2 個 slave上第 1 個 Drive 的 homing method, 常用的模式有：
        1 : Homing on negative limit and index pulse
        2 : Homing on positive limit and index pulse
        3, 4 : Homing on positive home switch and index pulse
        5, 6 : Homing on negative home switch and index pulse
        33: Homing on negative index pulse
        34: Homing on positive index pulse
        35: Homing on the current position
        其他： 參考驅動器 0x6098::0x00 的說明
    homing_speed_1.1.2 表示第 2 個 slave上第 1 個 Drive 的 Speed for search switch [pulse/s]        
    homing_speed_2.1.2 表示第 2 個 slave上第 1 個 Drive 的 Speed for search zero [pulse/s]
    homing_acceleration 表示第 2 個 slave上第 1 個 Drive 的 homing acceleration [pulse/s^2]    
    supported_drive_mode.1.2 表示第 2 個 slave上第 1 個 Drive 的 supported drive mode, 定義如下：
        Bit 0 : Profile Posiiton Mode
        Bit 2 : Profile Velocity Mode
        Bit 5 : Homing  Mode
        Bit 7 : Cycle Sync. Position Mode
        其他： 參考驅動器 0x6502::0x00 的說明    
    control_word.1.2 表示第 2 個 slave上第 1 個 Drive 的 Control Word, 定義如下：
        Bit 0 : Switch on
        Bit 1 : Enable voltage
        Bit 2 : Quick stop
        Bit 3 : Enable operation
        Bit 4~6 : Operation mode specification
        Bit 7 : Fault Reset
        Bit 8 : Halt
        其他： 參考驅動器 0x6040::0x00 的說明       
    target_position.1.2 表示第 2 個 slave上第 1 個 Drive 的 target position [pulse]
    target_velocity.1.2 表示第 2 個 slave上第 1 個 Drive 的 target velocity [pulse/s]
    status_word.1.2  表示第 2 個 slave上第 1 個 Drive 的 status word, 定義如下：
        Bit 0 : Ready to switch on
        Bit 1 : Switch on
        Bit 2 : Operation enabled (servo on)
        Bit 3 : Fault
        Bit 4 : Voltage Enabled
        Bit 5 : Quick Stop
        Bit 6 : Switch On Disabled
        Bit 7 : Warning
        Bit 10 : Target Reached
        其他： 參考驅動器 0x6041::0x00 的說明      
    real_position.1.2  表示第 2 個 slave上第 1 個 Drive 的 real position [pulse]
    digital_inputs.1.2 表示第 2 個 slave上第 1 個 Drive 的 digital inputs, 定義如下：
        Bit 0 : Negative Limit
        Bit 1 : Positive Limit
        Bit 2 : Home Switch
        Bit 3 : Emergency Swtch
        其他： 參考驅動器 0x60FD::0x00 的說明 
    
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
      

####2.2 `.slave-diff ( n -- )`

Print information difference of slave n
    
使用者可以使用 `.slave` 取得所有參數。使用 `.slave-diff` 取得自上次執行 `.slave`
或是 `.slave-diff` 後被改變的狀態。 如果上次執行 `.slave` 或 `.slave-diff` 後狀態都沒有改變，
回傳資料為空字串。
    
命令範例: 

    2 .slave-diff
    

####2.3 `list-slaves ( -- )`

Scan slaves

測試範例： 第 1 個 slave 為台達電 A2-E驅動器 , 第 2 個 slave 為士林電機驅動器, 

命令範例: 
    
    list-slaves

回傳訊息： 
    
    slaves|477,271601776,1468,1
    
    台達電 A2-E:  vendor_id = 477 (0x1DD)
                 product_code =  271601776 (0x10305070)
    士林電機 SDP: vendor_id = 1468 (0x5BC)
                 product_code =  1 (0x1)          

####2.4 `.sdo ( n --)`

Print SDO information of slave n

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
    sdo_index   : EtherCAT Object index。
    sdo_subindex: EtherCAT Object subindex。
    sdo_error   : 此 sdo request 是否有問題,
                  可能原因有 sdo_index 錯誤, 資料型態錯誤 ... 等等。
    sdo_busy    : 此 sdo request 是否還在處理中。
    sdo_data    : 該 位址 （index:subindex）的值。
    sdo_data_hex: 以 16 進位表示該位址的值。

####2.5 `sdo-upload-i32 ( subindex index n --)`

Upload data (i32) of index:subidex from slave n by SDO

命令範例: 使用 SDO 讀取 0x6064::0x00 在 slave 2 的值。 假設 Slave 2 是驅動器, 0 表示 subindex,
$6064 表示 index ($表示 16進位), 0x6064:0x00 的位址是 Position Actual Value 其型態是Integer 32，
可以由此指令讀回 Position Actual Value
             
             
    0 $6064 2 sdo-upload-i32             

####2.6 `sdo-upload-i16 ( subindex index n --)`

Upload data (i16) of index:subidex from slave n by SDO

####2.7 `sdo-upload-i8  ( subindex index n --)`

Upload data (i8) of index:subidex from slave n by SDO

####2.8 `sdo-upload-u32 ( subindex index n --)`

Upload data (u32) of index:subidex from slave n by SDO

####2.9 `sdo-upload-u16 ( subindex index n --)`

Upload data (u16) of index:subidex from slave n by SDO

####2.10 `sdo-upload-u8  ( subindex index n --)`

Upload data (u8) of index:subidex from slave n by SDO

####2.11 `sdo-download-i32 ( data subindex index n --)`

Download data (i32) of index:subidex to slave n by SDO

命令範例: 使用 SDO 設定 0x60FF::0x00 在 Slave 2 的值為 100, 假設 Slave 2 是驅動器, 0 表示 subindex,
$60FF 表示 index ($表示 16進位), 0x60FF:0x00 的位址是 Target Velocity 其型態是Integer 32，
可以由此指令設定 Target Velocity            

    100 0 $60FF 2 sdo-download-i32

####2.12 `sdo-download-i16 ( data subindex index n --)`

Download data (i16) of index:subidex to slave n by SDO

####2.13 `sdo-download-i8 ( data subindex index n --)`

Download data (i8) of index:subidex to slave n by SDO

####2.14 `sdo-download-u32 ( data subindex index n --)`

Download data (u32) of index:subidex to slave n by SDO

####2.15 `sdo-download-u16 ( data subindex index n --)`

Download data (u16) of index:subidex to slave n by SDO

####2.16 `sdo-download-u8 ( data subindex index n --)`

Download data (u8) of index:subidex to slave n by SDO

####2.17 `sdo-data@ ( n -- data)`

Fetch SDO data of slave n to stack

命令範例: 將 sdo-upload-i32, sdo-upload-i16, sdo-upload-i8, sdo-upload-u32, sdo-upload-u16,
sdo-upload-u8, sdo-download-i32, sdo-download-i16, sdo-download-i8, sdo-download-u32,
sdo-download-u16,sdo-download-u8 命令所讀取或是設定的值取出放入整數堆疊

    2 sdo-data@                                                               

####2.18 `sdo-error? ( n -- flag)`

Fetch error flag of SDO data of slave n to stack
    
命令範例:

    2 sdo-error? 

####2.19 `sdo-busy? ( n -- flag)`

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


####2.20 `ec-ready? ( -- flag )`

Is EtherCAT Communication ready ?
    
    
####2.21 `.link-states ( -- )`

輸出 EtherCAT Communication 的狀態

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
             
    slaves_responding : EtherCAT Slaves 的連線數
    al_states         : 所有的 EtherCAT Slaves 的狀態指標，正常為 8
    input_wc          : input working count
    output_wc         : output working count
    input_wc_state    : 正常為 1
    output_wc_state   : 正常為 1
    input_wc_error    : input_wc_state 異常次數, 在開機初始化時會增加，
                        當 EtherCAT Master 與 slave 交握成功後就不會再增加。
    output_wc_error   : output_wc_state 異常次數在開機初始化時會增加，
                        當 EtherCAT Master 與 slave 交握成功後就不會再增加。
    

###3 EtherCAT IO primitives

####3.1 `ec-dout@ ( channel n -- t=on )`

Get DOUT from EtherCAT slave n

命令範例: 將 Slave 3 的 Channel 2 DO 狀態放到等數堆疊 
    
    2 3 ec-dout@
    

####3.2 `ec-dout! ( t=on channel n -- )`

Set DOUT of EtherCAT slave n

命令範例1: 將 Slave 3 的 Channel 2 DO 設定為 1。 

    1 2 3 ec-dout!

命令範例2: 將 Slave 3 的 Channel 2 DO 設定為 0。 

    0 2 3 ec-dout!

####3.3 `ec-din@ ( channel n -- t=on )`

Get DIN from EtherCAT slave n

命令範例: 將 Slave 5 的 Channel 3 DI 狀態放到等數堆疊。 

    3 5 ec-din@

####3.4 `-ec-aout ( channel n )`

Disable AOUT of EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 AO 禁能。 

    1 2 -ec-aout

####3.5 `+ec-aout ( channel n )`

Enable AOUT of EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 AO 致能。 

    1 2 +ec-aout


####3.6 `ec-aout@ ( channel n -- value )`

Get AOUT from EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 AO data 放到整數堆疊。 

    1 2 ec-aout@

####3.7 `ec-aout! ( value channel n -- )`

Set AOUT of EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 AO data 設定為 100。 
    
    100 1 2 ec-aout!

####3.8 `-ec-ain ( channel n )`

Disable AIN of EtherCAT slave n

命令範例: 將 Slave 6 的 Channel 1 AI 禁能。 

    1 6 -ec-ain

####3.9 `+ec-ain ( channel n )`

Enable AIN of EtherCAT slave n

命令範例: 將 Slave 6 的 Channel 1 AI 致能。 

    1 6 +ec-ain

####3.10 `ec-ain@ ( channel n -- value )`

Get AIN from EtherCAT slave n

命令範例: 將 Slave 6 的 Channel 1 AI data 放到整數堆疊。 

    1 6 ec-ain@


###4 EtherCAT Drive primitives

和設定檔的 API 不同，此法設定的參數會立即生效。

####4.1 `op-mode! ( mode ch n -- )`

Set operation mode of channel `ch` of slave `n`
    
使用 SDO 指令, 目前有支援的 mode 如下：

    1: Profile Position Mode (PP)
    3: Profile velocity Mode (PV)
    6: Homing Mode (HM)              
    8: Cyclic Sync. Position Mode (CSP)

命令範例: 將 Slave 3 的 Channel 2 的驅動器模式切換到 PP Mode 。

    1 2 3 op-mode!

命令範例: 將 Slave 3 的 Channel 2 的驅動器模式切換到 HM Mode 。         

    6 2 3 op-mode!

####4.2 `pp ( -- 1)`

將 1 放入整數堆疊

命令範例: 等同於 `1 2 3 op-mode!`

    PP 2 3 op-mode! 
  
####4.3 `pv ( -- 3)`

將 3 放入整數堆疊    

####4.4 `hm ( -- 6)`

將 6 放入整數堆疊    

命令範例: 等同於 6 2 3 op-mode!  

    hm 2 3 op-mode! 。    

####4.5 `csp ( -- 8)`

將 8 放入整數堆疊            

####4.6 `servo-on ( ch n -- )`

Servo on of channel `ch` of slave `n`

使用 PDO 指令搭配有限狀態機。    

    命令範例: 將 Slave 3 Channel 2 的驅動器 Servo on。
    
    2 3 servo-on    

####4.7 `servo-off ( ch n -- )`

Servo off of channel `ch` of slave `n`

####4.8 `servo-stop ( ch n -- )`

Servo stop of channel `ch` of slave `n`

####4.9 `reset-fault ( ch n -- )`

Reset fault of channel `ch` of slave `n`

使用 PDO 指令搭配有限狀態機。 
    
命令範例: 解除 Slave 3 Channel 2 的驅動器異警 。


    2 3 reset-fault

####4.10 `go ( ch n -- )`

Set point of channel `ch` of slave `n`

使用 PDO 指令。當驅動器在 PP 或是 HM 模式，參數設定完成後需要透過此命令開始運動。相當於驅動器 Control Word 0x6040::0x00 Bit 4。

命令範例: Slave 3 Channel 2 的 set point or start homing 。
    
    2 3 go    
    
####4.11 `target-p! ( p ch n -- )`

Set target position of channel `ch` of slave `n`

使用 PDO 指令。如果是在驅動器 CSP mode 直接設定 target position 可能會造成驅動器落後誤差過大異警。
CSP 模式適合用來多軸同動的場合, 通常需要搭配上位控制器的路徑規劃, 加減速機制與位置補間。     

命令範例: 設定 Slave 3 Channel 2 的 target position 為 1000。
               
    1000 2 3 target-p!
    
####4.12 `target-v! ( v ch n -- )`

Set target velocity of channel `ch` of slave `n`

使用 SDO 指令。

命令範例: 設定 Slave 3 Channel 2 的 Target Vecloity 為 1000。   
    
    1000 2 3 target-v!

####4.13 `target-reached? ( ch n -- t=reached )`

Has of channel `ch` of slave `n` reached its target position?

使用 PDO 指令。相當於驅動器 0x6041:0x00 Status Word Bit 10 Target Reached

命令範例: 設定 Slave 3 Channel 2 的 Target Vecloity 為 1000。   
    
    2 3 target-reached?    

####4.14 `until-target-reached? ( ch n -- )`

等待指定的驅動器到達目標。

相當於:

    : until-target-reached ( channel slave -- )
        ." log|" over over swap . . ." until-target-reached" cr
        pause pause pause pause pause pause \ 用來確保是收到驅動器回傳新的 status word後再進行狀態判斷
        begin
            over over target-reached? not
        while
            pause
        repeat
        drop drop
    ;

命令範例: 等待 Slave 3 Channel 2 的目標到達 。   
    
    2 3 until-target-reached    

####4.15 `homing-a! ( acceleration ch n -- )`

Set homing acceleration of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x609A:0x00 homing acceleration

命令範例:   
    
    50000 2 3 homing-a!    

####4.16 `homing-method! ( method ch n -- )`

Set homing method of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6098:0x00 homing method

命令範例:   
    
    1 2 3 homing-method!    

####4.17 `homing-v1! ( speed ch n -- )`

Set homing speed 1 of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6099:0x01 homing speed for switch

命令範例:   
    
    1000 2 3 homing-v1!  

####4.18 `homing-v2! ( speed ch n -- )`

Set homing speed 2 of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6099:0x02 homing speed for zero

命令範例:   
    
    1000 2 3 homing-v2!  

####4.19 `profile-a1! ( acceleration ch n -- )`

Set profile acceleration of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6083:0x00 profile acceleration。在驅動器 PP 與 PV Mode 時的加速度。

命令範例:   
    
    1000 2 3 profile-a1!  

####4.20 `profile-a2! ( deceleration ch n -- )`

Set profile deceleration of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6084:0x00 profile deceleration。在驅動器 PP 與 PV Mode 時的減速度。

命令範例:   
    
    1000 2 3 profile-a2!  

####4.21 `profile-v! ( velocity ch n -- )`

Set profile velocity of channel `ch` of slave `n`

使用 SDO 指令。相當於驅動器 0x6081:0x00 profile velocity。在驅動器 PP Mode 時的最大的規劃速度。

命令範例:   
    
    1000 2 3 profile-v! 


####4.22 `waiting-requests? ( -- flag)` 

Is any waiting sdo request?

#### `until-no-requests ( -- )`

等待所有的 SDO Request 完成。

相當於
    
    : until-no-requests ( -- )
        ." log|until-no-requests" cr
        begin
            waiting-requests?
        while
            pause
        repeat ;

####4.23 `drive-fault? ( ch n -- flag)`

Has dive fault of channel `ch` of slave `n`

####4.24 `until-no-fault ( ch n -- )`

Until no fault of channel `ch` of slave `n`

相當於 
    
    : until-no-fault ( channel slave -- )     
        ." log|" over over swap . . ." until-no-fault" cr
        pause pause pause pause pause pause
        begin
            over over drive-fault?
        while
            pause
        repeat
        drop drop ; 


####4.25 `drive-op? ( ch n -- flag)`

Is dive servo-on of channel `ch` of slave `n`

####4.26 `until-servo-on ( ch n -- )`

Until servo-on of channel `ch` of slave `n`

相當於

    : until-servo-on ( channel slave -- )
        ." log|" over over swap . . ." until-servo-on" cr
        pause pause pause pause pause pause
        begin
            over over drive-op? not
        while
            pause
        repeat
        drop drop ;

####4.27 pp-test 範例 

    : pp-test
        pp 2 3 op-mode!          \ 切換到 PP Mode
        until-no-requests        \ 等待 op-mode! 命令實際設定到驅動器
        2 3 reset-fault          \ 解除驅動器異警
        2 3 util-no-fault        \ 等待解除驅動器異警完成  
        2 3 servo-on             \ Servo On 
        2 3 until-servo-on       \ 等待 Servo on 程序完成
        1000 2 3 target-p!       \ Set target position to 1000
        2 3 go                   \ Start
        2 3 until-target-reached \ 等待到達目標點
    ;
    
    deploy pp-test ;deploy       \ 在背景執行 pp-test


####4.28 `drive-dis@ ( ch n -- dis )`

將指定 Channel `ch` Slave `n` 的驅動器之數位輸入資訊放到整數堆疊上。


####4.29 `drive-org? ( ch n -- org )`

將指定 Channel `ch` Slave `n` 的驅動器之 home switch 狀態放到整數堆疊上。

####4.30 `drive-nl? ( ch n -- nl )`

將指定 Channel `ch` Slave `n` 的驅動器之負向極限開關狀態放到整數堆疊上。


####4.31 `drive-pl? ( ch n -- pl )`

將指定 Channel `ch` Slave `n` 的驅動器之正向極限開關狀態放到整數堆疊上。

####4.32 `?ec-emcy ( slave -- )`

當驅動器發生異警時，可以使用此命令讓驅動器將異警訊息（emergency message）傳送回來。

####4.33 `ec-emcy-busy? ( slave -- flag )`

將 `?ec-emcy` 指令的執行狀況放到整數堆疊上 

####4.34 `.ec-emcy ( slave -- )`

回傳 emergemcy message 訊息。目前 Botnana-Control
會依據 status word 中的 Fault Bit 自動送出 ?ec-emcy 的命令。

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


### 5. 軸組 (Axis Group) 

####5.1 `.motion (--)`
    
Print information of motion. 

只能透過 Json API 進行設定。 
 
命令範例:   
    
    .motion
 
回傳訊息：
    
    period_us|2000
    |group_capacity|7
    |axis_capacity|10 

####5.2 Group

####5.2.1 `gvmax! (g --) (F: v)`

Set vmax of group (g).

命令範例： 設定 Group 2 的最高速度為  1000.0 mm/min
    
    1000.0e mm/min 2 gvmax!

####5.2.2 `gamax! (g --) (F: a)`

Set amax of group (g).


命令範例： 設定 Group 2 的最大加速度為  2.0 m/s^2
    
    2.0e 2 gamax!


####5.2.3 `gjmax! (g --) (F: j)`

Set jmax of group (g).

命令範例： 設定 Group 2 的最大加加速度為  40.0 m/s^3
    
    40.0e 2 gjmax!


####5.2.4 `map1d (x g --)`

Set axis mapping (x) of group (g). The group shall be Group1D.

命令範例： 設定 Group 2 的輸出軸為 Axis 3
    
    3 2 map1d    
   
####5.2.5 `map2d (x y g --)`

Set axis mapping (x, y) of group (g). The group shall be Group2D.


命令範例： 設定 Group 2 的輸出軸為 Axis 3, 5
    
    3 5 2 map2d    

####5.2.6 `map3d (x y z g --)`

Set axis mapping (x, y, z) of group (g). The group shall be Group3D.

命令範例： 設定 Group 2 的輸出軸為 Axis 3, 5, 6
    
    3 5 6 2 map3d  


####5.2.7 `.grpcfg (g --)`

Print information of group g.

命令範例：
    
    1 .grpcfg
    
回傳訊息:

    group_name.1|BotnanaGo
    |group_type.1|1D
    |group_mapping.1|1
    |group_vmax.1|0.100
    |group_amax.1|5.000
    |group_jmax.1|80.00  

####5.3 Axis

####5.3.1 `enc-ppu! (j --) (F: ppu --)`

Set encoder ppu (pulses_per_unit) of axis j.
  

命令範例可以參考 `enc-u!` 

####5.3.2 `enc-u! (u j --)`

Set encoder length unit of axis j.

可以設定的單位有：

* u = 0 as Meter,
* u = 1 as Revolution
* u = 2 as Pulse

命令範例： 設定 Axis 3 的編碼器解析度
    
    1000000.0e 3 enc-ppu!
    0 3 enc-u!

    以上的命令設定表示 1 m 有 1000000 個pulse (編碼器脈波數),
    表示 1 pulse 為 1 um 

####5.3.3 `enc-dir! (dir j --) `

Set encoder direction of axis j.

當機器的軸向與馬達的運轉方向定義相反時可以藉由此參數來轉換。

dir 可以設定的值為：

* 1: 同方向
* -1: 反方向

命令範例： 設定 Axis 3 編碼器方向
    
    1 3 enc-dir!

####5.3.4 `hmofs! (j --) (F: ofs --)`

Set home offset of axis j.

可以用來調整運動軸與驅動器命令位置的位置偏移量。  

    drive_command = axis_command - home_offset;
    drive_pulse_command = drive_command/encoder_resolution*encoder_direction;

命令範例： 設定 Axis 3 home offset
    
    0.5e 3 hmofs!
    
####5.3.5 `axis-vmax! (j --) (F: vmax --)`

設定運動軸的最大速度


命令範例1： 設定 Axis 3 vmax 為 0.5 m/s
    
    0.5e 3 axis-vmax!


命令範例2： 設定 Axis 3 vmax 為 0.5 mm/min
    
    0.5e mm/min 3 axis-vmax!

####5.3.6 `axis-amax! (j --) (F: amax --)`

設定運動軸的最大加速度


命令範例： 設定 Axis 3 amax 為 2.0 m/s^2
    
    2.0e 3 axis-amax!


####5.3.7 `slave-axis! (slave j --)`

設定運動軸 `j` 對應到的 EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Slave Position 為 2
     
    2 3 slave-axis!

####5.3.8 `channel-axis! (ch j --)`

設定運動軸 `j` 對應到的 Channel `ch` of EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Channel of EtherCAT Slave 為 1
     
    1 3 slave-axis!    
    
####5.3.9 `.axiscfg (j --)`

Print information of axis j. 

命令範例： 
    
    1 .axiscfg

回傳訊息：

    axis_name.1|Anonymous
    |axis_home_offset.1|0.0000
    |encoder_ppu.1|1000000.00000
    |encoder_length_unit.1|Meter
    |encoder_direction.1|1
    |axis_slave_position.1|1
    |axis_drive_channel.1|1
    |axis_amax.1|5.00000
    |axis_vmax.1|0.10000

####5.4 Axis Group Operation 

####5.4.1 `start (--)`

start 

####5.4.2 `stop (--)`

stop

####5.4.3 `ems (--)`

emergency stop

####5.4.4 `reset-job (--)`

reset job

####5.4.5 `group! ( n -- )`

Select group `n`, `n` start by 1.

與 group 的命令，必須要利用此命令進行 group 的切換。命令範例參考 `group@`

####5.4.6 `group@ ( -- n)`

Get current group index `n`.

命令範例:
    
    group@ .  \ 取出目前 Group index, 並輸出整數堆疊訊息, 假設為 5 
    group@    \ 取出目前 Group index, 堆疊上會有 5  
    1 group!  \ 設定 Group index 為 1
    group@ .  \ 取出目前 Group index, 並輸出整數堆疊訊息, 其值應該為 1
    2 group!  \ 設定 Group index 為 2
    group@ .  \ 取出目前 Group index, 並輸出整數堆疊訊息, 其值應該為 2
    group!    \ 設定 Group index 為整數堆疊的上值 （5）
    group@ .  \ 取出目前 Group index, 並輸出整數堆疊訊息, 其值應該為 5


####5.4.7 `0path` ( -- )

Clear path.

命令範例1:
    
    0path           \ 清除當下 Group 的路經
    
命令範例2:
          
    1 group! 0ptah  \ 清除 Group 1 的路經      

####5.4.8 `feedrate! ( F: v -- )`

Set programmed segment feedrate. `v` shall be > 0.

命令範例1:
    
    100.0e mm/min feedrate!           \ 設定當下 Group 的 segment feedrate 為 100.0 mm/min      

命令範例2:

    1 group!  100.0e mm/min feedrate! \ 設定 Group 1 的 segment feedrate 為 100.0 mm/min 


####5.4.9 `feedrate@ ( F: -- v )`

Get programmed segment feedrate. 

命令範例1:

    feedrate@
    
命令範例2:
    
    1 group! feedrate@


####5.4.10 `+coordinator (--)`

Enable coordinator.

由 Botnana-Control 進行軸運動控制，Botnana-Control會運行軸組的路徑規劃與位置補間。
在此模式之下，驅動器必須要切換到 CSP Mode。

命令範例:
    
    +coordinator

####5.4.11 `-coordinator (--)`

Disable coordinator.

命令範例:
    
    -coordinator


####5.4.12 `+group (--)`

Enable current group.

命令範例1:

    +group
    
命令範例2:
    
    1 group! feedrate@
    

####5.4.13 `-group (--)`

Disable current group.


####5.4.14 `vcmd! ( F: v -- )`

Set execution velocity command. 

命令範例: 設定運動速度為 100.0 mm/min

    100.0e mm/min vcmd!

**TODO: 提供 V < 0 的運動能力 （沿路徑後退）**

####5.4.15 `gend? (-- flag )`

Has path of current group ended ?

####5.4.16 `gstop? (-- flag )`

Has path of current group stopped ?

####5.4.17 `empty? (-- flag)`

Is path of current group empty?

####5.4.18 `end? (-- flag)`

Has path of all groups of coordinator ended ?

####5.4.19 `stop? (-- flag)`

Has path of all groups of coordinator stopped ?

####5.5 1D Path Planning

Current axis group should be 1D for the following commands to work without failure.

####5.5.1 `move1d (F: x -- )` 

    Declare the current absolute coordinate to be `x`. (G92)

####5.5.2 `line1d (F: x -- )` 

    Add a line to `x` into path.
    
####5.5.3 範例 test-1d
    
假設 Group 2 為  1D group, 以100.0 mm.min 速度運動通過相對起點為 -0.5, 1.0，終點為 0.0 的座標位置。
     
    : test-1d                      \ 定義 test-1d 指令
        +coordinator               \ 啟動軸運動控制模式                    
        start                      \ 啟動加減速機制
        2 group! +group            \ 啟動 Group 2
        0path                      \ 清除 Group 2 路徑
        0.0e move1d                \ 宣告目前位置為起始運動位置，座標為 0.0 
        -0.5e line1d               \ 插入目標點為 -0.5 的 1D 直線路徑
        1.0e line1d                \ 插入目標點為 1.0 的 1D 直線路徑
        0.0e line1d                \ 插入目標點為 0.0 的 1D 直線路徑  
        100.0e mm/min vcmd!        \ 設定運動速度為 100.0 mm/min
        begin                      \ 等待到達終點位置
            2 group! gend? not     \ 檢查是否到終點, 此處 2 group! 避免在等待過程中被其他指令修改了 Group index
        while
            pause                  \ 若是未到終點就等待下一個周期再進行檢查       
        repeat 
        2 group! -group            \ 關閉 Group 2 
    ;
    
    deploy test-1d ;deploy         \ 在背景執行 test-1d

    
####5.6 2D Path Planning

Current aixs group should be 2D for the following commands to work without failure.

####5.6.1 `move2d (F: x y -- )`

Declare the current absolute coordinate to be `(x, y)`. (G92)

####5.6.2 `line2d (F: x y -- )`

Add a line to `(x, y)` into path.

####5.6.3 `arc2d ( n --)(F: cx cy x y -- )`

Add an arc to `(x, y)` with center `(cx, cy)` into path.

`n` 不可以為 0, 如果 n > 0 表示逆時針運動，n < 0 表示順時針運動。

####5.6.4 範例 test-2d
    
假設 Group 5 為  2D group
     
    : test-2d                          \ 定義 test-2d 指令
        +coordinator                   \ 啟動軸運動控制模式                    
        start                          \ 啟動加減速機制
        5 group! +group                \ 啟動 Group 5
        0path                          \ 清除 Group 5 路徑
        0.0e  0.0e  move2d             \ 宣告目前位置為起始運動位置，座標為 (0.0, 0.0) 
        0.1e  0.0e  line2d             \ 插入目標點為 (0.1, 0.0) 的 2D 直線路徑
        0.1e  0.1e  line2d             \ 插入目標點為 (0.1, 0.1) 的 2D 直線路徑 
        0.0e  0.1e  line2d             \ 插入目標點為 (0.0, 0.1) 的 2D 直線路徑 
        0.0e  0.05e 0.0e 0.0e 1 arc2d  \ 以圓心位置 （0.0, 0.05）逆時針走到目標點 （0.0, 0.0） 
        100.0e mm/min vcmd!            \ 設定運動速度為 100.0 mm/min
        begin                          \ 等待到達終點位置
            5 group! gend? not         \ 檢查是否到終點, 此處 5 group! 避免在等待過程中被其他指令修改了 Group index
        while
            pause                      \ 若是未到終點就等待下一個周期再進行檢查       
        repeat 
        5 group! -group                \ 關閉 Group 5 
    ;
    
    deploy test-2d ;deploy         \ 在背景執行 test-2d

####5.7 3D Path Planning

Current axis group should be 3D for the following commands to work without failure.

####5.7.1 `move3d (F: x y z -- )`

Declare the current absolute coordinate to be `(x, y, z)`. (G92)

####5.7.2 `line3d (F: x y z -- )`

Add a line to `(x, y, z)` into path.

####5.7.3 `helix3d ( n --)(F: cx cy x y z -- )`

Add a helix to `(x, y, z)` with center `(cx, cy)` into path. If z is the current z, the added curve is an arc.

`n` 不可以為 0, 如果 n > 0 表示逆時針運動，n < 0 表示順時針運動。

####5.7.4 範例 test-3d
    
假設 Group 1 為 3D group
     
    : test-3d                          \ 定義 test-3d 指令
        +coordinator                   \ 啟動軸運動控制模式                    
        start                          \ 啟動加減速機制
        1 group! +group                \ 啟動 Group 1
        0path                          \ 清除 Group 1 路徑
        0.0e  0.0e  0.0e   move3d      \ 宣告目前位置為起始運動位置，座標為 (0.0, 0.0, 0.0) 
        0.0e  0.1e  0.0e  line3d       \ 插入目標點為 (0.0, 0.1, 0.0) 的 3D 直線路徑
        -0.1e  0.1e -0.2e 0.1e 0.1e  1 helix3d 
                                       \ 以圓心位置 （-0.1, 0.1）逆時針走到目標點 （-0.2, 0.1, 0.1 ）的螺旋路徑 
        100.0e mm/min vcmd!            \ 設定運動速度為 100.0 mm/min
        begin                          \ 等待到達終點位置
            1 group! gend? not         \ 檢查是否到終點, 此處 1 group! 避免在等待過程中被其他指令修改了 Group index
        while
            pause                      \ 若是未到終點就等待下一個周期再進行檢查       
        repeat 
        1 group! -group                \ 關閉 Group 1 
    ;
    
    deploy test-3d ;deploy         \ 在背景執行 test-3d


####5.8 Sine Wave

Current axis group should be SINE for the following commands to work without failure.

####5.8.1 `move-sine (F: x -- )`

Declare the current absolute coordinate to be `x`. (G92)

####5.8.2 `sine-f! (F: f -- )`

Set frequency `f` of sine wave

####5.8.3 `sine-amp! (F: amp -- )`

Set amplitude `amp` of sin wave

####5.8.4 範例 test-sine
    
假設 Group 1 為 SINE group
     
    +coordinator          \ 啟動軸運動控制模式                    
    start                 \ 啟動加減速機制
    1 group! +group       \ 啟動 Group 1
    0path                 \ 清除 Group 1 路徑
    0.0e   move-sine      \ 宣告目前位置為起始運動位置，座標為 (0.0) 
    1.0e   sine-f!        \ 設定sine wave 頻率為 1.0 Hz
    0.01e  sine-amp!      \ 設定sine wave 振幅為 0.01
    ...
    stop                  \ 停止加減速機制
    
####5.9 插值後加減速

命令針對單一運動軸，可以同時讓多個運動軸同時運行。如果該運動軸受到軸組控制則不可執行插值後加減速機制。  

####5.9.1 `+interpolator ( j --)`

啟動 Axis `j` 插值後加減速機制。

####5.9.2 `-interpolator ( j --)`

關閉 Axis `j` 插值後加減速機制。如果插值器運作中，會以當下的位置開始減速到 0。

####5.9.3 `interpolator-v! ( j --)（F: v -- ）` 

設定 Axis  `j` 插值器得最大運動速度。
 
####5.9.4 `axis-cmd-p! ( j --)(F: pos --)`

設定 Axis  `j` command position

####5.9.5 插值後加減速範例

以 Axis 1 為例：

    1  +interpolator                 \ 啟動 Axis 1 插值後加減速
    100.0 mm/min  1  interpolator-v! \ 設定 Axis 1 插值速度為 100.0 mm/min
    0.3 1 axis-cmd-p!                \ 設定 Axis 1 的目標位置為座標位置 0.3 m 

####5.10 運動軸追隨

####5.10.1 `axis-demand-p@ ( j --)(F: -- pos)`

取得 Axis j 的命令位置 

####5.10.2 `axis-real-p@ ( j --)(F: -- pos)`

取得 Axis j 的實際位置 

####5.10.3 命令範例：

以 Axis 2 追隨 Axis 1 的命令位置運動

    ...
    begin
        ... \某個條件成立執行
    while
        ........
        2 axis-demand-p@ 1 axis-cmd-p! 
        pause
    repeat         
    ...


####5.11 Information

####5.11.1 `.group (g --)`

Print information of group g.

命令範例:  

    1 .group

回傳訊息 :
    
    group_enabled.1|false
    |group_stopping.1|true
    |move_count.1|0
    |path_event_count.1|0
    |focus.1|0
    |source.1|0
    |pva.1|0.00000,0.00000,0.00000
    |move_length.1|0.00000
    |total_length.1|0.00000
    |feedrate.1|0.000
    |vcmd.1|0.000
    |max_look_ahead_count.1|0
    |ACS.1|0.00000
    |PCS.1|0.00000
    
    
####5.11.2 `.axis (j --)`

Print information of axis j.

命令範例:  

    1 .axis

回傳訊息 :

    axis_command_position.1|-0.00000
    |axis_demand_position.1|-0.00000
    |axis_corrected_position.1|-0.00001
    |encoder_position.1|-0.00001
    |following_error.1|0.00001
    |axis_interpolator_enabled.1|false

###6. Pitch Corrector

####6.1 `+pcorr ( channel slave -- )`

開啟指定驅動器的 Pitch Corrector

####6.2 `-pcorr ( channel slave -- )`

關閉指定驅動器的 Pitch Corrector


####6.3 `>pcorr ( channel slave -- )`

讀取指定驅動器的 Pitch Corrector，此命令會造成 real time cycle overrun, 要在安全的情況下使用，例如 Servo off 的情況下。


####6.4 `.pcorr ( channel slave -- )`

輸出目前 Pitch Corrector 的查表結果

命令範例:  
    
    1 1 .pcorr

回傳訊息 :

    pcorr_name.1.1|P0001-01.sdx
    |pcorr_len.1.1|10
    |pcorr_position.1.1|0.0000000
    |pcorr_forward.1.1|0.0000000
    |pcorr_backward.1.1|0.0000000
    |pcorr_corrected_position.1.1|0.0000000
    |pcorr_backlash.1.1|0.0000000
    |pcorr_direction.1.1|1
    |pcorr_factor.1.1|0.0020000
    |pcorr_enabled.1.1|0


###7 CPU Timing Profiler

####7.1 `.cpu-timing ( -- )`

Print information of CPU timing

####7.2 `0cpu-timing ( -- )`

Reset CPU timing

###8. misc

####8.1 `.verbose ( -- )`

Print verbose infornatiom

回傳訊息範例 :

    version_number|1.3.1|period_us|2000|launch_time|2018-08-09T10:19:21Z

