### Host primitives

#### `mtime ( -- n )`

Current time in milliseconds

#### `.cpu-timing ( -- )`

Print information of CPU timing

#### `0cpu-timing ( -- )`

Reset CPU timing

#### `.verbose ( -- )`

Print verbose infornatiom

回傳訊息範例 :

    version_number|1.3.1|period_us|2000|launch_time|2018-08-09T10:19:21Z

#### `.motion ( -- )`
    
Print information of motion.

只能透過 Json API 進行設定。
 
命令範例:

    .motion

回傳訊息：

    period_us|2000
    |group_capacity|7
    |axis_capacity|10 

#### 本節指令集

| 指令 | 堆疊效果       |
|-----|---------------|
| `mtime`        | ( -- n ) |
| `.cpu-timing` | ( -- ) |
| `0cpu-timing` | ( -- ) |
| `.verbose`     | ( -- ) |
| `.motion`     | ( -- ) |

---

### 定時器指令 （timer）

可以使用的定時器總計有 100 個，編號從 1 ~ 100。

內部使用的計時單位是 Nanosecond，64 bits 的無號長整數計數，整個時間周期可以接近 500 年而不溢位。

定時器的定時時間使用 32 bits 的有號整數設定， 所以可以設定最長的時間是 24.8 天。

使用範例：

```
   100 1 timer-dur-ms!  \ 設定編號 1 定時器的計時時間為 100 ms。
   1 0timer             \ 定時器編號 1 重新計時。
   1 timer-expired? .   \ 檢視定時器編號 1 是否已經超過計時時間。
```

#### `.timer ( no -- )`

顯示定時器編號 `no` 的狀態。

命令範例:

    1 .timer

回傳訊息：

    timer_name.1|None|timer_duration.1|0.0 ms|
    timer_expired.1|1|elapsed_time.1|307537.1 ms|
    start_time.1|0.0 ms|current_time.1|307537.1 ms

#### `0timer ( no -- )`

定時器編號 `no` 重新計時。

#### `timer-dur-ms! ( ms no -- )`

設定定時器編號 `no` 的計時時間為 `ms` Millisecond。

#### `timer-dur-us!  ( us no -- )`

設定定時器編號 `no` 的計時時間為 `us` Microsecond。

#### `timer-expired?  ( no -- t )`

定時器編號 `no` 是否已經超過計時時間？

#### 本節指令集

| 指令 | 堆疊效果       |
|-----|---------------|
| `.timer`     | ( no -- ) |
| `0timer`     | ( no -- ) |
| `timer-dur-ms!`     | ( ms no -- ) |
| `timer-dur-us!`     | ( us no -- ) |
| `timer-expired?`     | ( no -- t ) |

---

### 數位正反器 （Flip-flop）

數位正反器可用來偵測數位訊號狀態轉移，可以偵測的型態有：

* 高準位觸發(High Level Trigger）
* 低準位觸發(Low Level Trigger）
* 上緣觸發 (Rising Edge Trigger）
* 下緣觸發 (Falling Edge Trigger）

**高準位觸發條件**

```
 True              +--------------
                   |
 False ------------+

                   |-----------|
                     Hold Time

   只要滿足 Hold Time 的時間，數位正反器就會切換為真（True）的狀態，
   反之則為假（False）。

   當條件滿足，數位正反器可以一直持續輸出為 True，直到原始訊號轉態為 False。

```

**低準位觸發條件**

```
 True  ------------+
                   |
 False             +--------------

                   |-----------|
                     Hold Time

   只要滿足 Hold Time 的時間，數位正反器就會切換為真（True）的狀態，
   反之則為假（False）。

   當條件滿足，數位正反器可以一直持續輸出為 True，直到原始訊號轉態為 True。

```

**上緣觸發條件**

```
 True              +---------
                   |
 False ------------+

         |---------|------|
           Set-up    Hold
           Time      Time

   要同時滿足 Set-up time 與 Hold Time 的時間，數位正反器才會切換為真（True）的狀態，
   反之則為假（False）。

   因為是邊緣觸發，所以數位正反器只有一個周期的輸出為 True。

```

**下緣觸發條件**

```
 True  ------------+
                   |
 False             +---------

         |---------|------|
           Set-up    Hold
           Time      Time

   要同時滿足 Set-up time 與 Hold Time 的時間，數位正反器才會切換為真（True）的狀態，
   反之則為假（False）。

   因為是邊緣觸發，所以數位正反器只有一個周期的輸出為 True。

```

可以使用的數位正反器總計有 100 個，編號從 1 ~ 100。因為數位正反器常用於 SFC 邏輯內，為效率上的考量，
所以名稱是 `_uc` 結尾的指令沒有檢查編號是否在正確的範圍，所以使用上要特別留意。

使用範例：

```
   3 1 timer-dur-ms!      \ 設定數位正反器編號 1 為上緣觸發。
   2000 1 ff-setup!       \ 設定數位正反器編號 1 的建立時間。
   2000 1 ff-hold!        \ 設定數位正反器編號 1 的保持時間。
   true 1 ff-forth-uc     \ 設定數位正反器編號 1 的原始狀態，應該每個周期執行。
   ...
   1 ff-triggered-uc? .   \ 檢視數位正反器編號 1 是否已經觸發？
```

#### `.ff ( no -- )`

顯示數位正反器編號 `no` 的狀態。

命令範例:

    1 .ff

回傳訊息：

    ff_type.1|High Level|setup_time.1|2000|hold_time.1|2000|
    setup_count.1|0|hold_count.1|0|last.1|0|triggered.1|0

#### `ff-forth-uc ( t no -- )`

每個周期設定給數位正反器編號 `no` 的狀態 `t`。

**此命令沒有檢查堆疊個數與 `no` 範圍，使用上要特別注意。**

#### `ff-hold! ( us no -- )`

設定數位正反器編號 `no` 的 Hold Time `us` Microsecond。

#### `ff-last-uc@ ( no -- t )`

數位正反器編號 `no` 最後/新的原始狀態？

**此命令沒有檢查堆疊個數與 `no` 範圍，使用上要特別注意。**

#### `ff-setup! ( us no -- )`

設定數位正反器編號 `no` 的 Setup Time `us` Microsecond。

#### `ff-triggered-uc? ( no -- t )`

數位正反器編號 `no` 是否滿足觸發條件？

**此命令沒有檢查堆疊個數與 `no` 範圍，使用上要特別注意。**

#### `ff-type! ( type no -- )`

設定數位正反器編號 `no` 的觸發型態 `type`。

觸發型態 `type` 設定值如下：

* 1: 高準位觸發
* 2: 低準位觸發
* 3: 上緣觸發
* 4: 下緣觸發

#### `has-ff? ( no -- t )`

是否有編號 `no` 的數位正反器？

#### `reset-ff ( no -- )`

重置數位正反器編號 `no`。不修改條件，只清除內部狀態。

#### 本節指令集

| 指令 | 堆疊效果       |
|-----|---------------|
| `.ff`     | ( no -- ) |
| `ff-forth-uc`     | ( t no -- ) |
| `ff-hold!`     | ( us no -- ) |
| `ff-last-uc@`     | ( no -- t ) |
| `ff-setup!`     | ( us no -- ) |
| `ff-triggered-uc?`     | ( no -- t ) |
| `ff-type!`     | ( type no -- ) |
| `has-ff?`     | ( no -- t ) |
| `reset-ff`     | ( no -- ) |
