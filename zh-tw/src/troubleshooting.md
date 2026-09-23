# 故障排除與診斷指南 (Troubleshooting & Diagnostics Guide)

本指南旨在協助自動化工程師、電控人員與軟體開發者在開發機器或撰寫自訂 HMI (如 C/C++ `libbotnana`) 時，快速診斷並排除馬達無法運轉、通訊異常或控制模式不符等常見問題。

---

## 1. 快速診斷決策表 (Diagnostic Decision Table)

當遇到驅動器或軸無法運動時，請依照下表逐一比對症狀、檢查項目與排除方法：

| 症狀現象 | 根本原因 | 快速檢查方法 | 排除步驟 |
| :--- | :--- | :--- | :--- |
| **馬達已激磁 (Servo On)，但下 Jog 或目標位置後完全不動** | **操作模式不匹配**：在 **CSP 模式** 下發送了 PP 指令（如 `target-p!` 與 `go`），或控制器仍處於開機預設的 **HM (原點) 模式**。 | 查詢即時操作模式：<br>Forth: `1 1 op-mode .`<br>或監聽 tag `real_operation_mode.1.1` | • 若要使用單軸點對點點動，**必須先切換為 PP 模式**：<br>`pp 1 1 op-mode! until-no-requests`<br>• 若在 CSP 模式下，請勿使用 `target-p!` 與 `go`，請改用軸組插補指令。 |
| **在 CSP 模式下下運動指令不動或報錯** | **軸組未設定 (Unconfigured Axis Group)**：驅動器未在 `motion.toml` 中綁定至軸 (Axis) 與軸組 (Group)。 | 查詢軸與組組態：<br>`1 .slave 1 .axiscfg 1 .grpcfg`<br>或檢查 Web HMI 中的 Axis 與 Group 頁面。 | 在 Web HMI 中建立軸 (Axis 1) 並綁定對應驅動器，建立軸組 (Group 1, 1D/2D/3D) 並將軸納入群組，儲存並重啟控制器。 |
| **下 Jog 或運動指令時馬達完全無力 (自由旋轉)** | **PDS 狀態未進入 Operation Enabled**：驅動器處於 Switch On Disabled (1)、Ready to Switch On (2) 或故障 (Fault) 狀態。 | 查詢 PDS 狀態：<br>Forth: `1 1 pds-state .`<br>(正常激磁應回傳 `4`)<br>或查詢驅動器狀態字 `0x6041`。 | 依序清除故障並下達激磁指令：<br>`1 1 reset-fault 1 1 drive-on until-drive-on` |
| **在 PP 模式下下 `go` 後，立即回報到達 (`target-reached`) 但軸完全沒轉** | **Profile 速度或加速度為 0**：驅動器暫存記憶體 (RAM) 中的 `profile_velocity` (`0x6081`) 或加速度為 0。 | 查詢目標速度：<br>Forth: `1 1 profile-v@ .` | 設定有效的運行速度與加速度：<br>`100000 1 1 profile-v!`<br>`50000 1 1 profile-a1!`<br>再重新下達 `target-p!` 與 `go`。 |
| **EtherCAT 從站無法進入 OP 狀態 (卡在 PREOP 或 SAFEOP)** | **硬體接線不良、配置不符或 DC 分散式時鐘同步失敗**。 | 在 Web HMI **Detected Slaves** 檢視 **AL State** 欄位，或在終端機執行 `list-slaves`。 | 1. 檢查線路與接頭指示燈。<br>2. 若在 CSP 模式下，確認該型號驅動器支援並已啟用 EtherCAT DC 分散式時鐘。<br>3. 執行 **Rescan EtherCAT** 重新掃描匯流排。 |
| **自訂 C++ HMI 收到 `error\|No message_to_task_producer.`** | **WebSocket 終端作業階段 (Session) 超限**：Botnana Control 核心提供固定 **2 個** 即時使用者任務作業階段，已被多餘的瀏覽器分頁或連線佔滿。 | 檢查是否有開啟多個 Web HMI 瀏覽器分頁或多個用戶端程式。 | 關閉未使用的瀏覽器分頁；自訂 HMI 應用程式應保持單一持久 WebSocket 連線，避免頻繁重複連線。 |
| **自訂 C++ HMI 收到 `error\|Scripts buffer is fulled.`** | **指令發送頻率超出 Token Bucket 預算**：未做流量控制，連續爆發發送指令填滿了緩衝區。 | 檢查客戶端發送迴圈或輪詢 (Polling) 間隔。 | 遵循第三方 HMI 通訊標準：將相關指令合併在單一 `script.evaluate` 請求內發送，常態輪詢頻率維持在 100 req/s 以內。 |

---

## 2. CiA 402 操作模式核心機制：PP vs. CSP

在開發驅動器控制程式時，最常見的誤區是混淆了 **PP 模式** 與 **CSP 模式** 的運動控制責任歸屬：

```text
┌────────────────────────────────────────────────────────────────────────┐
│   PP Mode (Profile Position, Mode 1)                                   │
│   [Master: Botnana] ──(一次性下達 target-p! & go)──► [Drive onboard DSP]│
│                                                     (內部自行規劃 S 曲線)│
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│   CSP Mode (Cyclic Synchronous Position, Mode 8)                       │
│   [Master: Botnana Coordinator] ──(每 1ms 週期串流位置)──► [Drive]     │
│   (主站負責軌跡插補與軸組協同運算)                         (僅單純追隨位置)│
└────────────────────────────────────────────────────────────────────────┘
```

### PP 模式 (Profile Position, CiA 402 Mode 1)
* **軌跡計算位置**：在 **驅動器內部的 DSP**。
* **適用場景**：單軸點動 (Manual Jog)、單軸定點測試、換刀定位。
* **運作機制**：
  1. 主站下達目標位置 `0x607A` (`target-p!`) 與運動速度 `0x6081` (`profile-v!`)。
  2. 主站發送 `go` 指令（將 Controlword `0x6040` 第 4 位元 `New set-point` 設為 1）。
  3. 驅動器偵測到 Bit 4 觸發，在內部啟動加減速規劃並驅動馬達。
* **標準指令範例**：
  ```forth
  pp 1 1 op-mode! 100000 1 1 profile-v! until-no-requests
  1 1 drive-on until-drive-on
  250000 1 1 target-p! 1 1 go
  ```

### CSP 模式 (Cyclic Synchronous Position, CiA 402 Mode 8)
* **軌跡計算位置**：在 **Botnana Control 主站** 的 Coordinator 協同器。
* **適用場景**：多軸同動插補、線性切削、圓弧軌跡、機器人逆向運動學。
* **運作機制**：
  1. 驅動器內部的加減速規劃器完全被關閉。
  2. 驅動器 **完全忽略 Controlword 第 4 位元 (`go`)**。若在 CSP 模式下下達 `go`，驅動器不會有任何反應！
  3. Botnana Control 主站以 1 ms 週期計算群組路徑，並透過 EtherCAT PDO `0x607A` 每毫秒發送最新位置給驅動器。
  4. 靜態下達的 `target-p!` 會在下一毫秒被主站 Coordinator 的插補值立刻覆蓋。
* **重要前提**：
  * **必須設定軸組**：驅動器必須在 `motion.toml` 中綁定至軸 (Axis) 與軸組 (Group)。若無軸組，Coordinator 無法計算目標位置。
  * **必須啟用 Coordinator**：使用 `+coordinator` 指令。
* **標準指令範例** (`botnanac/examples/group1d.c`)：
  ```forth
  \ 1. 驅動器切換為 CSP 模式並激磁
  csp 1 1 op-mode! until-no-requests
  1 1 drive-on until-drive-on

  \ 2. 啟用協同器並建立軸組路徑
  +coordinator
  1 group! 0path 1 0axis-ferr +group

  \ 3. 透過群組插補指令下達運動 (而非 target-p! / go)
  0.05e vcmd!          \ 設定路徑速度
  10.0e move1d         \ 單軸群組運動 10 mm
  start-job            \ 啟動任務
  ```

### HM 模式 (Homing Mode, CiA 402 Mode 6)
* **注意**：Botnana Control 開機完成後，預設會將所有連線之驅動器設定為 **HM (原點復歸) 模式**。
* 在 HM 模式下，Controlword 第 4 位元代表 **Homing operation start**。若未切換模式就下達 `go`，驅動器會嘗試搜尋原點開關，而不會進行點對點位移！

---

## 3. 五秒快速健康檢查 (5-Second Quick Health Check)

當在現場遇到機器不動時，請在 Web HMI 的終端機、即時控制介面或透過 C++ 程式發送下列指令，5 秒內即可判別問題根因：

### 檢查指令清單

```forth
\ 1. 查詢 1 號從站 1 號通道驅動器的即時操作模式
1 1 op-mode .
\ 回傳: 1 -> PP 模式, 6 -> HM 模式, 8 -> CSP 模式

\ 2. 查詢驅動器 PDS 狀態
1 1 pds-state .
\ 回傳: 1 -> Switch on disabled, 2 -> Ready to switch on, 4 -> Operation enabled (正常激磁)

\ 3. 查詢驅動器是否有警報
1 1 error-code .
\ 回傳 0 表示無故障；若非 0 請查閱驅動器原廠手冊之 Error Code 代碼表

\ 4. 檢查軸與軸組組態
1 .axiscfg
1 .grpcfg
\ 若回傳為空或未設定，表示尚未於 motion.toml 完成軸組設定
```

---

## 4. 支援診斷套件收集與分析 (Support Diagnostics)

若問題仍無法解決，請匯出官方支援診斷套件以供工程分析：

1. 開啟 Web HMI，點擊右上角 **About (關於)**。
2. 點選 **Support diagnostics (支援診斷)**。
3. 點擊 **Download diagnostic log (下載診斷紀錄)**。
4. 將產生的 `botnana-support-<timestamp>.zip` 封裝檔案提供給支援團隊。

### 診斷檔案結構分析
* `metadata.json`：包含 Botnana Control 軟體版本、系統開機時間、`bnc-motion` 與 `bnc-hmi` 服務運行狀態及重啟次數。
* `logs/current/bnc-motion.jsonl`：包含 EtherCAT 拓撲掃描從站數量 (`slaveCount`)、啟動階段生命週期與 WebSocket 連線健康指標。
