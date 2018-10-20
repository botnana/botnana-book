## 前言

Botnana Control 在其 real-time event loop 中使用了 Forth VM 以滿足更複雜的程式需求。透過 Forth 執行的命令會立刻影響裝置的行為。

## 指令集

除了標準的 Forth 指令，Botnana Control 增加了以下 Forth 指令集。

### Host primitives

* `#dins ( -- n )` Digital input count
* `#douts ( -- n )` Digital output count
* `dout@ ( n -- t=on )` Read digital output
* `dout! ( t=on n -- )` Write digital output
* `din@ ( n -- t=on )` Read digital input
* `time-msec ( -- n )` Current time in milliseconds

### EtherCAT primitives

#### `.slave ( n -- )`

Print information of slave n
    
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
    
#### `waiting-requests? ( -- flag)` 

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



### EtherCAT IO primitives

#### `ec-dout@ ( channel n -- t=on )`

Get digital output state from EtherCAT slave n.

命令範例: 將 slave 3 的 channel 2 digital output state 放到整數堆疊 
    
    2 3 ec-dout@


#### `ec-dout! ( t=on channel n -- )`

Set digital output state of EtherCAT slave n.

命令範例 1: 將 slave 3 的 channel 2 digital output state 設定為 1。 

    1 2 3 ec-dout!

命令範例 2: 將 slave 3 的 channel 2 digital output state 設定為 0。 

    0 2 3 ec-dout!

#### `ec-din@ ( channel n -- t=on )`

Get digital input state from EtherCAT slave n.

命令範例: 將 slave 5 的 channel 3 digital input state 放到整數堆疊。 

    3 5 ec-din@

#### `-ec-aout ( channel n -- )`

Disable analog output of EtherCAT slave n

命令範例: 將 slave 2 的 channel 1 analog output 禁能。 

    1 2 -ec-aout

#### `+ec-aout ( channel n -- )`

Enable analog output of EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 analog output 致能。 

    1 2 +ec-aout


#### `ec-aout@ ( channel n -- value )`

Get analog output data from EtherCAT slave n.

命令範例: 將 Slave 2 的 Channel 1 analog output data 放到整數堆疊。 

    1 2 ec-aout@

#### `ec-aout! ( value channel n -- )`

Set analog output data of EtherCAT slave n

命令範例: 將 slave 2 的 channel 1 analog output data 設定為 100。 
    
    100 1 2 ec-aout!

#### `-ec-ain ( channel n -- )`

Disable analog input of EtherCAT slave n

命令範例: 將 slave 6 的 channel 1 analog input 禁能。 

    1 6 -ec-ain

#### `+ec-ain ( channel n -- )`

Enable analog input of EtherCAT slave n

命令範例: 將 slave 6 的 channel 1 analog input 致能。 

    1 6 +ec-ain

#### `ec-ain@ ( channel n -- value )`

Get analog input data from EtherCAT slave n.

命令範例: 將 slave 6 的 channel 1 analog input data 放到整數堆疊。 

    1 6 ec-ain@

### EtherCAT Drive primitives

#### `op-mode! ( mode ch n -- )`

Set operation mode of drive channel `ch` of slave `n`
    
使用 SDO 指令, 目前有支援的 mode 如下：

    1: profile position mode (PP)
    3: profile velocity mode (PV)
    6: homing mode (HM)              
    8: cyclic sync. position mode (CSP)

命令範例: 將 slave 3 的 drive channel 2 的驅動器模式切換到 PP Mode 。

    1 2 3 op-mode!

命令範例: 將 slave 3 的 drive channel 2 的驅動器模式切換到 HM Mode 。         

    6 2 3 op-mode!

#### `pp ( -- 1)`

將 1 放入整數堆疊

命令範例: 等同於 `1 2 3 op-mode!`

    pp 2 3 op-mode! 
  
#### `pv ( -- 3)`

將 3 放入整數堆疊    

#### `hm ( -- 6)`

將 6 放入整數堆疊    

命令範例: 等同於 6 2 3 op-mode!  

    hm 2 3 op-mode! 。    

#### `csp ( -- 8)`

將 8 放入整數堆疊            

#### `servo-on ( ch n -- )`

Servo on of channel `ch` of slave `n`

使用 PDO 指令搭配有限狀態機。    

命令範例: 將 slave 3 drive hannel 2 的驅動器 servo on。
    
    2 3 servo-on    

#### `servo-off ( ch n -- )`

Servo off of channel `ch` of slave `n`

#### `servo-stop ( ch n -- )`

Servo stop of channel `ch` of slave `n`

#### `reset-fault ( ch n -- )`

Reset fault of drive channel `ch` of slave `n`.

使用 PDO 指令搭配有限狀態機。 
    
命令範例: 解除 slave 3 drive channel 2 的驅動器異警 。

    2 3 reset-fault

#### `go ( ch n -- )`

Set point of drive channel `ch` of slave `n`.

使用 PDO 指令。當驅動器在 PP 或是 HM 模式，參數設定完成後需要透過此命令開始運動。相當於驅動器 control word 0x6040::0x00 Bit 4。

命令範例: slave 3 Channel 2 的 set point or start homing 。
    
    2 3 go    
    
#### `target-p! ( p ch n -- )`

Set target position of drive channel `ch` of slave `n`.

使用 PDO 指令。如果是在驅動器 CSP mode 直接設定 target position 可能會造成驅動器落後誤差過大異警。
CSP 模式適合用來多軸同動的場合, 通常需要搭配上位控制器的路徑規劃, 加減速機制與位置補間。     

命令範例: 設定 slave 3 drive channel 2 的 target position 為 1000。
               
    1000 2 3 target-p!
    
#### `target-v! ( v ch n -- )`

Set target velocity of channel `ch` of slave `n`

使用 SDO 指令。

命令範例: 設定 Slave 3 Channel 2 的 Target Vecloity 為 1000。   
    
    1000 2 3 target-v!

#### `target-reached? ( ch n -- t=reached )`

Has drive channel `ch` of slave `n` reached its target position?

使用 PDO 指令。相當於驅動器 0x6041:0x00 

命令範例: 取得 slave 3 drive channel 2 的 target reached state 到整數堆疊。   
    
    2 3 target-reached?    

#### `until-target-reached? ( ch n -- )`

等待指定的驅動器到達目標。

相當於:

    : until-target-reached ( channel slave -- )
        ." log|" over over swap . . ." until-target-reached" cr
        pause pause pause pause pause pause \ 確保收到驅動器回應的 status word
        begin
            over over target-reached? not
        while
            pause
        repeat
        drop drop
    ;

命令範例: 等待 slave 3 drive channel 2 的目標到達 。   
    
    2 3 until-target-reached    

#### `homing-a! ( acceleration ch n -- )`

Set homing acceleration of drive channel `ch` of slave `n`.

使用 SDO 指令設定 0x609A:0x00 homing acceleration.

命令範例:   
    
    50000 2 3 homing-a!    

#### `homing-method! ( method ch n -- )`

Set homing method of drive channel `ch` of slave `n`.

使用 SDO 指令設定 0x6098:0x00 homing method.

命令範例:   
    
    1 2 3 homing-method!    

#### `homing-v1! ( speed ch n -- )`

Set homing speed 1 of drive channel `ch` of slave `n`.

使用 SDO 指令設定 0x6099:0x01 homing speed for switch.

命令範例:   
    
    1000 2 3 homing-v1!  

#### `homing-v2! ( speed ch n -- )`

Set homing speed 2 of drive channel `ch` of slave `n`.

使用 SDO 指令設定 0x6099:0x02 homing speed for zero.

命令範例:   
    
    1000 2 3 homing-v2!  


#### `profile-a1! ( acceleration ch n -- )`

Set profile acceleration of drive channel `ch` of slave `n`.

使用 SDO 指令設定 0x6083:0x00 profile acceleration。在驅動器 PP 與 PV Mode 時的加速度。

命令範例:   
    
    1000 2 3 profile-a1!  

#### `profile-a2! ( deceleration ch n -- )`

Set profile deceleration of drive channel `ch` of slave `n`

使用 SDO 指令設定 0x6084:0x00 profile deceleration。在驅動器 PP 與 PV Mode 時的減速度。

命令範例:   
    
    1000 2 3 profile-a2!  

#### `profile-v! ( velocity ch n -- )`

Set profile velocity of drive channel `ch` of slave `n`

使用 SDO 指令設定 0x6081:0x00 profile velocity。在驅動器 PP Mode 時的最大的規劃速度。

命令範例:   
    
    1000 2 3 profile-v! 

#### `drive-fault? ( ch n -- flag)`

Has drive fault of channel `ch` of slave `n`

#### `until-no-fault ( ch n -- )`

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


#### `drive-op? ( ch n -- flag)`

Is dive servo-on of channel `ch` of slave `n`

#### `until-servo-on ( ch n -- )`

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

#### pp-test 範例 

    : pp-test
        pp 2 3 op-mode!          \ 切換到 PP Mode
        until-no-requests        \ 等待 op-mode! 命令實際設定到驅動器
        2 3 reset-fault          \ 解除驅動器異警
        2 3 until-no-fault        \ 等待解除驅動器異警完成  
        2 3 servo-on             \ Servo On 
        2 3 until-servo-on       \ 等待 Servo on 程序完成
        1000 2 3 target-p!       \ Set target position to 1000
        2 3 go                   \ Start
        2 3 until-target-reached \ 等待到達目標點
    ;
    
    deploy pp-test ;deploy       \ 在背景執行 pp-test


#### `drive-dins@ ( ch n -- dins )`

將 drive channel `ch` of slave `n` 的驅動器之數位輸入資訊放到整數堆疊上。


#### `drive-org? ( ch n -- org )`

將 drive channel `ch` of slave `n` 的驅動器之 home switch 狀態放到整數堆疊上。

#### `drive-nl? ( ch n -- nl )`

將 drive channel `ch` of slave `n` 的驅動器之負向極限開關狀態放到整數堆疊上。

#### `drive-pl? ( ch n -- pl )`

將 drive channel `ch` of slave `n` 的驅動器之正向極限開關狀態放到整數堆疊上。

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


### Job Operation

針對軸組運動使用。Job 指的是所有軸組合作完成的工作。

#### `start-job (--)`

Start job.

#### `stop-job (--)`

Stop job.

#### `ems-job (--)`

Emergency stop job.

#### `-job (--)`

Reset job.

###  Axis Group

#### System

#### `.motion (--)`
    
Print information of motion. 

只能透過 Json API 設定。 
 
命令範例:   
    
    .motion
 
回傳訊息：
    
    period_us|2000
    |group_capacity|7
    |axis_capacity|10 

#### Group

#### `gvmax! ( g -- ) ( F: v -- )`

Set vmax of group (g).

命令範例： 設定 Group 2 的最高速度為  1000.0 mm/min
    
    1000.0e mm/min 2 gvmax!

#### `gamax! ( g -- ) ( F: a -- )`

Set amax of group (g).


命令範例： 設定 Group 2 的最大加速度為  2.0 m/s^2
    
    2.0e 2 gamax!


#### `gjmax! ( g -- ) ( F: j -- )`

Set jmax of group (g).

命令範例： 設定 Group 2 的最大加加速度為  40.0 m/s^3
    
    40.0e 2 gjmax!


#### `map1d ( x g -- )`

Set axis mapping (x) of group (g). The group shall be Group1D.

命令範例： 設定 Group 2 的輸出軸為 Axis 3
    
    3 2 map1d    
   
#### `map2d ( x y g -- )`

Set axis mapping (x, y) of group (g). The group shall be Group2D.


命令範例： 設定 Group 2 的輸出軸為 Axis 3, 5
    
    3 5 2 map2d    

#### `map3d ( x y z g -- )`

Set axis mapping (x, y, z) of group (g). The group shall be Group3D.

命令範例： 設定 Group 2 的輸出軸為 Axis 3, 5, 6
    
    3 5 6 2 map3d  


#### `.grpcfg ( g -- )`

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

#### Axis

#### `enc-ppu! ( j --) ( F: ppu -- )`

Set encoder ppu (pulses_per_unit) of axis j.
  

命令範例可以參考 `enc-u!` 

#### `enc-u! ( u j -- )`

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

#### `enc-dir! ( dir j -- ) `

Set encoder direction of axis j.

當機器的軸向與馬達的運轉方向定義相反時可以藉由此參數來轉換。

dir 可以設定的值為：

* 1: 同方向
* -1: 反方向

命令範例： 設定 Axis 3 編碼器方向
    
    1 3 enc-dir!

#### `hmofs! ( j -- ) ( F: ofs -- )`

Set home offset of axis j.

可以用來調整運動軸與驅動器命令位置的位置偏移量。  

    drive_command = axis_command - home_offset;
    drive_pulse_command = drive_command/encoder_resolution*encoder_direction;

命令範例： 設定 Axis 3 home offset
    
    0.5e 3 hmofs!
    
#### `axis-vmax! ( j -- ) ( F: vmax -- )`

設定運動軸的最大速度


命令範例1： 設定 Axis 3 vmax 為 0.5 m/s
    
    0.5e 3 axis-vmax!


命令範例2： 設定 Axis 3 vmax 為 0.5 mm/min
    
    0.5e mm/min 3 axis-vmax!

#### `axis-amax! ( j -- ) ( F: amax -- )`

設定運動軸的最大加速度


命令範例： 設定 Axis 3 amax 為 2.0 m/s^2
    
    2.0e 3 axis-amax!


#### `slave-axis! ( slave j -- )`

設定運動軸 `j` 對應到的 EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Slave Position 為 2
     
    2 3 slave-axis!

#### `channel-axis! ( ch j -- )`

設定運動軸 `j` 對應到的 Channel `ch` of EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Channel of EtherCAT Slave 為 1
     
    1 3 slave-axis!    
    
#### `.axiscfg ( j -- )`

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
    
#### Path Planning Commands for All Dimensions

#### `group! ( n -- )`

Select group `n`, `n` start by 1.

與 group 的命令，必須要利用此命令進行 group 的切換。命令範例參考 `group@`

#### `group@ ( -- n )`

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


#### `0path`

Clear path.

命令範例1:
    
    0path           \ 清除當下 Group 的路經
    
命令範例2:
          
    1 group! 0ptah  \ 清除 Group 1 的路經      

#### `feedrate! ( F: v -- )`

Set programmed segment feedrate. `v` shall be > 0.

命令範例1:
    
    100.0e mm/min feedrate!           \ 設定當下 Group 的 segment feedrate 為 100.0 mm/min      

命令範例2:

    1 group!  100.0e mm/min feedrate! \ 設定 Group 1 的 segment feedrate 為 100.0 mm/min 


#### `feedrate@ ( F: -- v )`

Get programmed segment feedrate. 

命令範例1:

    feedrate@
    
命令範例2:
    
    1 group! feedrate@


#### `+coordinator`

Enable coordinator.

由 Botnana-Control 進行軸運動控制，Botnana-Control會運行軸組的路徑規劃與位置補間。
在此模式之下，驅動器必須要切換到 CSP Mode。

命令範例:
    
    +coordinator

#### `-coordinator`

Disable coordinator.

命令範例:
    
    -coordinator


#### `+group`

Enable current group.

命令範例1:

    +group
    
命令範例2:
    
    1 group! feedrate@
    

#### `-group`

Disable current group.


#### `vcmd! ( F: v -- )`

Set execution velocity command. 

命令範例: 設定運動速度為 100.0 mm/min

    100.0e mm/min vcmd!

**TODO: 提供 V < 0 的運動能力 （沿路徑後退）**

#### `gend? ( -- flag )`

Has path of current group ended ?

#### `gstop? ( -- flag )`

Has path of current group stopped ?

#### `empty? ( -- flag)`

Is path of current group empty?

#### `end? ( -- flag)`

Has path of all groups of coordinator ended ?

#### `stop? ( -- flag)`

Has path of all groups of coordinator stopped ?

#### 1D Path Planning

Current axis group should be 1D for the following commands to work without failure.

#### `move1d ( F: x -- )` 

    Declare the current absolute coordinate to be `x`. (G92)

#### `line1d ( F: x -- )` 

    Add a line to `x` into path.
    
#### 範例 test-1d
    
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

    
#### 2D Path Planning

Current joint group should be 2D for the following commands to work without failure.

#### `move2d ( F: x y -- )`

Declare the current absolute coordinate to be `(x, y)`. (G92)

#### `line2d ( F: x y -- )`

Add a line to `(x, y)` into path.

#### `arc2d ( n -- )( F: cx cy x y -- )`

Add an arc to `(x, y)` with center `(cx, cy)` into path.

`n` 不可以為 0, 如果 n > 0 表示逆時針運動，n < 0 表示順時針運動。

#### 範例 test-2d
    
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

#### 3D Path Planning

Current joint group should be 3D for the following commands to work without failure.

#### `move3d ( F: x y z -- )`

Declare the current absolute coordinate to be `(x, y, z)`. (G92)

#### `line3d ( F: x y z -- )`

Add a line to `(x, y, z)` into path.

#### `helix3d ( n -- )( F: cx cy x y z -- )`

Add a helix to `(x, y, z)` with center `(cx, cy)` into path. If z is the current z, the added curve is an arc.

`n` 不可以為 0, 如果 n > 0 表示逆時針運動，n < 0 表示順時針運動。

#### 範例 test-3d
    
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


#### 4D Path Planning (TODO)

Current joint group should be 4D for the following commands to work without failure.

* `move4d ( F: x y z c -- )` Declare the current absolute coordinate to be `x, y, z, c`. (G92)
* `line4d ( F: x y z c -- )` Add a line to `(x, y, z, c)` into path.

#### 5D Path Planning (TODO)

Current joint group should be 5D for the following commands to work without failure.

* `move5d ( F: x y z a b -- )` Declare the current absolute coordinate to be `x, y, z, a, b`. (G92)
* `line5d ( F: x y z a b -- )` Add a line to `(x, y, z, a, b)` into path.

#### 6D Path Planning (TODO)

Current joint group should be 6D for the following commands to work without failure.

* `move6d ( F: x y z a b c -- )` Declare the current absolute coordinate to be `x, y, z, a, b, c`. (G92)
* `line6d ( F: x y z a b c -- )` Add a line to `(x, y, z, a, b, c)` into path.


#### 插值後加減速

命令針對單一運動軸，可以同時讓多個運動軸同時運行。如果該運動軸受到軸組控制則不可執行插值後加減速機制。  

#### `+interpolator ( j -- )`

啟動 Axis `j` 插值後加減速機制。

#### `-interpolator ( j -- )`

關閉 Axis `j` 插值後加減速機制。如果插值器運作中，會以當下的位置開始減速到 0。

#### `interpolator-v! ( j -- )（ F: v -- ）` 

設定 Axis  `j` 插值器得最大運動速度。
 
#### `axis-cmd-p! ( j -- )( F: pos --)`

設定 Axis  `j` command position

#### 插值後加減速範例

以 Axis 1 為例：

    1  +interpolator                 \ 啟動 Axis 1 插值後加減速
    100.0 mm/min  1  interpolator-v! \ 設定 Axis 1 插值速度為 100.0 mm/min
    0.3 1 axis-cmd-p!                \ 設定 Axis 1 的目標位置為座標位置 0.3 m 

#### 運動軸追隨


#### `axis-demand-p@ ( j -- )( F: -- pos )`

取得 Axis j 的命令位置 

#### `axis-real-p@ ( j -- )(F: -- pos )`

取得 Axis j 的實際位置 

#### 命令範例：

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


#### Information

#### `.group ( g -- )`

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
    
    
#### `.axis ( j -- )`

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

### CPU Timing Profiler

#### `.cpu-timing`

Print information of CPU timing

#### `0cpu-timing`

Reset CPU timing

### misc

#### `.verbose`

Print verbose infornatiom

回傳訊息範例 :

    version_number|1.3.1|period_us|2000|launch_time|2018-08-09T10:19:21Z

