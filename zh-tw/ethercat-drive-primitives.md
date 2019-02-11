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

**驅動器運行狀態**

```
               +-------+
-------------->| FSA   +-------------->
Control Word   |       |   Status Word
(0x6040)       +-------+   (0x6041)
```

FSA (Finite States Automaton) of PDS (Power Drive System)

```
             Start
               |
               |
               V 0
        +-------------------+
        | Not Ready to      |
        | switch on         |
        | (Not initialized) |
        +-------------------+
               |
               |
               V 1
 +------------------------------+       +-----------+
 |         Switch on            | 15    |   Fault   |
 |         Disabled             |<------|           |
 |  (Initialization completed)  |       |  (Alarm)  |
 +------------------------------+       +-----------+
  ^ 9        |   ^ 7   ^ 10   ^ 12            ^ 14
  |          |   |     |      |               |
  |          v 2 |     |      |               |
  |  +---------------+ |      |               |
  |  |  Ready to     | |      |               |
  |  |  Switch on    | |      |               |
  |  | (Main circuit | |      |               |
  |  |  power off )  | |      |               |
  |  +---------------+ |      |               |
  |    ^ 8   |   ^ 6   |      |               |
  |    |     |   |     |      |               |
  |    |     V 3 |     |      |               |
  |    | +-------------+----+ |        +------+-----------+
  |    | |   Switched on    | |        |  Fault reaction  |
  |    | |                  | |        |     active       |
  |    | |  (Servo ready)   | |        | (Deceleration    |
  |    | +------------------+ |        |  processing)     |
  |    |     |   ^ 5          |        +------------------+
  |    |     |   |            |               ^
  |    |     v 4 |            |               | 13
+-------------------+   11 +---------------+  |
|     Operation     |----->|Quick stop     |  |
|     Enabled       |<-----|active         |  |
|              )    | 16   | (Deceleration |  |
|     (Servo on)    |      |  processing)  |  |
+-------------------+      +---------------+  |
                                              Error Occurs 
```
FSA Transition

| No | FSA Transition |
|----|-------------|
| 0  | Auto skip |
| 1  | Auto skip |
| 2  | [Shutdown] |
| 3  | [Switch On] |
| 4  | [Enable operation]
| 5  | [Disable operation]
| 6  | [Shutdown]
| 7  | [Disable voltage]
| 8  | [Shutdown]
| 9  | [Disable voltage]
| 10 | [Disable voltage]
| 11 | [Quick stop]
| 12 | [Disable voltage]
| 13 | Error Occurs
| 14 | Auto skip
| 15 | [Fault reset]
| 16 | [Enable operation]

**Control Word (0x6040:0x0)**：

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 15                                                  Bit 0

* Bit 0: Switch On
* Bit 1: Enable Voltage
* Bit 2: Quick Stop
* Bit 3: Enable Operation
* Bit 4: Operation Mode Specification
* Bit 5: Operation Mode Specification
* Bit 6: Operation Mode Specification
* Bit 7: Fault Reset
* Bit 8: Halt
* Bit 9: Operation Mode Specification
* Bit 10: Reserved
* Bit 11: Reserved
* Bit 12: Reserved
* Bit 13: Reserved
* Bit 14: Reserved
* Bit 15: Reserved

Operation Mode Specification:

| OP mode | Bit 9 | Bit 6 | Bit 5 | Bit 4 |
|---------|--------|--------|--------|--------|
| PP  | change on set-point | absolute/relative | change set immediately | new set-point |
| PV  | -- | -- | -- |
| TQ  | -- | -- | -- |
| HM  | -- | -- | start homing |
| CSP | -- | -- | --             |
| CSV | -- | -- | --             |
| CST | -- | -- | --             |


| Commnad | bit 7 | bit 3 | bit 2 | bit 1 | bit 0 | Transitions |
|---------|-------|-------|-------|-------|-------|-------------|
| Shutdown                      | 0         | - | 1 | 1 | 0 | 2,6,8
| Switch on                     | 0         | 0 | 1 | 1 | 1 | 3
| Switch on + Enable operation  | 0         | 1 | 1 | 1 | 1 | 3+4
| Enable operation              | 0         | 1 | 1 | 1 | 1 | 4,16
| Disable voltage               | 0         | - | - | 0 | - | 7,9,10,12
| Quick stop                    | 0         | - | 0 | 1 | - | 7,10,11
| Disable operation             | 0         | 0 | 1 | 1 | 1 | 5
| Fault Reset                   | 0 -> 1    | - | - | - | - | 15


**Status Word (0x6041:0x0)**：

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 15                                                  Bit 0

* Bit 0: Ready to Switch On
* Bit 1: Switched On
* Bit 2: Operation Enabled
* Bit 3: Fault
* Bit 4: Voltage Enabled
* Bit 5: Quick Stop
* Bit 6: Switch On Disabled
* Bit 7: Warning
* Bit 8: Reserved
* Bit 9: Remote
* Bit 10: Operation Mode Specification
* Bit 11: Internal Limit Active
* Bit 12: Operation Mode Specification
* Bit 13: Operation Mode Specification
* Bit 14: Reserved
* Bit 15: Reserved

Operation Mode Specification:

| OP mode | Bit 13 | Bit 12 | Bit 10 |
|---------|--------|--------|--------|
| PP  | following error | set-point acknowledge | target reached |
| PV  | --              | speed                 | target reached |
| TQ  | --              | --                    | target reached |
| HM  | homing error    | homing attained       | target reached |
| CSP | following error |                       | --             |
| CSV | --              |                       | --             |
| CST | --              |                       | --             |

FSA State:

| FSA State | Bit 6 | Bit 5 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
|-----------|-------|-------|-------|-------|-------|-------|
| Not Ready to Switch on    | 0 | - | 0 | 0 | 0 | 0 |
| Switch on Disabled        | 1 | - | 0 | 0 | 0 | 0 |
| Ready To Switch On        | 0 | 1 | 0 | 0 | 0 | 1 |
| Switch on                 | 0 | 1 | 0 | 0 | 1 | 1 |
| Operation Enabled         | 0 | 1 | 0 | 1 | 1 | 1 |
| Quick Stop Active         | 0 | 0 | 0 | 1 | 1 | 1 |
| Faut Reaction Active      | 0 | - | 1 | 1 | 1 | 1 |
| Fault                     | 0 | - | 1 | 0 | 0 | 0 |

---

#### `+drive-halt ( ch n -- )`

命令 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器功能暫停。

此時馬達會依據 0x605D (Halt option code) 設定，暫時性的減速與停止。

#### `+drive-homed ( ch n -- )`

標記 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器已經完成回歸機械原點。

此狀態為主站所提供的狀態紀錄。

#### `+pp-cosp ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 9 （Change on set-point）。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 5 （change set immediately） 為 0 時，同方向運動不減速到 0 通過中繼點。

#### `+pp-imt ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 5 （change set immediately）為 1。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 5 （change set immediately） 為 1 時，表示要通過每一個馬達驅動器所接受的目標位置。

#### `+pp-rel ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 6 （absolute/relative）為 1。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 6 （absolute/relative）為 1，馬達驅動器以相對位置來處理目標位置。

#### `-drive-halt ( ch n -- )`

命令 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器功能繼續。

參考命令 `+drive-halt`

#### `-drive-homed ( ch n -- )`

標記 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器未完成回歸機械原點。

此狀態為主站所提供的狀態紀錄。

#### `-pp-cosp ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 9 （Change on set-point）。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 5 （change set immediately） 為 0 時 （Set of set-points，通過），同方向運動減速到 0 通過中繼點。

#### `-pp-imt ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 5 （change set immediately）為 0。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 5 （change set immediately） 為 0 時，表示要馬達驅動器只朝向最後所接受的目標位置。

#### `-pp-rel ( ch n -- )`

當 EtherCAT 從站編號 `n` 第 `ch` 管道的馬達驅動器處於 PP 模式時，設定 Control Word 的 Bit 6 （absolute/relative）為 0。

細部功能請參考選用驅動器的 PP 模式描述。當 Control Word 的 Bit 6 （absolute/relative）為 1，馬達驅動器以絕對位置來處理目標位置。

#### `cw! ( cw ch n -- )`

直接設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 control word 為 `cw`。(由 PDO 設定)。

#### `demand-p@ ( ch n -- pos )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 demand position `pos`。

需要設定主站參數檔，而且該管道的馬達驅動器可以將 demand position (object 0x6062) 映射到 PDO Mapping 上。

#### `demand-tq@ ( ch n -- tq )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 demand torque `tq`。

需要設定主站參數檔，而且該管道的馬達驅動器可以將 demand torque (object 0x6074) 映射到 PDO Mapping 上。

#### `demand-v@ ( ch n -- vel )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 demand velocity `vel`。

需要設定主站參數檔，而且該管道的馬達驅動器可以將 demand velocity (object 0x606B) 映射到 PDO Mapping 上。

#### `drive-dins@ ( ch n -- dins )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的數位輸入狀態 `dins`。(由 PDO 取得資料)。

對應到 object 0x60FD。定義如下：

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 31                                                  Bit 0

* Bit 0: Negative Limit
* Bit 1: Positive Limit
* Bit 2: Home Switch
* Bit 3 ~ 31: 依馬達驅動器廠商定義。

#### `drive-douts! ( douts ch n -- )`

使用 SDO 命令，設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的數位輸出為 `douts`。

對應到 object 0x60FE:0x01。定義如下：

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 31                                                  Bit 0

* Bit 0: Brake。
* Bit 1 ~ 31: 依馬達驅動器廠商定義。

一般而言，驅動器的數位輸出是由馬達驅動器直接控制，如果需要由主站直接控制輸出，就要搭配 `drive-douts-mask!` 一起使用。

#### `drive-douts-mask! ( mask ch n -- )`

使用 SDO 命令，設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的數位輸出遮罩為 `mask`。

與 `drive-douts!` 一起使用。

#### `drive-fault? ( ch n -- flag )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 status word Bit 3 (fault) 的狀態 `flag`。

#### `drive-homd? ( ch n -- flag )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器是否已經回歸機械原點 `flag`。

#### `drive-nl? ( ch n -- nl )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的負向極限開關是否被觸發 `nl`。

其狀態來源與 `drive-dins@` 相同。

#### `drive-nsl! ( nsl ch n -- )`

使用 SDO 命令設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的負向軟體極限為 `nsl`。

對應的 Object 0x607D:0x01。

#### `drive-off (ch n -- )`

將 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 FSA State 切換到 Switch On Disabled。

#### `drive-on (ch n -- )`

將 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 FSA State 切換到 Operation enabled。

#### `drive-on? ( ch n -- flag )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 FSA State 是否在 Operation enabled `flag`。 

#### `drive-org? ( ch n -- org )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 home switch 是否被觸發 `org`。

其狀態來源與 `drive-dins@` 相同。

#### `drive-pl? ( ch n -- pl )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的正向極限開關是否被觸發 `nl`。

其狀態來源與 `drive-dins@` 相同。

#### `drive-psl! ( psl ch n -- )`

使用 SDO 命令設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的負向軟體極限為 `psl`。

對應的 Object 0x607D:0x02。

#### `drive-polarity! ( polarity ch n -- )`

使用 SDO 命令設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的方向定義 `polarity`。

對應的 Object 0x607E。

#### `drive-rpdo1@ ( ch n -- r1 )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器使用者規劃的第一個 PDO 資料 （slave -> master）`r1`。

需要設定主站參數檔，而且該管道的馬達驅動器可以將對應的 object 映射到 PDO Mapping 上。

#### `drive-rpdo2@ ( ch n -- r2 )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器使用者規劃的第二個 PDO 資料 （slave -> master）`r2`。

需要設定主站參數檔，而且該管道的馬達驅動器可以將對應的 object 映射到 PDO Mapping 上。

#### `drive-stop ( ch n -- )`

將 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 FSA State 切換到 Quick stop actived。

#### `drive-sw@ ( ch n -- sw )`

取得 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的 Status Word `sw`。(由 PDO 取得資料)。

#### `drive-vmax! ( vmax ch n -- )`

使用 SDO 命令設定 EtherCAT 從站編號 `n` 第 `ch` 管道馬達驅動器的最高速度 `vmax`。

對應的 Object 0x6080:0x01。

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
| +drive-halt           | ( ch n -- )           |
| +drive-homed          | ( ch n -- )           |
| +pp-cosp              | ( ch n -- )           |
| +pp-imt               | ( ch n -- )           |
| +pp-rel               | ( ch n -- )           |
| -drive-halt           | ( ch n -- )           |
| -drive-homed          | ( ch n -- )           |
| -pp-cosp              | ( ch n -- )           |
| -pp-imt               | ( ch n -- )           |
| -pp-rel               | ( ch n -- )           |
| csp                   | ( -- 8 )              |
| cst                   | ( -- 10 )             |
| csv                   | ( -- 9 )              |
| cw!                   | ( cw ch n -- )        |
| demand-p@             | ( ch n -- pos )       |
| demand-tq@            | ( ch n -- tq )        |
| demand-v@             | ( ch n -- vel )       |
| drive-dins@           | ( ch n -- dins )      |
| drive-douts!          | ( douts ch n -- )     |
| drive-douts-mask!     | ( mask ch n -- )      |
| drive-fault?          | ( ch n -- flag )      |
| drive-homd?           | ( ch n -- flag )      |
| drive-nl?             | ( ch n -- nl )        |
| drive-nsl!            | ( nsl ch n -- )       |
| drive-off             | ( ch n -- )           |
| drive-on              | ( ch n -- )           |
| drive-on?             | ( ch n -- flag )      |
| drive-org?            | ( ch n -- org )       |
| drive-pl?             | ( ch n -- pl )        |
| drive-psl!            | ( psl ch n -- )       |
| drive-polarity!       | ( polarity ch n -- )  |
| drive-rpdo1@          | ( ch n -- r1 )        |
| drive-rpdo2@          | ( ch n -- r2 )        |
| drive-stop            | ( ch n -- )           |
| drive-sw@             | ( ch n -- sw )        |
| drive-vmax!           | ( vmax ch n -- )      |
| drive-wpdo1!          | ( w1 ch n -- )        |
| drive-wpdo1@          | ( ch n -- w1 )        |
| drive-wpdo2!          | ( w2 ch n -- )        |
| drive-wpdo2@          | ( ch n -- w2 )        |
| go                    | ( ch n -- )           | 
| hm                    | ( -- 6 )              |
| homing-a!             | ( acc ch n -- )       |
| homing-method!        | ( method ch n -- )    |
| homing-v1!            | ( v1 ch n -- )        |
| homing-v2!            | ( v2 ch n -- )        |
| op-mode!              | ( mode ch n -- )      |
| pds-goal!             | ( goal ch n -- )      |
| pp                    | ( -- 1 )              |
| profile-a1!           | ( a1 ch n -- )        |
| profile-a2!           | ( a2 ch n -- )        |
| profile-v!            | ( vel ch n -- )       |
| pv                    | ( -- 3 )              |
| real-p@               | ( ch n -- pos )       |
| real-tq@              | ( ch n -- tq )        |
| real-v@               | ( ch n -- vel )       |
| reset-fault           | ( chl n -- )          |
| target-p!             | ( pos ch n -- )       |
| target-p@             | ( ch n -- pos )       |
| target-reached?       | ( channel n -- flag ) |
| target-tq!            | ( tq ch n -- )        |
| target-v!             | ( vel ch n -- )       |
| tq                    | ( -- 4 )              |
| tq-ofs!               | ( ofs ch n -- )       |
| tq-ofs@               | ( ch n -- ofs )       |
| tq-slope!             | ( slope ch n -- )     |
| until-drive-on        | ( ch n -- )           |
| until-no-fault        | ( ch n -- )           |
| until-target-reached  | ( ch n -- )           |
| v-ofs!                | ( ofs ch n -- )       |
| v-ofs@                | ( ch n -- ofs )       |
