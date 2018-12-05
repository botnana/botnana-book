### Job Operation

針對軸組運動使用。Job 指的是所有軸組合作完成的工作。

#### `start-job ( -- )`

Start job.

#### `stop-job ( -- )`

Stop job.

#### `ems-job ( -- )`

Emergency stop job.

#### `reset-job ( -- )`

Reset job.

#### `+coordinator ( -- )`

Enable coordinator.

由 Botnana-Control 進行軸運動控制，Botnana-Control會運行軸組的路徑規劃與位置補間。
在此模式之下，驅動器必須要切換到 CSP Mode。

命令範例:
    
    +coordinator

#### `-coordinator ( -- )`

Disable coordinator.

命令範例:
    
    -coordinator

#### `empty? ( -- flag)`

Has path of all groups of coordinator empty ?

#### `end? ( -- flag)`

Has path of all groups of coordinator ended ?

#### `stop? ( -- flag)`

Has path of all groups of coordinator stopped ?

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `start-job` |( -- ) | 
| `stop-job` |( -- ) |
| `ems-job` |( -- ) | 
| `reset-job` |( -- ) | 
| `+coordinator` |( -- ) | 
| `-coordinator` |( -- ) | 
| `empty?` |( -- flag ) | 
| `end?` |( -- flag ) | 
| `stop?` |( -- flag ) | 

---
### Axis Group

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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| gvmax! | ( g -- )( F: v --)        |
| gamax! | ( g -- )( F: a --)        |
| gjmax! | ( g -- )( F: j --)        |
| map1d  | ( x g -- )                |
| map2d  | ( x y g -- )              |
| map3d  | ( x y z g -- )            |
| .grpcfg  | ( g -- )              |
| .group  | ( g -- )              |
| group!  | ( n -- )              |
| group@  | ( -- n )              |
| 0path  | ( -- )              |
| feedrate!  | ( F: v -- )     |
| feedrate@  | ( F: -- v )     |
| +group  | ( -- )     |
| -group  | ( -- )     |
| vcmd!  | ( F: v -- ) |
| gend?  | ( -- flag ) |
| gstop?  | ( -- flag ) |
| gstart  | ( -- ) |
| gstop  | ( -- ) |
   
---
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

#### `drive-slave! ( slave j -- )`

設定運動軸 `j` 對應到的 EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Slave Position 為 2
     
    2 3 drive-slave!

#### `drive-channel! ( ch j -- )`

設定運動軸 `j` 對應到的 Channel `ch` of EtherCAT Slave Postion, 如果沒有實際的驅動器存在則會以虛擬運動軸處理。

命令範例： 設定 Axis 3 對應的 Channel of EtherCAT Slave 為 1
     
    1 3 drive-channel!    
  
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

#### `axis-demand-p@ ( j -- )( F: -- pos )`

取得 Axis j 的命令位置 

#### `axis-real-p@ ( j -- )(F: -- pos )`

取得 Axis j 的實際位置 

#### `axis-cmd-p! ( j -- )( F: pos -- )`

設定 Axis  `j` command position

#### 運動軸追隨範例

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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| enc-ppu! |( j -- )( F: ppu -- )  |
| enc-u! |( u j -- )               |
| enc-dir! |( dir j -- )           |
| ext-enc-ppu! |( j -- )( F: ppu -- )  |
| ext-enc-dir! |( dir j -- )           |
| hmofs! |( j -- ) ( F: ofs -- )   |
| axis-vmax! |( j -- ) ( F: vmax -- )  |
| axis-amax! |( j -- ) ( F: amax -- )  |
| axis-vmax@ |( j -- ) ( F: -- vmax )  |
| axis-amax@ |( j -- ) ( F: -- amax )  |
| drive-alias! |( drive-alias j -- )   |
| drive-slave! |( drive-slave j -- )   |
| drive-channel! |( drive-channel j -- ) |
| ext-enc-alias! |( enc-alias j -- )   |
| ext-enc-slave! |( enc-slave j -- )   |
| ext-enc-channel! |( enc-channel j -- ) |
| .axiscfg |( j -- ) |
| .axis    |( j -- ) |
| axis-len    |( --  len ) |
| virtual-axis?  |( j --  flag ) |
| axis-drive@  |( j --  channel slave ) |
| axis-ext-enc@  |( j --  channel slave ) |
| axis-demand-p@ | ( j -- )(F: -- pos ) |
| axis-real-p@   | ( j -- )(F: -- pos ) |
- [EtherCAT Encoder 指令集](./ethercat_encoder_primitives.md)|axis-cmd-p!     | ( j -- )( F: pos -- ) |

---
### 1D Path Planning

Current axis group should be 1D for the following commands to work without failure.

#### `move1d ( F: x -- )` 

    Declare the current absolute coordinate to be `x`. (G92)

#### `line1d ( F: x -- )` 

    Add a line to `x` into path.

#### 範例 test-1d
    
假設 Group 2 為  1D group, 以100.0 mm.min 速度運動通過相對起點為 -0.5, 1.0，終點為 0.0 的座標位置。
     
    : test-1d                      \ 定義 test-1d 指令
        +coordinator               \ 啟動軸運動控制模式                    
        start-job                  \ 啟動加減速機制
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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| move1d | ( F: x -- ) |
| line1d | ( F: x -- ) |
   
---    
### 2D Path Planning

Current aixs group should be 2D for the following commands to work without failure.

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
        start-job                      \ 啟動加減速機制
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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| move2d | ( F: x y -- ) |
| line2d | ( F: x y -- ) |
| arc2d | ( n -- )( F: cx cy x y -- ) |

---
### 3D Path Planning

Current axis group should be 3D for the following commands to work without failure.

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
        start-job                      \ 啟動加減速機制
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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| move3d | ( F: x y z -- ) |
| line3d | ( F: x y z -- ) |
| helix3d | ( n -- )( F: cx cy x y z -- ) |

---
### Sine Wave

Current axis group should be SINE for the following commands to work without failure.

#### `move-sine ( F: x -- )`

Declare the current absolute coordinate to be `x`. (G92)

#### `sine-f! ( F: f -- )`

Set frequency `f` of sine wave

#### `sine-amp! (F: amp -- )`

Set amplitude `amp` of sin wave

#### 範例 test-sine
    
假設 Group 1 為 SINE group
     
    +coordinator          \ 啟動軸運動控制模式                    
    start-job             \ 啟動加減速機制
    1 group! +group       \ 啟動 Group 1
    0path                 \ 清除 Group 1 路徑
    0.0e   move-sine      \ 宣告目前位置為起始運動位置，座標為 (0.0) 
    1.0e   sine-f!        \ 設定sine wave 頻率為 1.0 Hz
    0.01e  sine-amp!      \ 設定sine wave 振幅為 0.01
    ...
    stop-job              \ 停止加減速機制

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| move-sine  | ( F: x -- ) |
| sine-f! | ( F: f -- ) |
| sine-amp! | ( F: amp -- ) |

---    
### 插值後加減速

命令針對單一運動軸，可以同時讓多個運動軸同時運行。如果該運動軸受到軸組控制則不可執行插值後加減速機制。  

#### `+interpolator ( j -- )`

啟動 Axis `j` 插值後加減速機制。

#### `-interpolator ( j -- )`

關閉 Axis `j` 插值後加減速機制。如果插值器運作中，會以當下的位置開始減速到 0。

#### `interpolator-v! ( j -- )（ F: v -- ）`

設定 Axis  `j` 插值器得最大運動速度。

#### 插值後加減速範例

以 Axis 1 為例：

    1  +interpolator                 \ 啟動 Axis 1 插值後加減速
    100.0 mm/min  1  interpolator-v! \ 設定 Axis 1 插值速度為 100.0 mm/min
    0.3 1 axis-cmd-p!                \ 設定 Axis 1 的目標位置為座標位置 0.3 m 

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| +interpolator  | ( j -- ) |
| -interpolator | ( j -- ) |
| interpolator-v! | ( j -- )（ F: v -- ） |
| axis-cmd-p! | ( j -- )( F: pos -- ) |

---
###. Pitch Corrector

#### `+pcorr ( channel slave -- )`

開啟指定驅動器的 Pitch Corrector

#### `-pcorr ( channel slave -- )`

關閉指定驅動器的 Pitch Corrector

#### `>pcorr ( channel slave -- )`

讀取指定驅動器的 Pitch Corrector，此命令會造成 real time cycle overrun, 要在安全的情況下使用，例如 Servo off 的情況下。

#### `.pcorr ( channel slave -- )`

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

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `+pcorr` |( channel n -- ) |   
| `-pcorr` |( channel n -- ) |  
| `>pcorr` |( channel n -- ) |
| `pcorr>` |( channel n -- ) |
| `pcorr-entry!` |( index channel n -- )( F: position forward backward -- ) |
| `pcorr-factor!` |( channel n -- )( F: factor -- ) |
| `pcorr-resize` |( len channel n -- ) |
| `.pcorr` |( channel n -- ) |
| `.pcorr-entry` |( index channel n -- ) |