### EtherCAT Drive 指令集

EtherCAT 驅動器通常都會符合 CiA 402 規範，此規範定義了驅動器的操作模式與介面。實際上驅動器並不會實現所有 CiA 402 規範提到的所有功能，在選用驅動器時還是要留意。

目前 Botnana Control 支援以下幾種驅動器的運動模式：

* 位置控制模式 PP (Profile Position Mode）
* 速度控制模式 PV (Profile Velocity Mode）
* 原點復歸模式 HM (Homing mode)
* 扭力控制模式 TQ (Profile  Torque Mode)
* 週期同步位置模式 CSP (Cyclic Sync Position Mode)
* 週期同步速度模式 CSV (Cyclic Sync Velocity Mode)
* 週期同步扭力模式 CST (Cyclic Sync Torque Mode)

就應用面來看週期同步模式適合用來做多軸同動或是特殊的軌跡規劃。

**位置模式方塊圖：**

```
               +--------+
               | +----> |----------------------- +
               | |CSP   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Position    |-->o--->|  Position |----> Control
Position       |  PP    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Seletor

```

**速度模式方塊圖：**

```
               +--------+
               | +----> |----------------------- +
               | |CSV   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Velocity    |-->o--->|  Velocity |----> Control
Velocity       |  PV    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Seletor

```

**扭力模式方塊圖：**

```
               +--------+
               | +----> |----------------------- +
               | |CST   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Torque      |-->o--->|  Torque   |----> Control
Torque         |  TQ    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Seletor

```

**原點復歸模式**：以下是幾種常見的復歸方法，每一種驅動器必須依該廠家的所支援的方法為準。

* Method 1 and 2 : Homing on the limit switch and index pulse

依據所選擇的負/正方向，原點位置在遇到 limit switch 反轉後最靠近的 index pulse。

```
++                    ++                     ++
||--------------------||---------------------||
||--------------------||---------------------||
++                    ++                     ++
                       |
     +-----------------|
     |.     .          |
     +-----(1)->
      .     .
      .     |         |       |    Index Pulse
------------+---------+-------+----------------
------+
      |                    Negativ Limit Switch
      +----------------------------------------
                       |             .   .
                       |-------------------+
                       |             .   . |
                                  <-(2)----+
                                     .   .
                                     .   .
Index Pulse            |       |     |   .
-----------------------+-------+-----+----------
                                         +------
Positive Limit Switch                    |
-----------------------------------------+
```

* Methods 3 to 6: Homing on the home switch and index pulse

依據所選擇的負/正方向與方法，原點位置在遇到 home switch 後最靠近的 index pulse。

```
++                                           ++
||-------------------------------------------||
||-------------------------------------------||
++                                           ++
    |
    |------------------+
    |            .    .|   .
              <-(3)----+   .
                 .    .    .             |
              <-(3)----------------------|
                 .    .    .             |
    |            .    .    .
    |---------------------(4)->
    |            .    .    .             |
                 .   +-------------------|
                 .   |.    .             |
                 .   +----(4)->
                 .    .    .
Index Pulse      |    .    |
-----------------+----------------------------
                      +-----------------------
Home Switch           |
----------------------+
     |             .   .    .
     |---------------------(5)->
     |             .   .    .            |
                   .  +------------------|
                   .  |.    .            |
                   .  +----(5)->
     |             .   .    .
     |------------------+   .
     |             .   .|   .
                <-(6)--.+   .
                   .   .    .              |
                <-(6)----------------------|
                   .   .    .              |
Index Pulse        |   .    |
-------------------+--------+--------------------
Home Switch            .
-----------------------+
                       |
                       +-------------------------
```

* Methods 7 to 10: Homing on positive limit switch, home switch and index pulse

與 Methods 3 to 6 的方法類似，遇到正極限開關後反轉，會依其設定方式尋找 index pulse。

```
++                                                                ++
||----------------------------------------------------------------||
||----------------------------------------------------------------||
++                                                                ++
    |           .     .      .           .      .         .
    |--------------------------------------------+------(10)->
    |           .     .      .           .      .|        .
    |------------------+----(8)->     <-(9)------+        .
                .     .|     .           .      .         .
             <-(7)-----+     .           .      .         .
                .     .      .     |     .      .         .
             <-(7)---+-------------+-------------+------(10)->
                .    |.      .     |     .      .|        .
                .    +------(8)->     <-(9)------+        .
                .     .      .           .      .       | .  .
                .     .      .           .      .       |-----+
                .     .      .           .      .       | .  .|
                .     .      .           .      .         .  .|
             <-(7)---+----------------------------------------+
                .    |.      .           .      .         .  .|
                .    +------(8)->     <-(9)----+--------------+
                .     .      .           .     |.         .  .
                .     .      .           .     +--------(10)->
                .     .      .           .      .         .  .
Index Pulse     |     .      |           |      .         |  .
-------------------------------------------------------------------
                      +-------------------------+            .
Home Switch           |                         |            .
----------------------+                         +------------------
                                                             +-----
Positive Limit Switch                                        |
-------------------------------------------------------------+
```

* Methods 11 to 14: Homing on negative limit switch, home switch and index pulse

與 Methods 3 to 6 的方法類似，遇到附極限開關後反轉，會依其設定方式尋找 index pulse。

```
++                                                                       ++
||-----------------------------------------------------------------------||
||-----------------------------------------------------------------------||
++                                                                       ++
                  .      .     .           .      .      .         |
              <-(14)----+-------------------------.----------------|
                  .     |.     .           .      .      .         |
                  .     +-----(13)->   <-(12)---+-.----------------|
                  .      .     .           .    | .      .         |
                  .      .     .           .    +-.-----(11)->
                  .      .     .     |     .      .      .
              <-(14)----+------------+-------------+----(11)->
                  .     |.     .     |     .      .|     .
                  .     +-----(13)->   <-(12)------+     .
       .     |    .      .     .           .      .      .
      +------|    .      .     .           .      .      .
      |.     |    .      .     .           .      .      .
      |.          .      .     .           .      .      .
      +--------------------------------------------+----(11)->
      |.          .      .     .           .      .|     .
      +-------------------+---(13)->   <-(12)------+     .
       .          .      .|    .           .      .      .
       .      <-(14)------+    .           .      .      .
       .          .      .     .           .      .      .
Index Pulse       |      .     |           |      .      |
---------------------------------------------------------------------
       .                 +------------------------+
Home Switch              |                        |
+------------------------+                        +------------------
       +-------------------------------------------------------------
       |                                      Negative Limit Switch
+------+
```

* Methods 17 and 18: Homing on limit switch without an index pulse

依據所選擇的負/正方向，原點位置在 limit switch 上。

```
 ++                 ++                        ++
 ||-----------------||------------------------||
 ||-----------------||------------------------||
 ++                 ++                        ++
       .             |
    +----------------|
    |  .             |
    +-(17)->
       .
 ------+
       |                    Negative Limit Switch
       +-----------------------------------------
                      |                   .
                      |-----------------------+
                      |                   .   |
                                       <-(18)-+
                                          .
                                          +------
Positive Limit Switch                     |
------------------------------------------+
```

* Methods 19 to 22: Homing on home switch without an index pulse

依據所選擇的負/正方向與方式，原點位置在 home switch 上。

```
 ++    ++                                     ++
 ||----||-------------------------------------||
 ||----||-------------------------------------||
 ++    ++                 .                   ++
       |                  .
       |-------------------------+
       |                  .      |
                      <-(19)-----+
                          .            |
                      <-(19)-----------|
       |                  .            |
       |----------------(20)->
       |                  .            |
                  +--------------------|
                  |       .            |
                  +-----(20)->
                          .
                          +--------------------
Home Switch               |
--------------------------+

 ++    ++                                     ++
 ||----||-------------------------------------||
 ||----||-------------------------------------||
 ++    ++                 .                   ++
       |                  .
       |----------------(21)->
       |                  .            |
                  +--------------------|
                  |       .            |
                  +-----(21)->
       |                  .
       |-------------------------+
       |                  .      |
                      <-(22)-----+     |
                      <-(22)-----------|
                          .            |
Home Switch               .
--------------------------+
                          |
                          +--------------------
```

* Methods 33 and 34: Homing on the index pulse

依據所選擇的負/正方向，原點位置在最靠近目前位置的 index pulse。

```
++                   ++                      ++
||-------------------||----------------------||
||-------------------||----------------------||
++                   ++                      ++
                .     |     .
           <--(33)----|     .
                .     |---(34)--->
                .     |     .
 Index Pulse    .           .
    |           |           |            |
 -------------------------------------------------
```

* Methods 35 and 37: Homing on current position

原點位置就在目前位置。

```
++                   ++                      ++
||-------------------||----------------------||
||-------------------||----------------------||
++                   ++                      ++
                    (35)
                    (37)
```
---
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

#### `pp ( -- 1 )`

將 1 放入整數堆疊

命令範例: 等同於 `1 2 3 op-mode!`

    pp 2 3 op-mode! 

#### `pv ( -- 3 )`

將 3 放入整數堆疊    

#### `hm ( -- 6 )`

將 6 放入整數堆疊    

命令範例: 等同於 6 2 3 op-mode!  

    hm 2 3 op-mode! 。    

#### `csp ( -- 8 )`

將 8 放入整數堆疊            

#### `drive-on ( ch n -- )`

Drive on of channel `ch` of slave `n`

使用 PDO 指令搭配有限狀態機。    

命令範例: 將 slave 3 drive channel 2 的驅動器 drive on。
    
    2 3 drive-on    

#### `drive-off ( ch n -- )`

Drive off of channel `ch` of slave `n`

#### `drive-stop ( ch n -- )`

Drive stop of channel `ch` of slave `n`

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

#### `until-target-reached ( ch n -- )`

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

#### `drive-fault? ( ch n -- flag )`

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

#### `drive-on? ( ch n -- flag )`

Is dive-on of channel `ch` of slave `n` ?

#### `until-drive-on ( ch n -- )`

Until drive-on of channel `ch` of slave `n`

相當於

    : until-drive-on ( channel slave -- )
        ." log|" over over swap . . ." until-drive-on" cr
        pause pause pause pause pause pause
        begin
            over over drive-on? not
        while
            pause
        repeat
        drop drop ;

#### pp-test 範例

    : pp-test
        pp 2 3 op-mode!          \ 切換到 PP Mode
        until-no-requests        \ 等待 op-mode! 命令實際設定到驅動器
        2 3 reset-fault          \ 解除驅動器異警
        2 3 until-no-fault       \ 等待解除驅動器異警完成  
        2 3 drive-on             \ Drive On 
        2 3 until-drive-on       \ 等待 Drive on 程序完成
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
  
#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `op-mode!` |( mode channel n -- ) | 
| `pp` |( -- 1 ) | 
| `pv` |( -- 3 ) | 
| `tq` |( -- 4 ) | 
| `hm` |( -- 6 ) | 
| `csp` |( -- 8 ) |
| `drive-on` |( channel n -- ) | 
| `drive-off` |( channel n -- ) | 
| `drive-stop` |( channel n -- ) | 
| `reset-fault` |( channel n -- ) |
| `go` |( channel n -- ) | 
| `target-p!` |( pos channel n -- ) |
| `target-v!` |( vel channel n -- ) |       
| `target-reached?` |( channel n -- flag ) | 
| `until-target-reached` |( channel n -- ) | 
| `homing-a!` |( acc channel n -- ) | 
| `homing-method!` |( method channel n -- ) | 
| `homing-v1!` |( v1 channel n -- ) | 
| `homing-v2!` |( v2 channel n -- ) | 
| `profile-a1!` |( a1 channel n -- ) | 
| `profile-a2!` |( a2 channel n -- ) | 
| `profile-v!` |( vel channel n -- ) | 
| `drive-fault?` |( channel n -- flag ) |
| `until-no-fault` |( channel n -- ) |  
| `drive-on?` |( channel n -- flag ) |  
| `until-drive-on` |( channel n -- ) |  
| `drive-dins@` |( channel n -- dins ) |  
| `drive-org?` |( channel n -- org ) |
| `drive-nl?` |( channel n -- nl ) |
| `drive-pl?` |( channel n -- pl ) |  
| `?ec-emcy` |( n -- ) |  
| `ec-emcy-busy?` |( n -- flag ) |
| `.ec-emcy` |( n -- ) |   
| `target-tq!` |( tq channel n -- ) |
| `tq-slope` |( slope channel n -- ) |
| `drive-vmax!` |( vmax channel n -- ) |
| `+drive-homed` |( channel n -- ) |
| `-drive-homed` |( channel n -- ) | 
| `+pp-rel` |( channel n -- ) |
| `-pp-rel` |( channel n -- ) |
| `+pp-imt` |( channel n -- ) |
| `-pp-imt` |( channel n -- ) |
| `+pp-cosp` |( channel n -- ) |
| `-pp-cosp` |( channel n -- ) |
| `drive-douts!` |( douts channel n -- ) |
| `drive-douts-mask!` |( mask channel n -- ) |
| `+drive-halt` |( channel n -- ) | 
| `-drive-halt` |( channel n -- ) | 
