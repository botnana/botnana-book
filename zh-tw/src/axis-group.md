### Job Operation

針對軸組運動使用。Job 指的是所有軸組合作完成的工作。

**座標系解釋**

* ACS ：Axes Coordinate System (運動軸座標系)
* MCS ：Machine Coordinate System (機械座標系或是大地座標系)
* PCS ：Product Coordinate System/Program Coordinate System (工件座標系)

**軸組概念說明**

```

        +--------------+
        |  Coordinator |
        |              |
        +-------+------+
                |
    +-------------------------+
    |           |             |
+---+---+    +--+----+    +---+---+
| Group |    | Group |    | Group |
| (1D)  |    |  (2D) |    |  (3D) |
+---+---+    +--+----+    +--+----+
    |           |            |
    |           +----------+ +----------+------------+
    |           |          | |          |            |
+---+---+   +---+---+   +--+-+--+   +---+---+   +----+--+
|  Axis |   |  Axis |   |  Axis |   |  Axis |   |  Axis |
|       |   |       |   |       |   |       |   |       |
+---+---+   +---+---+   +---+---+   +---+---+   +-------+
    |           |           |           |
    |           |           |           |
    |           |           |           |
+---+---+   +---+---+   +---+---+   +---+---+
| Drive |   | Drive |   | Drive |   | Drive |
|       |   |       |   |       |   |       |
+-------+   +-------+   +-------+   +-------+

```

**Coordinator (同動控制功能)**:

多軸同動控制。EtherCAT 通訊具有時間同步的特性，所以適合用來實現多軸同動的功能。

此多軸同動控制所選用的 EtherCAT 馬達驅動裝置必須支援周期時間同步位置模式 （Cyclic Synchronous Position Mode），一般而言 EtherCAT 馬達驅動裝置都有支援。

**Group （軸組）**:

軸組運動功能如下：

1. S 型加減速曲線。
2. 直線與圓弧路徑規劃。
3. 路徑運動速度限制。
4. 路徑預視。
5. 可以多個軸組同時運行（受限於運動軸是否被其他運動功能控制）。

目前有提供以下幾種類型：

1. 單軸 （1D）。
2. 2軸正交 (2D)。
3. 3 軸正交 (3D)。
4. 單軸弦波運動 （Sine wave）。

**Axis（運動軸）**:

受控於軸組，運行點對點的運動或是進行追隨運動。如果沒有對應的驅動裝置即為虛擬軸。當運動軸為虛擬軸時，其實際位置是由命令位置推算所得。

執行點對點運動時的注意事項：

1. S 型加減速曲線。
2. 運動速度只能在靜止改變。加速曲線會依據運動軸的最大加速度與最大速度進行規劃。
3. 運動中可以隨時改變目標位置。

**Drive（驅動裝置）**：

實際的馬達驅動裝置。可以是不同廠牌/型態的馬達驅動器。

**運動單位**

Botnana Control 的長度單位默認為公尺 [m]，時間單位為秒 [s]。
所以速度單位為 `m/s`, 加速度單位`m/s^2`，加加速度單位`m/s^3`。

假設有一個 1D 的直線運動系統，馬達編碼器的解析度設定為 1000000 pulse = 1 m。

以長度單位為公尺的設定範例：

* Group vmax = 0.01 [m/s]
* Group amax = 5.0  [m/s^2]
* Group jmax = 40.0 [m/s^3]
* Group ignorable distance = 0.0000005 [m]
* Axis encoder_ppu = 1000000
* Axis encoder_length_unit = Meter
* Axis vmax = 0.01 [m/s]
* Axis amax = 5.0  [m/s^2]
* Axis ignorable distance = 0.0000005 [m]

以長度單位為脈衝數 (Pulse) 的設定範例：

* Group vmax = 10000.0 [pulse/s]
* Group amax = 5000000.0  [pulse/s^2]
* Group jmax = 40000000.0 [pulse/s^3]
* Group ignorable distance = 0.5 [pulse]
* Axis encoder_ppu = 1
* Axis encoder_length_unit = Pulse
* Axis vmax = 10000.0 [pulse/s]
* Axis amax = 5000000.0  [pulse/s^2]
* Axis ignorable distance = 0.5 [pulse]

假設有一個 1D 的旋轉運動系統，馬達編碼器的解析度設定為 3600000 pulse = 1 rev，以旋轉半徑 100 mm 的切線速度來比擬線性速度。
Botnana Control 是以徑度 (radian) 計算，所以轉換時需要留意。

以長度單位為徑度的設定範例：

* Group vmax = 0.1 [rad/s]
* Group amax = 50.0  [rad/s^2]
* Group jmax = 400.0 [rad/s^3]
* Group ignorable distance = 0.0000005 [rad]
* Axis encoder_ppu = 3600000
* Axis encoder_length_unit = Revolution
* Axis vmax = 0.1 [rad/s]
* Axis amax = 50.0  [rad/s^2]
* Axis ignorable distance = 0.0000005 [rad]

**命令位置**：

當同動控制功能（+coordinator）開啟後，Botnana Control 會依據運動軸的設定，將運動軸的命令轉換到馬達驅動器的命令位置。
所以當同動控制功能 （+coordinator）開啟後，如果該控制器被運動軸所控制，就無法直接設定馬達驅動器的命令位置。

如果軸組啟動中，且依據路徑規劃開始運動，或是運動中暫停，Botnana Control 會依據軸組的設定將運動命令分配給對應的運動軸，
此時運動軸的命令就會受到軸組控制。如果軸組間有共用運動軸，切換時就必須要留意是否會造成運動軸命令位置不連續。

**落後誤差過大處置方式**

當實體軸運動時，如果命令位置與實際位置相差過大，通常表示有軸控的問題發生，當停止運動且排除故障後，消除落後誤差過大的方法如下：

* 當同動控制功能沒有開啟或是該馬達驅動器不受運動軸控制時，直接以馬達驅動器的實際位置設定命令位置。例如：

```
    1 1 real-p@ 1 1 target-p!
```

* 當同動控制功能開啟，且運動軸不受軸組控制，例如：

```
    1 0axis-ferr    \ 清除第 1 個運動軸的落後誤差
```

* 當同動控制功能開啟，且運動軸受軸組控制，例如：

```
    1 group! 0path     \ 假設是第 1 個軸組，切換軸組為 1，清除路徑
    1 0axis-ferr       \ 假設第 1 個運動軸受控於第 1 個軸組，清除第 1 個運動軸的落後誤差
    2 0axis-ferr       \ 假設第 2 個運動軸受控於第 1 個軸組，清除第 2 個運動軸的落後誤差
```

---
### Coordinator

#### `.coordinator ( -- )`

輸出軸組狀態。

輸出訊息如下：

```
    coordinator_enabled|0

    coordinator_enabled: 1 表示同動功能開啟，0 表示同動功能關閉。
```

#### `+coordinator ( -- )`

啟動同動控制功能。

由 Botnana Control 進行軸運動控制，Botnana Control會依軸組路徑或是運動軸目標位置進行加減速規劃與位置補間。

在此模式之下，驅動器必須要切換到 CSP Mode。

#### `-coordinator ( -- )`

關閉同動控制功能。

#### `#groups ( -- len )`

取得軸組數量 `len`。

#### `#axes ( -- len )`

取得運動軸數量 `len` 。

#### `coordinator? ( -- t )`

軸組是否開啟？

#### `empty? ( -- t )`

所有軸組的路徑是否已經清空？

#### `ems-job ( -- )`

執行同動功能緊急停止。所有軸組與運動軸的點對點運動都會立即停止。軸組的路徑資訊都會被清除。

#### `end? ( -- t )`

所以軸組與運動軸點對點運動是否到達路徑終點？

#### `reset-job ( -- )`

清除所有軸組的路經資訊。

#### `start-job ( -- )`

命令所有軸組開始運動。

#### `stop? ( -- t )`

所以軸組與運動軸點對點運動是否已經停止？

#### `stop-job ( -- )`

命令所有軸組與運動軸點對點運動減速停止。

#### 本節指令集

| 指令 | 堆疊效果                       | 說明 |
|-----|------------------------------|----|
| `.coordinator` |( --  ) | 輸出軸組狀態
| `+coordinator` |( -- ) | 啟動軸組功能
| `-coordinator` |( -- ) | 關閉軸組功能
| `#groups`       |( -- len ) | 取得軸組數量
| `#axes`         |( -- len ) | 取得運動軸數量
| `coordinator?` |( -- t ) | 軸組是否開啟？
| `empty?`        |( -- t ) |  是否所有軸組路徑已經清空 ？
| `ems-job`       |( -- ) | 命令所以軸組緊急停止
| `end?`          |( -- t ) | 是否所有軸組已經到達路徑終點 ？
| `reset-job`    |( -- ) | 清除所有軸組路徑
| `start-job`    |( -- ) | 命令所有軸組開始運動
| `stop?`         |( -- t ) | 是否所有軸組已經停止運動 ？
| `stop-job`      |( -- ) | 命令所有軸組停止運動

---

### Axis Group

#### `.group ( g -- )`

輸出 group `g` 資訊

命令範例:

    1 .group  \ 輸出第 1 個軸組的資訊

回傳訊息 :

    group_enabled.1|0
    |group_stopping.1|1
    |move_count.1|0
    |path_event_count.1|0
    |path_id.1|0
    |path_mode.1|0
    |focus.1|0
    |source.1|0
    |pva.1|0.0000000,0.00000,0.00000
    |move_length.1|0.0000000
    |total_length.1|0.0000000
    |feedrate.1|0.00000
    |vcmd.1|0.00000
    |max_look_ahead_count.1|0
    |ACS.1|0.0000000,0.0000000,0.0000000
    |MCS.1|0.0000000,0.0000000,0.0000000
    |PCS.1|0.0000000,0.0000000,0.0000000

#### `.grpcfg ( g -- )`

輸出 group `g` 的設定參數

命令範例：

    1 .grpcfg  \ 輸出第 1 個軸組的設定參數

回傳訊息:

    group_name.1|Anonymous
    |group_type.1|3D
    |group_mapping.1|1,2,3
    |group_vmax.1|0.10000
    |group_amax.1|5.00000
    |group_jmax.1|80.00000
    |group_ignorable_distance.1|0.0000005

#### `+group`

啟動目前選用的軸組。

命令範例:
    
    1 group!   \ 切換到第 1 個軸組
    +group     \ 啟動目前選用的軸組

#### `-group`

關閉目前選用的軸組。

#### `0path`

清除目前軸組的路經資訊。

命令範例:
          
    1 group!  \ 切換到第 1 個軸組
    0ptah     \ 清除目前軸組的路經資訊

#### `acs-p@ ( n -- ) ( F: -- pos )`

取得目前軸組，ACS 座標系第 `n` 軸的座標位置。

命令範例:

    1 acs-p@ f. \ 取得第 1 軸得座標位置，然後輸出位置資訊

回傳訊息:

    0.0000000

#### `feedrate! ( F: v -- )`

設定後續安插路徑的最大運動速度 `v`。`v` 必須大於 0。

命令範例:
    
    100.0e mm/min feedrate!  \ 設定當下 group feedrate 為 100.0 mm/min

#### `feedrate@ ( F: -- v )`

取得後續安插路徑的最大運動速度 `v`。

命令範例:

    feedrate@ f. \ 取得 group feedrate，並輸出訊息

回傳訊息:

    0.1000000

#### `gamax! ( g -- ) ( F: a -- )`

設定 group `g` 的最大加速度為 `a`。

命令範例：

    2.0e 1 gamax! \ 設定 Group 1 的最大加速度為 2.0

#### `gend? ( -- flag )`

所選定的軸組是否到達路徑終點？

#### `gignore-dist! ( g -- ) ( F: dist --)`

設定指定軸組 `g` 可忽略的長度計算誤差 `dist`。

通常在 pulse 的系統下，設定為 0.5 或是 0.1 [pulse]。其它設定為 0.5e-6 或是 0.1e-6 [m] or [rad]

#### `gjmax! ( g -- ) ( F: j -- )`

設定 group `g` 的最大加加速度為 `j`。

命令範例：

    40.0e 1 gjmax! \ 設定 Group 1 的最大加加速度為 40.0

#### `gmap! ( j1 j2 j3 ... g -- )`

設定軸組 `g` 所控制的運動軸 `j1 j2 j3 ...`。需要注意軸組型態與運動軸數量。

注意事項：

1. 軸組 `g` 不可以處在啟動狀態。
2. 運動軸 `j` 不可受控於其他啟動中的軸組或是在點對點運動模式。
3. 軸組型態與運動軸數量要匹配正確。

命令範例：

                  \ 假設軸組 1 是 3D 軸組
    2 3 4 1 gmap! \ 設定 Group 1 對應的運動軸編號分別是 2, 3, 4
    2 1 gmap!     \ 設定 Group 1 對應的運動軸編號分別是 2，則是會回報錯誤 （Stack underflow）

#### `gmap@ ( g -- j1 j2 j3 ... )`

取得軸組所控制的運動軸，需要注意軸組型態與運動軸數量。

#### `group! ( g -- )`

設定目前選用的軸組 `g`, `g`  編號從 1 開始。

#### `group@ ( -- g )`

取得目前所選定的軸組 `g`命令範例:

    group@                  \ 取出目前軸組編號
    1 group! 0.1e feedrate! \ 選用軸組 1，設定 feedrate
    group!                  \ 切換回原來的軸組

#### `group? ( -- t )`

目前所選定的軸組是否啟動 ?

#### `grp1d? ( g -- flag )`

指定軸組 `g` 是否為 1D 軸組 ?

#### `grp2d? ( g -- flag )`

指定軸組 `g` 是否為 2D 軸組 ?

#### `grp3d? ( g -- flag )`

指定軸組 `g` 是否為 3D 軸組 ?

#### `grp-sine? ( g -- flag )`

指定軸組 `g` 是否為 Sine Wave 軸組 ?

#### `gstart ( -- )`

命令所選定的軸組開始運動。

命令範例:

    1 group! gstart  \ 切換到軸組 1, 命令軸組 1 開始運動。

#### `gstop ( -- )`

命令所選定的軸組停止運動。

命令範例:

    1 group! gstop  \ 切換到軸組 1, 命令軸組 1 停止運動。

#### `gstop? ( -- flag )`

所選定的軸組是否已經停止運動 ？

#### `gvmax! ( g -- ) ( F: v -- )`

設定 group `g` 的最大速度為 `v`。

命令範例：

    1000.0e mm/min 2 gvmax! \ 設定 Group 1 的最高速度為 1000.0 mm/min

#### `map-len@ ( g -- len )`

取得軸組 `g` 的運動軸數量 `len`。

#### `map-sine ( j1 g -- )`

設定軸組 `g` 的對應運動軸為 `j1`。

注意事項：

1. 軸組 `g` 必須為 Sine Wave 軸組。
2. 軸組 `g` 不可以處在啟動狀態。
3. 運動軸 `j1` 不可受控於其他啟動中的軸組或是在點對點運動模式。

命令範例： 

    3 1 map-sine  \ 設定 Group 1 的運動軸為 Axis 3

#### `map1d ( j1 g -- )`

設定軸組 `g` 的對應運動軸為 `j1`。

注意事項：

1. 軸組 `g` 必須為 1D 軸組。
2. 軸組 `g` 不可以處在啟動狀態。
3. 運動軸 `j1` 不可受控於其他啟動中的軸組或是在點對點運動模式。

命令範例：

    3 1 map1d  \ 設定 Group 1 的運動軸為 Axis 3

#### `map2d ( j1 j2 g -- )`

設定軸組 `g` 的對應運動軸為 `j1, j2`。

注意事項：

1. 軸組 `g` 必須為 2D 軸組。
2. 軸組 `g` 不可以處在啟動狀態。
3. 運動軸 `j1 j2` 不可受控於其他啟動中的軸組或是在點對點運動模式。

命令範例：

    3 5 2 map2d \ 設定 Group 2 的運動軸為 Axis 3, 5

#### `map3d ( j1 j2 j3 g -- )`

設定軸組 `g` 的對應運動軸為 `j1, j2, j3`。

注意事項：

1. 軸組 `g` 必須為 3D 軸組。
2. 軸組 `g` 不可以處在啟動狀態。
3. 運動軸 `j1 j2 j3` 不可受控於其他啟動中的軸組或是在點對點運動模式。

命令範例：

    3 5 6 2 map3d 設定 Group 2 的運動軸為 Axis 3, 5, 6

#### `mcs ( -- )`

宣告所選定軸組以目前 MCS 座標位置為路徑起始點（將 PCS 與 MCS 座標系重疊）。

#### `mcs-p@  ( n -- ) ( F: -- pos )`

取得所選定軸組 MCS 座標系中指定軸 `n` 的座標位置 `pos`。

命令範例：

    1 mcs-p@  \ 取得第 1 軸的 MCS 座標系位置。

#### `move-source#  ( -- n )`

取得所選定軸組目前是處在哪個路徑事件 `n`。

#### `next-a@  ( F: -- a )`

取得所選定軸組路徑切線方向加速度 `a`。

#### `next-path-id@ ( -- id )`

取得所選定軸組，目前路徑的編號 `id`。

#### `next-path-mode@ ( -- mode )`

取得所選定軸組，目前路徑的模式 `mode`。

#### `next-path-p@  ( -- ) ( F: -- pos )`

取得所選定軸組，從運動起始點算起，沿路路徑方向的位置 `pos`。

#### `next-v@ ( F: -- v )`

取得所選定軸組路徑切線方向速度 `v`。

#### `path-events-capacity@ ( -- n )`

取得所選定軸組可容納的路徑數量 `n`。

#### `path-events-len@ ( -- n )`

取得所選定軸組目前的路徑數量 `n`。

#### `path-id! ( id -- )`

設定後續安插路徑的編號 `id`。

應用範例：

1. 儲存對應 NC 程式的行號，當執行軸組運動時可以得知目前位置是由哪一行 NC 程式解譯而來。

#### `path-id@ ( -- id )`

取得後續安插路徑的編號 `id`。

#### `path-mode! ( mode -- )`

設定後續安插路徑的模式 `mode`。

#### `path-mode@ ( -- mode )`

取得後續安插路徑的模式 `mode`。

應用範例：

1. 用來區分該路徑是加工或是非加工路徑。

#### `pcs-p@  ( n -- ) ( F: -- pos )`

取得所選定軸組 PCS 座標系的指定軸 `n` 的座標位置 `pos`。

#### `vcmd! ( F: v -- )`

設定路徑上運行的速度 `v`。

* 當 `v` > 0 時，會沿著路徑前進，直到路徑終點。
* 當 `v` = 0 時，速度會減速到 0。
* 當 `v` < 0 時，會沿著路徑後退，直到路徑起始點。

運動速度限制如下：

1. vcmd! 所指定的速度。
2. 該軸組所限制的最大運動速度 (gvmax!)。
3. 當下路徑的進給速度 （feedrate!）。
4. 預視路徑總長與當下位置。

命令範例:

    100.0e mm/min vcmd! \ 設定運動速度為 100.0 mm/min

#### 本節指令集

| 指令 | 堆疊效果                       | 說明 |
|-----|------------------------------|------|
| .group                | ( g -- )                  | 顯示軸組狀態 |
| .grpcfg               | ( g -- )                  | 顯示軸組設定參數
| +group                | ( -- )                    | 啟動所選定的軸組
| -group                | ( -- )                    | 關閉所選定的軸組
| 0path                 | ( -- )                    | 清除所選定的軸組路徑資訊
| acs-p@                | ( n -- ) ( F: -- pos )    | 取得所選定軸組 ACS 座標系的指定軸的座標位置
| feedrate!             | ( F: v -- )               | 設定後續安插路徑的最大運動速度
| feedrate@             | ( F: -- v )               | 取得後續安插路徑的最大運動速度
| gamax!                | ( g -- ) ( F: a --)       | 設定指定軸組的最大加速度
| gend?                 | ( -- flag )               | 所選定的軸組是否到達路徑終點 ?
| gignore-dist!         | ( g -- ) ( F: dist --)    | 設定指定軸組可忽略的長度計算誤差
| gjmax!                | ( g -- ) ( F: j --)       | 設定指定軸組的最大加加速度
| gmap!                 | ( j1 j2 j3 ... g -- )     | 設定軸組所控制的運動軸，需要注意軸組型態與運動軸數量
| gmap@                 | ( g -- j1 j2 j3 ... )     | 取得軸組所控制的運動軸，需要注意軸組型態與運動軸數量
| group!                | ( g -- )                  | 選定軸組
| group@                | ( -- g )                  | 取得目前所選定的軸組
| group?                | ( -- t )                  | 目前所選定的軸組是否啟動 ?
| grp1d?                | ( g -- flag )             | 指定軸組是否為 1D 軸組
| grp2d?                | ( g -- flag )             | 指定軸組是否為 2D 軸組
| grp3d?                | ( g -- flag )             | 指定軸組是否為 3D 軸組
| grp-sine?             | ( g -- flag )             | 指定軸組是否為 Sine Wave 軸組
| gstart                | ( -- )                    | 命令所選定的軸組開始運動
| gstop                 | ( -- )                    | 命令所選定的軸組停止運動
| gstop?                | ( -- flag )               | 所選定的軸組是否已經停止運動 ?
| gvmax!                | ( g -- ) ( F: v --)       | 設定指定軸組的最大運動速度
| map-len@              | ( g -- len )              | 取得指定軸組的運動軸數量
| map-sine              | ( j1 g -- )               | 設定 Sine Wave 軸組所控制的運動軸
| map1d                 | ( j2 g -- )               | 設定 1D 軸組所控制的運動軸
| map2d                 | ( j1 j2 g -- )            | 設定 2D 軸組所控制的運動軸
| map3d                 | ( j1 j2 j3 g -- )         | 設定 3D 軸組所控制的運動軸
| mcs                   | ( -- )                    | 宣告所選定軸組以目前 MCS 座標位置為路徑起始點
| mcs-p@                | ( n -- ) ( F: -- pos )    | 取得所選定軸組 MCS 座標系的指定軸的座標位置
| move-source#          | ( -- n )                  | 取得所選定軸組目前是處在哪個路徑事件
| next-a@               | ( F: -- a )               | 取得所選定軸組路徑切線方向加速度
| next-path-id@         | ( -- id )                 | 取得所選定軸組，目前路徑的編號
| next-path-mode@       | ( -- mode )               | 取得所選定軸組，目前路徑的模式
| next-path-p@          | ( -- ) ( F: -- pos )      | 取得所選定軸組，從運動起始點算起，沿路路徑方向的位置
| next-v@               | ( F: -- v )               | 取得所選定軸組路徑切線方向速度
| path-events-capacity@ | ( -- n )                  | 取得所選定軸組可容納的路徑數量
| path-events-len@      | ( -- n )                  | 取得所選定軸組目前的路徑數量
| path-id!              | ( id -- )                 | 設定後續安插路徑的編號
| path-id@              | ( -- id )                 | 取得後續安插路徑的編號
| path-mode!            | ( mode -- )               | 設定後續安插路徑的模式
| path-mode@            | ( -- mode )               | 取得後續安插路徑的模式
| pcs-p@                | ( n -- ) ( F: -- pos )    | 取得所選定軸組 PCS 座標系的指定軸的座標位置
| vcmd!                 | ( F: v -- )               | 設定所選定的軸組的速度命令

---
### 1D 路徑規劃

注意事項：

1. 目前選用的軸組必須為 1D 型態。
2. 路徑的起始點為前一個路徑的目標點。
3. 必須要宣告路徑起始點（ move1d, mcs, psc1d）

#### `line1d ( F: x -- )`

增加目標點為 (`x`) 的直線路徑。

#### `move1d ( F: x -- )`

宣告目前位置為 PCS 座標 (`x`)，並且為路徑起始點。類似工件程式 GM 碼的 G92。

#### `pcs1d ( F: x0 -- )`

宣告 PCS 座標零點(`x0`)，並以當下位置做為路徑起始點。類似工件程式 GM 碼的 G54。

#### 範例 test-1d

假設 Group 1 為 1D group, 以 100.0 mm.min 速度運動通過相對起點為 -0.5, 1.0，終點為 0.0 的座標位置。

    : test-1d                      \ 定義 test-1d 指令
        +coordinator               \ 啟動軸運動控制模式
        start-job                  \ 啟動加減速機制
        1 group! +group            \ 切換選用軸組，啟動 Group 1
        0path                      \ 清除 Group 1 路徑
        0.0e move1d                \ 宣告目前位置為起始運動位置，座標為 0.0
        -0.5e line1d               \ 插入目標點為 -0.5 的 1D 直線路徑
        1.0e line1d                \ 插入目標點為 1.0 的 1D 直線路徑
        0.0e line1d                \ 插入目標點為 0.0 的 1D 直線路徑
        100.0e mm/min vcmd!        \ 設定運動速度為 100.0 mm/min
        begin                      \ 等待到達終點位置
            1 group! gend? not     \ 檢查是否到終點, 此處 1 group! 避免在等待過程中被其他指令修改了
        while
            pause                  \ 若是未到終點就等待下一個周期再進行檢查
        repeat 
        1 group! -group            \ 關閉 Group 1
    ;

    deploy test-1d ;deploy         \ 在背景執行 test-1d

#### 本節指令集

| 指令 | 堆疊效果        | 說明 |
|-----|----------------|-----|
| line1d | ( F: x -- ) | 插入 1D 直線路徑
| move1d | ( F: x -- ) | 宣告目前 PCS 座標為 (x)，並做為路徑起始點
| pcs1d | ( F: x0 -- ) | 宣告 PCS 座標零點，並以當下位置做為路徑起始點

---
### 2D 路徑規劃

注意事項：

1. 目前選用的軸組必須為 2D 型態。
2. 路徑的起始點為前一個路徑的目標點。
3. 必須要宣告路徑起始點（ move2d, mcs, psc2d）

#### `arc2d ( n -- )( F: cx cy x y -- )`

增加 2D 圓弧路徑，其圓心為 (`cx`,`cy`)，目標位置是 (`x`, `y`)。 `n` 表示從起始點運動第 `n` 圈到達目標點。

* `n` > 0 表示逆時針運動，
* `n` < 0 表示順時針運動，
* `n` 不可以為 0。

#### `line2d ( F: x y -- )`

增加目標點為 (`x`,`y`) 的直線路徑。

#### `move2d ( F: x y -- )`

宣告目前位置為 PCS 座標 (`x`, `y`)，並且為路徑起始點。類似工件程式 GM 碼的 G92。

#### `pcs2d ( F: x0 y0 -- )`

宣告 PCS 座標零點(`x0`, `y0`)，並以當下位置做為路徑起始點。類似工件程式 GM 碼的 G54。

#### 範例 test-2d

假設 Group 1 為  2D group

    : test-2d                          \ 定義 test-2d 指令
        +coordinator                   \ 啟動軸運動控制模式
        start-job                      \ 啟動加減速機制
        1 group! +group                \ 啟動 Group 1
        0path                          \ 清除路徑
        0.0e  0.0e  move2d             \ 宣告目前位置為起始運動位置，座標為 (0.0, 0.0)
        0.1e  0.0e  line2d             \ 插入目標點為 (0.1, 0.0) 的 2D 直線路徑
        0.1e  0.1e  line2d             \ 插入目標點為 (0.1, 0.1) 的 2D 直線路徑
        0.0e  0.1e  line2d             \ 插入目標點為 (0.0, 0.1) 的 2D 直線路徑
        0.0e  0.05e 0.0e 0.0e 1 arc2d  \ 以圓心位置 （0.0, 0.05）逆時針走到目標點 （0.0, 0.0）
        100.0e mm/min vcmd!            \ 設定運動速度為 100.0 mm/min
        begin                          \ 等待到達終點位置
            1 group! gend? not         \ 檢查是否到終點, 此處 1 group! 避免在等待過程中被其他指令修改了
        while
            pause                      \ 若是未到終點就等待下一個周期再進行檢查
        repeat
        1 group! -group                \ 關閉 Group 1
    ;

    deploy test-2d ;deploy         \ 在背景執行 test-2d

#### 本節指令集

| 指令 | 堆疊效果        | 說明 |
|-----|----------------|-----|
| arc2d     | ( n -- )( F: cx cy x y -- )   | 插入 2D 圓弧路徑
| line2d    | ( F: x y -- )                 | 插入 2D 直線路徑
| move2d    | ( F: x y -- )                 | 宣告目前 PCS 座標為 (x, y)，並做為路徑起始點
| pcs2d     | ( F: x0 y0 -- )               | 宣告 PCS 座標零點，並以當下位置做為路徑起始點

---
### 3D 路徑規劃

注意事項：

1. 目前選用的軸組必須為 3D 型態。
2. 路徑的起始點為前一個路徑的目標點。
3. 必須要宣告路徑起始點（ move3d, mcs, psc3d）。

#### `helix3d ( n -- )( F: cx cy x y z -- )`

增加 3D 螺旋路徑，其圓心為 (`cx`,`cy`)，目標位置是 (`x`, `y`, `z`)。 `n` 表示從起啟點運動第 `n` 圈到達目標點。

* `n` > 0 表示逆時針運動，
* `n` < 0 表示順時針運動，
* `n` 不可以為 0。

如果 `z` 與起始點相同，此螺旋路徑即為 XY 平面上的圓弧路徑。

#### `line3d ( F: x y z-- )`

增加目標點為 (`x`,`y`, `z`) 的直線路徑。

#### `move3d ( F: x y z -- )`

宣告目前位置為 PCS 座標 (`x`, `y`, `z`)，並且為路徑起始點。類似工件程式 GM 碼的 G92。

#### `pcs3d ( F: x0 y0 z0 -- )`

宣告 PCS 座標零點(`x0`, `y0`, `z0`)，並以當下位置做為路徑起始點。類似工件程式 GM 碼的 G54。

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
            1 group! gend? not         \ 檢查是否到終點, 此處 1 group! 避免在等待過程中被其他指令修改
        while
            pause                      \ 若是未到終點就等待下一個周期再進行檢查
        repeat
        1 group! -group                \ 關閉 Group 1
    ;

    deploy test-3d ;deploy         \ 在背景執行 test-3d

#### 本節指令集

| 指令 | 堆疊效果        | 說明 |
|-----|----------------|-----|
| helix3d   | ( n -- )( F: cx cy x y z -- )   | 插入 3D 螺旋路徑
| line3d    | ( F: x y z -- )                 | 插入 3D 直線路徑
| move3d    | ( F: x y z -- )                 | 宣告目前 PCS 座標為 (x, y, z)，並做為路徑起始點
| pcs3d     | ( F: x0 y0 z0 -- )              | 宣告 PCS 座標零點，並以當下位置做為路徑起始點

---
### Sine Wave Planner

注意事項：

1. 目前選用的軸組必須為 Sine Wave 型態。
2. 必須要宣告路徑起始點（ move3d, mcs, psc3d），此起始點就是相位 0 的位置。

#### `move-sine ( F: x -- )`

宣告目前位置為 PCS 座標 (`x`)，並且為路徑起始點。

#### `sine-amp! (F: amp -- )`

設定弦波振幅。可以運動中修改，經過起始點後才開始改變振幅。

#### `sine-f! ( F: f -- )`

設定弦波頻率。可以運動中修改，在相位 270 deg 的地方改變頻率。

#### `pcs-sine ( F: x0 -- )`

宣告 PCS 座標零點(`x0`） ，並以當下位置做為路徑起始點。

#### 範例 test-sine

假設 Group 1 為 SINE Wave Group

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

| 指令 | 堆疊效果        | 說明 |
|-----|----------------|-----|
| move-sine   | ( F: x -- )     | 宣告目前 PCS 座標為 (x)，並做為路徑起始點
| sine-amp!   | ( F: amp -- )   | 設定弦波運動的振幅
| sine-f!     | ( F: f -- )     | 設定弦波運動的頻率
| pcs-sine    | ( F: x0 -- )    | 宣告 PCS 座標零點，並以當下位置做為路徑起始點

---
### Axis

名詞說明：

* command_position: 運動軸的目標位置。
* demand_position: 運動過程中的命令位置。如果受到軸組控制時， demand_position 會與 command_position 相等。如果是運動軸的點對點運動，在過程中 demand_position 會朝著目標位置運動，只有在到達目標點時 demand_position 會與 command_position 相等。
* feedback_position: 由馬達編碼器或是雙位置回授所得到的實際位置。
* position_correction: 位置修正量。可以是 Pitch Corrector 所算出來的補正量，或是其他策略所推算出來的補正值。
* corrected_position: 修正後的實際位置。

   corrected_position = feedback_position - position_correction + home_offset

* following_error: 落後誤差。

    following_error = demand_position - corrected_position

---
#### `.axis ( j -- )`

顯示運動軸 `j` 狀態。

命令範例:

    1 .axis

回傳訊息 :

    axis_command_position.1|0.0000000
    |axis_demand_position.1|0.0000000
    |axis_corrected_position.1|0.0000000
    |encoder_position.1|0.0000000
    |external_encoder_position.1|0.0000000
    |feedback_position.1|0.0000000
    |position_correction.1|0.0000000
    |following_error.1|0.0000000
    |axis_interpolator_enabled.1|0
    |axis_homed.1|0

#### `.axiscfg ( j -- )`

顯示運動軸 `j` 設定

命令範例：

    1 .axiscfg

回傳訊息：

    axis_name.1|A2
    |axis_home_offset.1|0.0000000
    |encoder_length_unit.1|Meter
    |encoder_ppu.1|1000000.00000
    |encoder_direction.1|1
    |ext_encoder_ppu.1|60000.00000
    |ext_encoder_direction.1|-1
    |closed_loop_filter.1|15.0
    |max_position_deviation.1|0.001000
    |drive_alias.1|0
    |drive_slave_position.1|1
    |drive_channel.1|1
    |ext_encoder_alias.1|0
    |ext_encoder_slave_position.1|0
    |ext_encoder_channel.1|0
    |axis_amax.1|5.00000
    |axis_vmax.1|0.10000
    |axis_ignorable_distance.1|0.0000005

#### `+homed ( j -- )`

設定運動軸 `j` 已回歸機械原點。

#### `-homed ( j -- )`

設定運動軸 `j` 未回歸機械原點。

#### `0axis-ferr ( j -- )`

清除運動軸 `j` 落後誤差。使用運動軸實際位置修正命令位置，如果是虛擬軸則不受影響。

#### `axis-amax! ( j -- ) ( F: amax -- )`

設定運動軸 `j` 的最大加速度 `amax`。

命令範例：

    2.0e 1 axis-amax!  \ 設定 Axis 1 amax 為 2.0

#### `axis-amax@ ( j -- ) ( F: -- amax )`

取得運動軸 `j` 的最大加速度 `amax`。

命令範例：

    1 axis-amax@  \ 取得 Axis 1 amax

#### `axis-clerr  ( j -- ) ( F: clerr -- )`

取得運動軸 `j` 雙位置回授誤差 `clerr`。

通常外部編碼器安裝在靠近軌道或是工作台的位置，如果和馬達編碼器的位置相差過大代表機械傳動系的運作出現問題，此時可以優先檢查皮帶輪或是聯軸器。

#### `axis-cmd-p! ( j -- )( F: pos -- )`

設定運動軸 `j` 的目標位置 `pos`。

#### `axis-cmd-p@ ( j -- )( F: -- pos )`

取得運動軸 `j` 的目標位置 `pos`。

#### `axis-demand-p@ ( j -- )( F: -- pos )`

取得運動軸 `j` 的命令位置 `pos`。

#### `axis-drive@ ( j --  channel slave )`

取得運動軸 `j` 配置的馬達驅動器的 EtherCAT 站號 `slave` 與驅動軸編號 `channel`。

`slave` 指的是 slave position，最靠近主站的從站編號為 1，依序遞增。

如果是以 slave alias 指定馬達驅動器的方式，則是主站在初始化或是設定時就依指定 slave alias 取得 slave position。

當是虛擬軸時，`axis-drive@` 回傳的 `channel = 0`, `slave = 0`。

#### `axis-ext-enc@ ( j --  channel slave )`

取得運動軸 `j` 配置的外部編碼器的 EtherCAT 站號 `slave` 與輸入編號 `channel`。

當沒有配置外部編碼器時會使得 `axis-ext-enc@` 回傳 `channel = 0`, `slave = 0`。

#### `axis-ferr@ ( j -- ) ( F: ferr -- )`

取得運動軸 `j` 取得落後誤差 `ferr`。

#### `axis-ignore-dist! ( j --  ) ( F: dist -- )`

設定指定運動軸 `j` 可忽略的長度計算誤差 `dist`。

通常在 pulse 的系統下，設定為 0.5 或是 0.1 [pulse]。其它設定為 0.5e-6 或是 0.1e-6 [m] or [rad]

#### `axis-len ( -- len )`

取得 Botnana Control 所規劃的運動軸總數 `len`。

#### `axis-real-p@ ( j -- )(F: -- pos )`

取得運動軸 `j`的實際位置 `pos` 。

#### `axis-rest?  ( j -- flag )`

運動軸 `j` 命令是否靜止？

可以利用此狀態作為不同落後誤差或是雙位置回授誤差的監控條件切換。

#### `axis-ts! ( j -- ) ( F: ts -- )`

設定用來判定運動軸 `j` 命令是否靜止的安定時間 `ts` sec。

#### `axis-vmax! ( j -- ) ( F: vmax -- )`

設定運動軸 `j` 的最大速度 `vmax`。

命令範例：

    0.5e 1 axis-vmax!  \ 設定 Axis 1 vmax 為 0.5

#### `axis-vmax@ ( j -- ) ( F: -- vmax )`

取得運動軸 `j` 的最大速度 `vmax`。

#### `axis>pulse ( j -- pulse ) ( F: pos -- )`

轉換運動軸 `j` 的命令位置 `pos` 為編碼器脈波位置 `pulse`。

#### `cl-cutoff! ( j -- ) ( F: freq -- )`

設定運動軸 `j` 雙位置回授誤差濾波器的截止頻率 `freq`。

此截止頻率影響雙位置回授誤差的計算，如果調高，運動響應會比較貼近外部編碼器的回授位置，但是系統會比較不穩定。

#### `drv-alias!  ( drive-alias j -- )`

使用 EtherCAT Station Alias `drive-alias` 指定運動軸 `j` 馬達驅動器。

當 `drive-alias` = 0 表示使用 slave position 指定馬達驅動器。 當 `drive-alias` 不存在時，此運動軸就會以虛擬軸處理。

#### `drv-channel!  ( drive-channel j -- )`

使用 `drive-channel` 指定運動軸 `j` 馬達驅動器的控制軸。

因應單一 EtherCAT 從站多軸驅動器的模組型態，所以必須要使用此一參數。一般驅動器則是固定設定為 1。

命令範例：

    1 3 drv-channel! \ 設定 Axis 3 對應的馬達驅動器的控制軸為 1

#### `drv-slave!  ( drive-slave j -- )`

使用 EtherCAT Slave Position `drive-slave` 指定運動軸 `j` 馬達驅動器站號。

命令範例：

    2 1 drv-slave!  \ 設定 Axis 1 對應的馬達驅動器站號為 2

#### `enc-dir! ( dir j -- ) `

設定運動軸 `j` 馬達運動/編碼器方向 `dir`。

當機器的軸向與馬達的運轉方向定義相反時可以藉由此參數來轉換。

dir 可以設定的值為：

* 1: 同方向
* -1: 反方向

命令範例：

    1 3 enc-dir!  \ 設定 Axis 3 編碼器方向

#### `enc-ppu! ( j --) ( F: ppu -- )`

設定運動軸 `j` 距離單位對應馬達編碼器的脈波數 `ppu`

命令範例可以參考 `enc-u!`

#### `enc-u! ( u j -- )`

設定運動軸 `j` 馬達編碼器的脈波數對應的距離單位 `u`。

可以設定的單位有：

* u = 0 as Meter,
* u = 1 as Revolution
* u = 2 as Pulse

命令範例：

    1000000.0e 3 enc-ppu! \ 設定 Axis 3 的編碼器單位距離的脈波數為 1000000.0
    0 3 enc-u!            \ 設定 Axis 3 的編碼器單位距離為 1 m
                          \ 表示 1 m 有 1000000 個 pulse (編碼器脈波數), 1 pulse 為 1 um

#### `ext-enc-alias! ( enc-alias j -- )`

使用 EtherCAT Station Alias 指定外部編碼器。參考 `drive-alias!`。

#### `ext-enc-channel! ( enc-channel j -- )`

指定外部編碼器的量測管道。參考 `drive-channel!`。

#### `ext-enc-dir! ( dir j -- )`

指定外部編碼器的方向。參考 `enc-dir!`。

#### `ext-enc-ofs!  ( j -- )( F: ofs -- )`

指定運動軸 `j` 外部編碼器的位置偏移量 `ofs`。

如果外部編碼器是絕對式型態，可以使用此命令調整外部編碼器由脈波數換算到物理位置的區間。

以海德漢長度 80 mm 絕對式光學尺為例，可以使用的區間範圍是 20 ~ 100 mm。
如果安裝方向與運動方向相反就會變成 -100 mm ~ -20 mm。
為了將換算出來的調整為 20 ~ 100 mm，就可以使用此命令來進行調整。

##### `ext-enc-ppu!  ( j -- )( F: ppu -- )`

設定運動單位距離對應外部編碼器的脈波數。參考 `enc-ppu!`。單位距離則是依 `enc-u!`設定。

#### `ext-enc-slave!  ( enc-slave j -- )`

使用 EtherCAT Slave Position 指定外部編碼器。參考 `drive-slave!`。

#### `hmofs! ( j -- ) ( F: ofs -- )`

設定運動軸 `j` 機械零點的座標偏移量。

命令範例：

    0.5e 3 hmofs! \ 設定 Axis 3 home offset

#### `homed?  ( j -- flag )`

取得運動軸 `j` 是否回歸機械原點的狀態?

#### `max-pos-dev! ( j -- ) ( F: max-dev -- )`

設定運動軸 `j` 雙位置回授的最大命令修正量 `max-dev`。避免當傳動系出現問題或是參數配置錯誤時，修正量無法收斂到固定值的狀況發生。

#### `virtual-axis?  ( j -- flag )`

運動軸 `j` 是否為虛擬軸？

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

| 指令 | 堆疊效果                       | 說明 |
|-----|------------------------------|---|
| .axis             | ( j -- )                      | 顯示運動軸狀態
| .axiscfg          | ( j -- )                      | 顯示運動軸設定
| +homed            | ( j -- )                      | 設定運動軸已回歸機械原點
| -homed            | ( j -- )                      | 設定運動軸未回歸機械原點
| 0axis-ferr        | ( j -- )                      | 清除落後誤差
| axis-aff!         | ( j -- ) ( F: aff -- )        | 設定加速度前饋增益 （功能未實現）
| axis-afactor!     | ( j -- ) ( F: afactor -- )    | 設定加速度前饋命令轉換常數 （功能未實現）
| axis-amax!        | ( j -- ) ( F: amax -- )       | 設定運動軸最大加速度
| axis-amax@        | ( j -- ) ( F: -- amax )       | 取得運動軸最大加速度
| axis-clerr        | ( j --  ) ( F: clerr -- )     | 取得雙位置回授誤差
| axis-cmd-p!       | ( j -- ) ( F: pos -- )        | 設定運動軸的目標位置
| axis-cmd-p@       | ( j -- ) ( F: -- pos )        | 取得運動軸的目標位置
| axis-demand-p@    | ( j -- ) (F: -- pos )         | 取得運動軸現在的命令位置
| axis-drive@       | ( j --  channel slave )       | 取得馬達驅動器的 EtherCAT 站號
| axis-ext-enc@     | ( j --  channel slave )       | 取得外部編碼器的 EtherCAT 站號
| axis-ferr@        | ( j --  ) ( F: ferr -- )      | 取得落後誤差
| axis-ignore-dist! | ( j --  ) ( F: dist -- )      | 設定可以忽略的長度計算誤差
| axis-len          | ( -- len )                    | 取得運動軸總數
| axis-real-p@      | ( j -- ) (F: -- pos )         | 取得運動軸實際位置
| axis-rest?        | ( j -- flag )                 | 運動軸命令是否靜止？
| axis-ts!          | ( j -- ) ( F: ts -- )         | 設定用來判定運動軸命令是否靜止的安定時間
| axis-vff!         | ( j -- ) ( F: vff -- )        | 設定速度前饋增益 （功能未實現）
| axis-vfactor!     | ( j -- ) ( F: vfactor -- )    | 設定速度前饋命令轉換常數 （功能未實現）
| axis-vmax!        | ( j -- ) ( F: vmax -- )       | 設定運動軸的最大速度
| axis-vmax@        | ( j -- ) ( F: -- vmax )       | 取得運動軸的最大速度
| axis>pulse        | ( j -- pulse ) ( F: pos -- )  | 轉換運動軸的位置為編碼器脈波位置
| cl-cutoff!        | ( j -- ) ( F: freq -- )       | 設定雙位置回授誤差濾波器的截止頻率
| drv-alias!        | ( drive-alias j -- )          | 使用 EtherCAT Station Alias 指定馬達驅動器
| drv-channel!      | ( drive-channel j -- )        | 指定馬達驅動器的控制軸
| drv-slave!        | ( drive-slave j -- )          | 使用 EtherCAT Slave Position 指定馬達驅動器
| enc-dir!          | ( dir j -- )                  | 設定馬達運動/編碼器方向
| enc-ppu!          | ( j -- )( F: ppu -- )         | 設定運動距離單位對應馬達編碼器的脈波數
| enc-u!            | ( u j -- )                    | 設定馬達編碼器的脈波數對應的距離單位
| ext-enc-alias!    | ( enc-alias j -- )            | 使用 EtherCAT Station Alias 指定外部編碼器
| ext-enc-channel!  | ( enc-channel j -- )          | 指定外部編碼器的量測管道
| ext-enc-dir!      | ( dir j -- )                  | 指定外部編碼器的方向
| ext-enc-ofs!      | ( j -- )( F: ofs -- )         | 指定外部編碼器的位置偏移量
| ext-enc-ppu!      | ( j -- )( F: ppu -- )         | 設定運動距離單位對應外部編碼器的脈波數
| ext-enc-slave!    | ( enc-slave j -- )            | 使用 EtherCAT Slave Position 指定外部編碼器
| hmofs!            | ( j -- ) ( F: ofs -- )        | 設定機械零點的座標偏移量
| homed?            | ( j -- flag )                 | 取得運動軸是否回歸機械原點的狀態
| max-pos-dev!      | ( j -- ) ( F: max-dev -- )    | 設定雙位置回授的最大命令修正量
| virtual-axis?     | ( j --  flag )                | 運動軸是否為虛擬軸？

---
### 單軸運動

命令針對單一運動軸，可以同時讓多個運動軸同時運行。如果該運動軸受到軸組控制則不可執行單軸運動。

#### `+interpolator ( j -- )`

啟動 Axis `j` 單軸運動。

#### `-interpolator ( j -- )`

關閉 Axis `j` 單軸運動。如果單軸運動中，會以當下的速度開始減速到 0。

#### `interpolator-v! ( j -- )（ F: v -- ）`

設定 Axis  `j` 單軸運動的最大速度。

#### 單軸運動範例

以 Axis 1 為例：

    +coordinator                       \ 啟動軸組功能
    1  +interpolator                   \ 啟動 Axis 1 單軸運動
    100.0e  mm/min  1  interpolator-v! \ 設定 Axis 1 單軸運動速度為 100.0 mm/min
    0.3e  1  axis-cmd-p!               \ 設定 Axis 1 的目標位置為座標位置 0.3 m 
    1 axis-demand-p@                   \ 取得 Axis 1 目前的命令位置
    1 axis-real-p@                     \ 取得 Axis 1 目前的實際位置

#### 本節指令集

| 指令 | 堆疊效果                         | 說明 |
|-----|---------------------------------|-----|
| +interpolator         | ( j -- )            | 啟動單軸運動
| -interpolator         | ( j -- )            | 關閉單軸運動
| interpolator?         | ( j -- flag )       | 單軸運動是否開啟？
| interpolator-reached? | ( j -- flag )       | 單軸運動是否到達目標點？
| interpolator-v!       | ( j -- ) (F: v -- ) | 設定單軸運動速度

---
### Pitch Corrector

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

| 指令 | 堆疊效果                       | 說明 |
|-----|------------------------------|------|
| .pcorr |( channel n -- )                                                  | 輸出目前 Pitch Corrector 的查表結果
| .pcorr-entry  |( index channel n -- )                                     | 輸出指定補正表欄位內容
| +pcorr        |( channel n -- )                                           | 啟動補正功能
| -pcorr        |( channel n -- )                                           | 關閉補正功能
| >pcorr        |( channel n -- )                                           | 讀取檔案內容到控制器內
| pcorr>        |( channel n -- )                                           | 輸出補正表到檔案
| pcorr-entry!  |( index channel n -- ) ( F: position forward backward -- ) | 設定補正表欄位
| pcorr-factor! |( channel n -- ) ( F: factor -- )                          | 設定補正表欄位的轉換係數
| pcorr-resize  |( len channel n -- )                                       | 調整補正表的欄位大小
