### EtherCAT IO 指令集

EtherCAT IO 包含以下部份：

1. EtherCAT DIN/DOUT/AIN/AOUT 模組。單一種或是綜合的訊號模組。
2. EtherCAT PWM 模組。目前只有支援 BECKHOFF EL2502 模組。因為該模組可以使用同步命令（PDO）控制 PWM Period 與 Duty。如果是非同步命令 （SDO）的控制方式，使用 SDO upload/download 命令即可。

---
#### `+ec-ain ( ch n -- )`

開啟 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸入。

如選用的類比輸入從站，需要開啟類比輸入管道才能讀到量測值，就可以使用此以指令。

命令範例:

    1 6 +ec-ain  \ 開啟 EtherCAT 從站編號 6，第 1 管道的類比輸入。

#### `+ec-aout ( ch n -- )`

開啟 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸出。

如選用的類比輸出從站，需要開啟類比輸出管道才能輸出訊號，就可以使用此以指令。

命令範例:

    1 2 +ec-aout  \ 開啟 EtherCAT 從站編號 2，第 1 管道的類比輸出。

#### `+pwm-user-scale ( ch n -- )`

開啟 EtherCAT 從站編號 `n`，第 `ch` 管道的 PWM 自定義工作循環命令功能。

#### `-ec-ain ( ch n -- )`

關閉 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸入。

命令範例:

    1 6 -ec-ain  \ 關閉 EtherCAT 從站編號 6，第 1 管道的類比輸入。

#### `-ec-aout ( ch n -- )`

關閉 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸出。

命令範例:

    1 2 -ec-aout  \ 關閉 EtherCAT 從站編號 2，第 1 管道的類比輸出。

#### `-pwm-user-scale ( ch n -- )`

關閉 EtherCAT 從站編號 `n`，第 `ch` 管道的 PWM 自定義工作循環命令功能。

#### `ec-ain@ ( ch n -- value )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸入

命令範例:

    1 6 ec-ain@  \ 取得 EtherCAT 從站編號 6，第 1 管道的類比輸入

#### `ec-ain-error  ( ch n -- error )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸入是否有錯誤。

BECKHOFF AI 模組有提供此一狀態，其錯誤的狀況有以下兩種：

* Over range
* Under range

#### `ec-ain-validity  ( ch n -- validity )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸入是否有效。

BECKHOFF AI 模組有提供此一狀態，表示該管道資料有正確地被主站使用 EtherCAT PDO 讀取。
原始資料 `0 = valid, 1 = invalid`，為避免字義上混淆，主站在取得資料時就進行反向的操作。

#### `ec-aout! ( value ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸出為 `value`。

命令範例:

    100 1 2 ec-aout!  \ 設定 EtherCAT 從站編號 2，第 1 管道的類比輸出為 100

#### `ec-aout@ ( ch n -- value )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的類比輸出 `value`。

    1 2 ec-aout@  \ 取得 EtherCAT 從站編號 2，第 1 管道的類比輸出

#### `ec-din@ ( ch n -- t=on )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的數位輸入訊號 `t=on`。

命令範例:

    3 5 ec-din@  \ 取得 EtherCAT 從站編號 5 的第 3 管道的數位輸入訊號

#### `ec-dout! ( t=on channel n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道的數位輸出訊號為 `t=on`。

命令範例:

    1 2 3 ec-dout!  \ 設定 EtherCAT 從站編號 3，第 2 管道的數位輸出訊號為 1

#### `ec-dout@ ( ch n -- t=on )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道的數位輸出訊號 `t=on`。

命令範例:

    2 3 ec-dout@  \ 取得 EtherCAT 從站編號 3 的第 2 管道的數位輸出訊號

#### `ec-wdout!  ( value index n -- )`

以 32 bits 命令資料 `value` 與編號 `index` 設定 EtherCAT 從站編號 `n` 的數位輸出訊號。

命令範例:

    $11 1 2 ec-wdout!  \ 設定 EtherCAT 從站編號 2，第 1 與 5 管道的數位輸出。
    1   2 2 ec-wdout!  \ 設定 EtherCAT 從站編號 2，第 33 管道的數位輸出。

#### `max-pwm-period@  ( n -- period )`

取得 EtherCAT 從站編號 `n`， PWM 模組支援的最大周期時間 `period` [us]。

#### `min-pwm-period@  ( n -- period )`

取得 EtherCAT 從站編號 `n`， PWM 模組支援的最小周期時間 `period` [us]。

#### `pwm-def-out!  ( output ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號， 在通訊錯誤時的工作循環預設值 `output`。

#### `pwm-def-out-ramp!  ( ramp ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號， 在通訊錯誤時的工作循環斜降率 `ramp`。

### `pwm-duty!  ( duty ch n -- period )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號的工作循環 `duty`。工作循環物理值可以參考 `pwm-presentation!`指令。

#### `pwm-duty@  ( ch n -- duty )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號的工作循環 `duty`。

#### `pwm-period!  ( period ch n -- period )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號輸出周期 `period` [us]。

#### `pwm-period@  ( ch n -- period )`

取得 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號輸出周期 `period` [us]。。

#### `pwm-presentation!  ( presentation ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號工作循環解析度 `presentation`。

BECKHOFF EL2502 可以設定的模式有：

| Presentation | Duty 設定說明 |
|-------|-----|
| 0 (Signed presentation) | 有效值 0 ~ 0x7FFF， 0x3FFF 表示 50 % Duty|
| 1 (Unsigned presentation) | 有效值 0 ~ 0xFFFF，0x7FFF 表示 50% Duty |
| 2 (Absolute value with MSB as sign) | 3276 表示 10 % duty, -3276 表示 90 % duty |
| 3 (Absolute valuen) | 3276 表示 10 % duty, -3276 也表示 10 % duty |

#### `pwm-wdt!  ( wdt ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號，當通訊錯誤時，訊號輸出模式 `wdt`。

BECKHOFF EL2502 可以設定的模式有：

* 0: Default watchdog value
* 1: Watchdog ramp active
* 2: Last output value active

#### `pwm-user-gain!  ( gain ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號自定義工作循環命令增益 `gain`。

參考 BECKHOFF EL2502 文件中針對 Object 0x8000:0x01 的說明。

#### `pwm-user-offset!  ( offset ch n -- )`

設定 EtherCAT 從站編號 `n`，第 `ch` 管道 PWM 訊號自定義工作循環命令偏移量 `offset`。

#### 本節指令集

| 指令 | 堆疊效果 | 說明 |
|-----|---------|-----|
| +ec-ain           | ( ch n -- )               | 啟動 AIN 功能
| +ec-aout          | ( ch n -- )               | 啟動 AOUT 功能
| +pwm-user-scale   | ( ch n -- )               | 啟動 PWM 自定義工作循環命令功能
| -ec-ain           | ( ch n -- )               | 關閉 AIN 功能
| -ec-aout          | ( ch n -- )               | 關閉 AOUT 功能
| -pwm-user-scale   | ( ch n -- )               | 關閉 PWM 自定義工作循環命令功能
| ec-ain@           | ( ch n -- value )         | 取得 AIN 量測值
| ec-ain-error      | ( ch n -- error )         | 取得 AIN 量測值是否有錯誤
| ec-ain-validity   | ( ch n -- validity )      | 取得 AIN 量測值是否有效
| ec-aout!          | ( value ch n -- )         | 設定 AOUT
| ec-aout@          | ( ch n -- value )         | 取得 AOUT
| ec-din@           | ( ch n -- t=on )          | 取得 DIN
| ec-dout!          | ( t=on ch n -- )          | 設定 DOUT
| ec-dout@          | ( ch n -- t=on )          | 取得 DOUT
| ec-wdout!         | ( value index n -- )      | 設定 DOUTs
| max-pwm-period@   | ( n -- period )           | 取得 PWM 模組支援的最大周期時間
| min-pwm-period@   | ( n -- period )           | 取得 PWM 模組支援的最小周期時間
| pwm-def-out!      | ( output ch n -- )        | 當通訊錯誤時，PWM 工作循環的預設值
| pwm-def-out-ramp! | ( ramp ch n -- )          | 當通訊錯誤時，PWM 工作循環的斜降率
| pwm-duty!         | ( duty ch n -- )          | 設定 PWM 工作循環
| pwm-duty@         | ( ch n -- duty )          | 取得 PWM 工作循環
| pwm-period!       | ( period ch n -- )        | 設定 PWM 輸出周期
| pwm-period@       | ( ch n -- period )        | 取得 PWM 輸出周期
| pwm-presentation! | ( presentation ch n -- )  | 設定 PWM 工作循環解析度
| pwm-wdt!          | ( wdt ch n -- )           | 當通訊錯誤時，PWM 輸出模式
| pwm-user-gain!    | ( gain ch n - )           | PWM 自定義工作循環命令增益
| pwm-user-offset!  | ( offset ch n -- )        | PWM 自定義工作循環命令偏移量
