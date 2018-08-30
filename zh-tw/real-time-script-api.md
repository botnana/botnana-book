# Real-time Script API

Botnana Control 在其 real-time event loop 中使用了 Forth VM 以滿足更複雜的程式需求。透過 Forth 執行的命令會立刻影響裝置的行為。一般使用者並不需要使用此一 API。

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

* `.slave ( n -- )` Print information of slave n
    
    以第2個 slave 為士林電機 SDP 驅動器為例：
    
    命令範例: `2 .slave`
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
    
    
    其中的 (單位會因驅動器而有不同)
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
      

* `.slave-diff ( n -- )` Print information difference of slave n
    
    
    使用者可以使用 `.slave` 取得所有參數。使用 `.slave-diff` 取得自上次執行 `.slave`
    或是 `.slave-diff` 後被改變的狀態。 如果上次執行 `.slave` 或 `.slave-diff` 後狀態都沒有改變，
    回傳資料為空字串。
    
    命令範例: `2 .slave-diff`
    

* `list-slaves ( -- )` Scan slaves

    測試範例： 第 1 個 slave 為台達電 A2-E驅動器 , 第 2 個 slave 為士林電機驅動器, 
    命令範例: `list-slaves`
    回傳訊息： 
    
    slaves|477,271601776,1468,1
    
    台達電 A2-E  vendor_id = 477 (0x1DD)
                product_code =  271601776 (0x10305070)
    士林電機 SDP vendor_id = 1468 (0x5BC)
                product_code =  1 (0x1)          

* `.sdo ( n --)`  Print SDO information of slave n

    命令範例: `2 .sdo` 輸出第 2 個 slave SDO Request 的結果
    回傳訊息：
    
    sdo_index.2|0x6041
    |sdo_subindex.2|0x00
    |sdo_error.2|false
    |sdo_busy.2|false
    |sdo_data.2|24
    |sdo_data_hex.2|0x0018
    
    以 sdo_index.2 為例, .2 表示第 2 個 slave。
    do_index   : EtherCAT Object index。
    sdo_subindex: EtherCAT Object subindex。
    sdo_error   : 此 sdo request 是否有問題,
                  可能原因有 sdo_index 錯誤, 資料型態錯誤 ... 等等。
    sdo_busy    : 此 sdo request 是否還在處理中。
    sdo_data    : 該 位址 （index:subindex）的值。
    sdo_data_hex: 以 16 進位表示該位址的值。

* `sdo-upload-i32 ( subindex index n --)`  Upload data (i32) of index:subidex from slave n by SDO

    命令範例: `0 $6064 2 sdo-upload-i32 ` 使用 SDO 讀取 0x6064::0x00 在 slave 2 的值 
             假設 slave 2 是驅動器, 0 表示 subindex, $6064 表示 index ($表示 16進位)
             0x6064:0x00 的位址表示是 Position Actual Value 其型態是Integer 32 型態，
             可以由此指令讀回 Position Actual Value             

* `sdo-upload-i16 ( subindex index n --)`  Upload data (i16) of index:subidex from slave n by SDO
* `sdo-upload-i8  ( subindex index n --)`  Upload data (i8) of index:subidex from slave n by SDO
* `sdo-upload-u32 ( subindex index n --)`  Upload data (u32) of index:subidex from slave n by SDO
* `sdo-upload-u16 ( subindex index n --)`  Upload data (u16) of index:subidex from slave n by SDO
* `sdo-upload-u8  ( subindex index n --)`  Upload data (u8) of index:subidex from slave n by SDO
* `sdo-download-i32 ( data subindex index n --)`  Download data (i32) of index:subidex to slave n by SDO

    命令範例: `100 0 $60FF 2 sdo-download-i32 ` 使用 SDO 設定 0x60FF::0x00 在 slave 2 的值為 100 
             假設 slave 2 是驅動器, 0 表示 subindex, $60FF 表示 index ($表示 16進位)
             0x60FF:0x00 的位址表示是 target velocity 其型態是Integer 32 型態，
             可以由此指令設定 target velocity            

* `sdo-download-i16 ( data subindex index n --)`  Download data (i16) of index:subidex to slave n by SDO
* `sdo-download-i8 ( data subindex index n --)`  Download data (i8) of index:subidex to slave n by SDO
* `sdo-download-u32 ( data subindex index n --)`  Download data (u32) of index:subidex to slave n by SDO
* `sdo-download-u16 ( data subindex index n --)`  Download data (u16) of index:subidex to slave n by SDO
* `sdo-download-u8 ( data subindex index n --)`  Download data (u8) of index:subidex to slave n by SDO
* `sdo-data@ ( n -- data)`  Fetch SDO data of slave n to stack

     命令範例: `2 sdo-data@` 將 sdo-upload-i32,
                              sdo-upload-i16,
                              sdo-upload-i8,
                              sdo-upload-u32,
                              sdo-upload-u16,
                              sdo-upload-u8,
                              sdo-download-i32
                              sdo-download-i16
                              sdo-download-i8
                              sdo-download-u32
                              sdo-download-u16
                              sdo-download-u8 命令所讀取或是設定的值取出放入整數堆疊
                                                              
* `sdo-error? ( n -- flag)`  Fetch error flag of SDO data of slave n to stack
    
    命令範例: `2 sdo-error?` 

* `sdo-busy? ( n -- flag)`  Fetch busy flag of SDO data of slave n to stack
    
    命令範例: `2 sdo-busy?` 
   

### EtherCAT IO primitives

* `ec-dout@ ( channel n -- t=on )` Get DOUT from EtherCAT slave n

    命令範例: `2 3 ec-dout@` 將 Slave 3 的 Channel 2 DO 狀態放到等數堆疊。 

* `ec-dout! ( t=on channel n -- )` Set DOUT of EtherCAT slave n

    命令範例: `1 2 3 ec-dout@` 將 Slave 3 的 Channel 2 DO 設定為 1。 
    命令範例: `0 2 3 ec-dout@` 將 Slave 3 的 Channel 2 DO 設定為 0。 

* `ec-din@ ( channel n -- t=on )` Get DIN from EtherCAT slave n

    命令範例: `3 5 ec-din@` 將 Slave 5 的 Channel 3 DI 狀態放到等數堆疊。 


* `-ec-aout ( channel n )` Disable AOUT of EtherCAT slave n

    命令範例: `1 2 -ec-aout` 將 Slave 2 的 Channel 1 AO 禁能。 

* `+ec-aout ( channel n )` Enable AOUT of EtherCAT slave n

    命令範例: `1 2 +ec-aout` 將 Slave 2 的 Channel 1 AO 致能。 

* `ec-aout@ ( channel n -- value )` Get AOUT from EtherCAT slave n

    命令範例: `1 2 ec-aout@` 將 Slave 2 的 Channel 1 AO data 放到整數堆疊。 

* `ec-aout! ( value channel n -- )` Set AOUT of EtherCAT slave n

    命令範例: `100 1 2 ec-aout!` 將 Slave 2 的 Channel 1 AO data 設定為 100。 

* `-ec-ain ( channel n )` Disable AIN of EtherCAT slave n

    命令範例: `1 6 -ec-ain` 將 Slave 6 的 Channel 1 AI 禁能。 

* `+ec-ain ( channel n )` Enable AIN of EtherCAT slave n

    命令範例: `1 6 +ec-ain` 將 Slave 6 的 Channel 1 AI 致能。 

* `ec-ain@ ( channel n -- value )` Get AIN from EtherCAT slave n

    命令範例: `1 6 ec-ain@` 將 Slave 6 的 Channel 1 AI data 放到整數堆疊。 

### EtherCAT Drive primitives

和設定檔的 API 不同，此法設定的參數會立即生效。

* `op-mode! ( mode ch n -- )` Set operation mode of channel `ch`  slave `n`
    
    mode 的設定值如下：
        1: Profile Position Mode
        3:
    

* `pds-goal! ( goal channel n -- )` Set PDS goal of slave n
* `reset-fault ( channel n -- )` Reset fault for slave n
* `go ( channel n -- )` Set point for slave n
* `target-p! ( p channel n -- )` Set target position of slave n
* `target-v! ( v channel n -- )` Set target velocity of slave n
* `target-reached? ( channel n -- t=reached )` Has slave n reached its target position?
* `home-offset! ( offset channel n -- )` Set home offset of slave n
* `homing-a! ( acceleration channel n -- )` Set homing acceleration of slave n
* `homing-method! ( method channel n -- )` Set homing method of slave n
* `homing-v1! ( speed channel n -- )` Set homing speed 1 of slave n
* `homing-v2! ( speed channel n -- )` Set homing speed 2 of slave n
* `profile-a1! ( acceleration channel n -- )` Set profile acceleration of slave n
* `profile-a2! ( deceleration channel n -- )` Set profile deceleration of slave n
* `profile-v! ( velocity channel n -- )` Set profile velocity of slave n
* `servo-on ( channel n -- )` Servo on of slave n
* `servo-off ( channel n -- )` Servo off of slave n
* `servo-stop ( channel n --)` Servo stop of slave n

### Sine Wave Trajectory

* `sine-start (n --)` Start sine wave trajectory of slave n
* `sine-stop (n --)` Stop sine wave trajectory of slave n
* `sine-ems (n --)` Emergency stop sine wave trajectory of slave n
* `sine-forth (n --)` Sine Wave trajectory forth of slave n
* `sine-p@ (n --)(F: -- p)` Get sine wave trajectory position of slave n
* `sine-v@ (n --)(F: -- v)` Get sine wave trajectory velocity of slave n
* `sine-running? (n -- running)` Is sine wave trajectory running of slave n
* `sine-cfg! (n -- )(F: freq start-pos amplitude)` Set sine wave trajectory parameters of slave n
* `sine-f! (n -- )(F: freq)` Change running frequency of sine wave trajectory of slave n
* `sine-amp! (n -- )(F: amplitude)` Change running amplitude of sine wave trajectory of slave n


### Start, Stop and Reset

* `start (--)` start 
* `stop (--)` stop
* `ems (--)` emergency stop
* `reset-job (--)` reset job

##### Configuration

**For System**

* `.motion (--)`  Print information of motion. Example of return message: `period_us|2000|group_capacity|7|joint_capacity|10` 

**For Group**

* `gvmax! (g --) (F: v)` Set vmax of group (g).
* `gamax! (g --) (F: a)` Set amax of group (g).
* `gjmax! (g --) (F: j)` Set jmax of group (g).
* `map1d (x g --)` Set axis mapping (x) of group (g). The group shall be Group1D.   
* `map2d (x y g --)` Set axis mapping (x, y) of group (g). The group shall be Group2D.
* `map3d (x y z g --)` Set axis mapping (x, y, z) of group (g). The group shall be Group3D.
* `.grpcfg (g --)`  Print information of group g. Example of `1 .grpcfg`, return message : `group_name.1|BotnanaGo|group_type.1|1D|group_mapping.1|1|group_vmax.1|0.100|group_amax.1|5.000|group_jmax.1|80.000`  

**For Axis**

* `enc-ppu! (j --) (F: ppu --)` Set encoder ppu (pulses_per_unit) of axis j.
* `enc-u! (u j --) ` Set encoder length unit of axis j. `u = 0 as Meter, u = 1 as Revolution, u = 2 as Pulse`
* `enc-dir! (dir j --) ` Set encoder direction of axis j.
* `hmofs! (j --) (F: ofs --)` Set home offset of axis j.
* `.axiscfg (j --)`  Print information of axis j. Example of `1 .axiscfg`, return message : `axis_name.1|X|axis_home_offset.1|0.0500|encoder_ppu.1|120000.00000|encoder_length_unit.1|Meter|encoder_direction.1|-1`
`.    

#### Path Planning Commands for All Dimensions

* `group! ( n -- )` Select group `n`, `n` start by 1.
* `group@ ( n -- )` Get current group index `n`.
* `0path` ( -- ) Clear path.
* `feedrate! ( F: v -- )` Set programmed segment feedrate. `v` > 0.
* `feedrate@ ( F: -- v )` Get programmed segment feedrate. 
* `+coordinator (--)` Enable coordinator.
* `-coordinator (--)` Disable coordinator.
* `+group (--)` Enable current group.
* `-group (--)` Disable current group.
* `vcmd! ( F: v -- )` Set execution velocity command.`v` can be negataive.
* `gend? (-- flag )` Has path of current group ended ?
* `gstop? (-- flag )` Has path of current group stopped ?
* `empty? (-- flag)` Is path of current group empty?
* `end? (-- flag)` Has path of all groups of coordinator ended ?
* `stop? (-- flag)` Has path of all groups of coordinator stopped ?

#### 1D Path Planning

Current axis group should be 1D for the following commands to work without failure.

* `move1d (F: x -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line1d (F: x -- )` Add a line to `x` into path.

#### 2D Path Planning

Current joint group should be 2D for the following commands to work without failure.

* `move2d (F: x y -- )` Declare the current absolute coordinate to be `(x, y)`. (G92)
* `line2d (F: x y -- )` Add a line to `(x, y)` into path.
* `arc2d ( n --)(F: cx cy x y -- )` Add an arc to `(x, y)` with center `(cx, cy)` into path.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 3D Path Planning

Current joint group should be 3D for the following commands to work without failure.

* `move3d (F: x y z -- )` Declare the current absolute coordinate to be `(x, y, z)`. (G92)
* `line3d (F: x y z -- )` Add a line to `(x, y, z)` into path.
* `helix3d ( n --)(F: cx cy x y z -- )` Add a helix to `(x, y, z)` with center `(cx, cy)` into path. If z is the current z, the added curve is an arc.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 4D Path Planning (TODO)

Current joint group should be 4D for the following commands to work without failure.

* `move4d (F: x y z c -- )` Declare the current absolute coordinate to be `x, y, z, c`. (G92)
* `line4d (F: x y z c -- )` Add a line to `(x, y, z, c)` into path.

#### 5D Path Planning (TODO)

Current joint group should be 5D for the following commands to work without failure.

* `move5d (F: x y z a b -- )` Declare the current absolute coordinate to be `x, y, z, a, b`. (G92)
* `line5d (F: x y z a b -- )` Add a line to `(x, y, z, a, b)` into path.

#### 6D Path Planning (TODO)

Current joint group should be 6D for the following commands to work without failure.

* `move6d (F: x y z a b c -- )` Declare the current absolute coordinate to be `x, y, z, a, b, c`. (G92)
* `line6d (F: x y z a b c -- )` Add a line to `(x, y, z, a, b, c)` into path.


#### Information

* `.group (g --)` Print information of group g. Example of `1 .group`, return message : `group_enabled.1|false|group_stopping.1|true|move_count.1|0|path_event_count.1|0|focus.1|0|source.1|0|pva.1|0.00000,0.00000,0.00000|move_length.1|0.00000|total_length.1|0.00000|feedrate.1|0.000|vcmd.1|0.000|max_look_ahead_count.1|0|ACS.1|0.00000|PCS.1|0.00000`
* `.axis (j --)` Print information of axis j. Example of `1 .axis`, return message : `axis_command_position.1|0.00000|axis_corrected_position.1|0.00000|encdoer_position.1|-0.05000|following_error.1|0.00000`

### CPU Timing

* `.cpu-timing ( -- )` Print information of CPU timing
* `0cpu-timing ( -- )` Reset CPU timing

### Internal testing primitives

* `tester-chkusb ( -- )` Test USB memory stick
* `tester-chkusd ( -- )` Test microSD
* `-tester ( -- )` Disable all tester outputs
* `+tester ( -- )` Enable all tester outputs
* `tester-high ( -- )` Set all tester outputs to high
* `tester-low ( -- )` Set all tester outputs to 0V

### misc

* `.verbose ( -- )` Print verbose infornatiom

