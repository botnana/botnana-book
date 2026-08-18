## 設定檔

Botnana Control 將持久的機台設定儲存在
`/etc/botnana-control/motion.toml`。此檔案使用
[TOML](https://toml.io/) 格式。

支援的設定變更應優先使用內建 HMI。HMI 編輯具有版本檢查，並會以一份共用設定儲存。
HMI 尚有草稿或正在進行拓撲維護時，請勿編輯檔案。若經授權必須手動編輯，應先依現場
維修程序停止控制器，並備份完整檔案。即使設定檔語法正確，內容錯誤仍可能使控制器
無法啟動或造成非預期運動設定。

儲存設定不會改變運作中的控制器。**Active controller** 會保留控制器成功啟動時選用
的值，直到之後的受控啟動選用已儲存設定為止。一般 **Rescan EtherCAT** 會使用上次
正常運作設定，不會使用剛儲存的值。

### File 及 Server 區段

| TOML 欄位 | 意義 | 預設值 |
|---|---|---|
| `[file].spec_version` | 機台設定格式版本。 | `"0.0.1"` |
| `[server].address` | Motion Server 監聽位址；不是控制器網路介面的設定。 | `"0.0.0.0:3012"` |

若要變更控制器網路位址，請使用 HMI **About** 程序，不要修改
`[server].address`。

### Motion 區段

`[motion]` 區段管理控制器整體的運動控制及 EtherCAT 啟動值。

| TOML 欄位 | 預設值及限制 | 作用 |
|---|---|---|
| `period_us` | `2000`；大於或等於 `1000` 微秒的整數。 | 即時運動控制週期。週期越短，所需處理頻率越高。 |
| `axis_capacity` | `10`；`1` 至 `24` 的整數。 | 可用軸設定數量，也是軸組映射的軸編號上限。 |
| `group_capacity` | `2`；正整數。 | 可用軸組設定數量。 |
| `boot_retry_window_ms` | `120000`；以毫秒表示的非負整數。 | EtherCAT 主站取得重試時間；不是完整的就緒逾時。 |

`boot_retry_window_ms` 不是完整的控制器就緒逾時。取得可接受的 EtherCAT 候選主站
後，設定、啟用及就緒檢查會保留仍較晚的既有期限；若既有期限不足，則取得至少 30 秒
的新就緒時間範圍。

### EtherCAT 從站及裝置區段

每個已儲存的 EtherCAT 從站以 `[[slaves]]` 表示。

| TOML 欄位 | 意義 |
|---|---|
| `protocol` | 從站通訊協定；EtherCAT 從站使用 `"EtherCAT"`。 |
| `alias` | 設定的 EtherCAT 別名。 |
| `position` | 從 1 起算的實體從站位置。 |
| `vendor_id` | 預期的 EtherCAT 供應商識別碼，以十進位整數儲存。 |
| `product_code` | 預期的 EtherCAT 產品代碼，以十進位整數儲存。 |
| `wd_proc_data_enabled` | 設為 `true` 時啟用從站程序資料看門狗。 |
| `devices` | 產品專用通道及裝置設定；有內容時在 TOML 中寫成 `[[slaves.devices]]`。 |

在內建 **Slave Configuration** 編輯器中，供應商 ID 及產品代碼永遠是唯讀。實體
身分、順序或別名若有變更，應使用引導式拓撲維護程序檢查，不可當成一般設定值編輯。

裝置欄位依偵測到的產品而異，可能包括原點復歸方法、原點偏移、原點復歸速度、
加速度、輪廓限制、I/O 選擇、編碼器設定或產品專用程序資料設定。只使用 **Slave
Configuration** 對該裝置顯示的欄位，或遵循適用的產品試車說明；不要複製其他產品
的裝置區塊。

### Group 區段

每個 `[[group]]` 項目定義一個協同運作的軸組。

| TOML 欄位 | 意義 | 新軸組預設值或限制 |
|---|---|---|
| `position` | 從 1 起算的軸組編號。 | 必須在 `group_capacity` 範圍內。 |
| `name` | 操作者可見的軸組名稱。 | `"Anonymous"` |
| `gtype` | 軸組幾何類型。 | `"1D"`；可用值為 `"1D"`、`"2D"`、`"3D"` 及 `"SINE"`。 |
| `mapping` | 軸組使用且從 1 起算的軸編號。 | `[1]`；`1D` 或 `SINE` 使用一軸、`2D` 使用兩軸、`3D` 使用三軸，且每個編號必須在 `axis_capacity` 範圍內。 |
| `vmax` | 依設定工程單位表示的軸組最大速度。 | `0.1`；必須為正值。 |
| `amax` | 依設定工程單位表示的軸組最大加速度。 | `5.0`；必須為正值。 |
| `jmax` | 依設定工程單位表示的軸組最大加加速度。 | `80.0`；必須為正值。 |
| `ignorable_distance` | 可視為已完成的剩餘距離。 | `0.0000005`；必須為正值。 |

### Axis 區段

每個 `[[axis]]` 項目定義一軸。**Axis Group** 會依功能分組顯示這些欄位。

| TOML 欄位 | 意義及限制 | 新軸預設值 |
|---|---|---|
| `position`、`name`、`home_offset` | 從 1 起算的軸編號、操作者可見名稱及原點偏移。編號必須在 `axis_capacity` 範圍內。 | 名稱 `"Anonymous"`；偏移 `0.0`。 |
| `encoder_length_unit` | 軸的工程單位；可用形式代表公尺、轉、脈衝或使用者自訂單位。 | `"Meter"` |
| `encoder_ppu`、`encoder_direction` | 主編碼器每單位脈衝數及方向。每單位脈衝數必須為正值；方向為 `1` 或 `-1`。 | `1000000.0`、`1` |
| `ext_encoder_ppu`、`ext_encoder_direction` | 選用外部編碼器的比例及方向，限制相同。 | `1000000.0`、`1` |
| `closed_loop_filter`、`max_position_deviation` | 全閉迴路濾波器頻率（Hz）及允許的位置偏差，兩者皆須為非負值。 | `30.0`、`0.001` |
| `vmax`、`amax`、`ignorable_distance` | 依設定工程單位表示的軸速度限制、加速度限制及完成容許值，皆須為正值。 | `0.1`、`5.0`、`0.0000005` |
| `vff`、`vfactor`、`aff`、`afactor` | 速度與加速度前饋值及係數。 | `0.0`、`1.0`、`0.0`、`1.0` |
| `drive_alias`、`drive_slave_position`、`drive_channel` | 軸驅動器的 EtherCAT 指派。 | 別名 `0`、從站位置等於新軸編號、通道 `1`。 |
| `ext_encoder_alias`、`ext_encoder_slave_position`、`ext_encoder_channel` | 選用外部編碼器的 EtherCAT 指派。 | `0`、`0`、`0` |

驅動器及編碼器指派會參照已儲存拓撲，但不會改變從站的供應商 ID 或產品代碼。任何
受控啟動後，都應在停用運動控制的狀態下確認裝置指派、方向、比例及限制。

### Timer 區段

每個 `[[timer]]` 項目包含從 1 起算的 `position` 及 `name`。1.14.4 的設定工作區不
顯示 Timer 設定；只有適用的整合說明要求時才能變更。

### 最小語法範例

下列範例只顯示 File、Server 及 Motion 語法，不是完整的機台設定，不可取代已完成
試車的控制器檔案。

```toml
[file]
spec_version = "0.0.1"

[server]
address = "0.0.0.0:3012"

[motion]
period_us = 2000
axis_capacity = 10
group_capacity = 2
boot_retry_window_ms = 120000
```

儲存前，請使用 **Slave Configuration**、**Motion** 及 **Axis Group** 檢查支援的
設定及共用的待處理變更清單。
