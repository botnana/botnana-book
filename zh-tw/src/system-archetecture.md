# 系統架構

Botnana Control 1.14.4 將瀏覽器內容提供、設定與生命週期協調、具權限的軟體更新，
以及即時運動控制分開處理。因此，控制器執行環境故障時，不會自動移除 HMI 或已儲存
的機台設定。

## 部署概觀

```text
Operator browser                          Customer application
  | HTTP :3000       | WebSocket :3012        | WebSocket :3012
  v                  +--------------------+    |
+----------------------+                  v    v
| hmi-server           |             +------------------------+
| unprivileged HTTP    |             | motion-server          |
+----------+-----------+             | profile + lifecycle    |
           |                         +-----------+------------+
           | fixed local Unix socket             |
           v                           supervised runtime
+----------------------+                         |
| update-agent         |               +---------v------------+
| package inspection  |               | rtForth VM + motion  |
| and staging         |               | engine + EtherCAT HAL|
+----------------------+               +---------+------------+
                                                 |
                                       EtherCAT master / slaves
```

圖中的 `Operator browser` 是操作人員瀏覽器，`Customer application` 是客戶應用程式；
`profile + lifecycle` 表示設定與生命週期協調，`supervised runtime` 則表示受監督的
執行世代。圖內只使用 ASCII 文字，以確保 HTML 與 PDF 中的框線對齊。

瀏覽器會與控制器建立兩條獨立的網路連線：

- HTTP 連接埠 `3000` 用於取得封裝在套件內的 HMI，並執行經檢查的軟體更新程序。
- WebSocket 連接埠 `3012` 傳送控制器狀態、具有版本檢查的設定作業、即時值、命令及
  rtForth 求值要求。

客戶應用程式直接連至 Motion WebSocket。Rust `hmi-server` 不會代理即時流量，
`motion-server` 也不提供瀏覽器檔案。HMI JavaScript 套件會在建立 Debian 套件前
完成編譯；控制器不再需要部署 Node.js HTTP 伺服器。

## 程序及權限邊界

systemd 以分開的責任啟動已安裝元件。

| 元件 | 責任及邊界 |
|---|---|
| `bnc-update.service` | 只在開機時執行更新決策，而且早於一般 HMI 及 Motion 服務。每個已確認的受管理套件最多嘗試安裝一次。 |
| `update-agent` 常駐程序 | 管理套件檢查、具有版本號的更新狀態、不可分割的暫存、保留套件及 Motion 准入決策。固定的本機 socket 不接受任意路徑或 shell 命令。 |
| `hmi-server` | 以 systemd 動態使用者執行。它串流套件內的靜態檔案、寫入有界限的訊息記錄，並只將固定的更新操作轉交給 `update-agent`；不具套件管理程式或一般 root 權限。 |
| `motion-server` | 管理 WebSocket 伺服器、共用機台設定、EtherCAT 拓撲程序、執行環境監督器及目前的即時控制器世代。 |
| EtherCAT 服務及主站 | 管理硬體抽象層所使用的原生 EtherCAT 主站及裝置通訊。 |

開機更新會先得到終止決策，才允許 HMI 及 Motion 啟動。安裝失敗可能留下持久的
Motion 封鎖；此時會儘可能啟動 HMI，讓操作人員檢查結果並安排經檢查的復原套件，
而 `motion-server` 仍維持封鎖。

## Motion Server 及可替換的執行世代

`motion-server` 包含非即時伺服器／控制面，以及可替換的即時控制器世代。

```text
WebSocket connections
        |
        v
+-----------------------------------------------------------+
| Non-real-time motion-server control plane                 |
|                                                           |
| Request admission     Shared MachineProfile               |
| LiveConnectionRegistry RuntimeSupervisor                  |
| Configuration and topology request coordinators          |
+-------------------------------+---------------------------+
                                |
                      generation-bound channels
                                |
+-------------------------------v---------------------------+
| Runtime generation N                                      |
| request/response tasks <-> rtForth VM tasks               |
| controller task -> motion engine -> hardware abstraction  |
+-----------------------------------------------+-----------+
                                                |
                                      EtherCAT master
```

圖中的 `control plane` 是非即時控制面，`generation-bound channels` 是世代專用通道，
而 `Runtime generation N` 是可替換的第 N 個控制器執行世代。

程序層級的伺服器在控制器世代啟動、替換或故障時仍可使用。因此 HMI 可以繼續顯示
生命週期狀態、保留的拓撲證據及設定復原控制，而不會將無法取得的即時運動值顯示為正常。

主要擁有權邊界如下：

- `MachineProfile` 管理一份共用的已儲存設定，以及具有版本檢查的記憶體內草稿。
- `RuntimeSupervisor` 管理作用中世代、生命週期、最近一次 Ready 的建置計畫、啟動
  來源，以及最新一次完整的實體拓撲觀察。
- `LiveConnectionRegistry` 管理即時 WebSocket 成員、彙整作用中工作階段的有界限
  流量計數器，並在世代變更時分離或重新繫結每個工作階段。
- 每個 WebSocket 工作階段具有對兩個 rtForth 使用者工作之一的世代專用繫結。過期
  繫結不能將工作送至替換後的世代。

系統針對每條連線進行請求准入。可替換的最新值輪詢可以合併；未獲准的命令不會在之後
被默默重送。每條連線也具有有界限的輸出工作及佇列，因此緩慢或飽和的用戶端不會阻塞
其他用戶端的 WebSocket 事件迴圈。Botnana Control 仍最多提供兩個即時 rtForth
使用者工作階段。

內建 HMI 從 **About** 開啟的 **Support diagnostics** 畫面，可以要求一份不含請求
內容的快照，比較兩個作用中連線。登錄檔會標示提出要求的瀏覽器，只回報連線時間及
有界限的流量／准入計數器，並在連線關閉時移除該欄。系統不會保留流量歷史，也不會
包含對端位址、請求內容、回應或設定值。

另一個同源 HTTP 操作只會向 root 擁有的本機支援能力要求一項固定操作。該能力只讀取
`bnc-motion` 與 `bnc-hmi` 目前及前一次開機的記錄，輸出經允許的分類記錄及中繼資料，
並傳回一份不超過 10 MiB 的記憶體內 ZIP。非特權 HMI 不能選擇 journal 服務、開機、
路徑、命令或封存選項。此協作及即時比較都不屬於支援的客戶 JSON API。

## 控制器啟動及就緒

每個控制器世代都由不可變的 `ControllerBuildPlan` 建立。計畫包含該次嘗試所選用的
控制板、週期、Motion 設定、軸、軸組、計時器、EtherCAT 從站及啟動腳本。

只有在下列有界限的程序全部成功後，世代才會成為 **Ready**：

1. 掃描完整的實體 EtherCAT 鏈，但不採用掃描結果。
2. 比較每個預期位置上觀察到的供應商及產品身分。
3. 保留 EtherCAT 主站，並在保留的執行環境再次檢查連線、回應從站數、身分及已穩定
   的 PREOP 狀態。
4. 在控制器能力交給 VM 前，完成必要的裝置 mailbox 作業及 PDO 映射設定。
5. 啟用主站並執行即時控制器。
6. 等待必要的啟動 mailbox 作業完成、穩定的 OP 狀態，以及完整的程序資料工作計數器。
7. 發布 **Ready**，再將即時 WebSocket 工作階段繫結或重新繫結至該確切世代。

主站成功啟用本身不代表已經就緒。如果任何必要步驟失敗，或操作人員停止拓撲重試，
該世代會維持無法使用；伺服器會發布終止生命週期狀態，不會發布錯誤的 **Ready**。

## 重新啟動、復原及拓撲來源

不同操作會刻意選用不同的控制器計畫：

| 操作 | 控制器來源 |
|---|---|
| 程序初次啟動 | 從 `/etc/botnana-control/motion.toml` 載入的設定及已設定的啟動腳本。 |
| 一般 **Rescan EtherCAT** | 最近一次 Ready 世代的不可變建置計畫（**Last working settings**）；不會套用新儲存的設定編輯。 |
| 故障狀態下的 **Start controller** | 操作人員檢查過的確切已儲存設定版本；尚未儲存的變更會阻止此啟動。 |
| 拓撲變更的 **Approve, save, and start** | 由伺服器管理的核准操作所儲存之完整且確切的拓撲提案及設定。 |

一般替換執行環境時，監督器會停止接受舊世代的新工作、排空已接受要求、分離即時工作
階段、關閉舊世代，再以選定來源建立替換世代。系統會先重新繫結正常工作階段，才發布
**Ready**。如果一個工作階段無法重新繫結，只會關閉該工作階段；其他工作階段及正常
控制器仍可使用。

拓撲核准、持久儲存及啟動由控制器協調。瀏覽器是檢查者及命令來源，不是多重要求所組成
之儲存／啟動交易的擁有者。

## 設定及執行狀態

HMI 會顯示數個相關狀態，但其擁有者及生命週期不同。

| 狀態 | 擁有者及持久性 | 意義 |
|---|---|---|
| 偵測到的硬體 | `RuntimeSupervisor` 保留的最新完整觀察；不是持久設定 | 實體掃描所得的唯讀證據。未知拓撲不會回報為零個從站。 |
| 共用草稿 | `MachineProfile` 記憶體及草稿版本 | 所有 HMI 設定工作區共用且已驗證的待處理編輯；儲存前不具持久性。 |
| 已儲存設定 | `/etc/botnana-control/motion.toml`，以及伺服器目前的儲存版本 | 持久的預定設定；儲存不會改變運作中的控制器。 |
| 上次正常運作設定 | `RuntimeSupervisor` 保留的不可變 Ready 建置計畫 | 一般重新掃描，以及取消未核准拓撲草稿時的來源。 |
| 作用中控制器 | 目前的執行世代 | 成功啟動時實際選用的值及硬體資源。 |
| 更新狀態 | `/var/lib/botnana-control-update/` 下由 root 管理的檔案 | 待處理套件、報告、保留套件、更新版本及 Motion 封鎖。 |

瀏覽器進度及快取資料列只是呈現狀態，不具權威性。重新整理或重新連線時，會以伺服器
管理的設定、拓撲、生命週期及更新狀態取代它們。

## 即時執行

執行世代使用有界限且由世代管理的請求及回應通道，在 WebSocket 要求與 rtForth VM
之間傳遞資料。VM 具有五個合作式即時工作：

| 工作 | 作用 |
|---|---|
| NC 工作 | 執行背景數值控制腳本及複雜運動程序。 |
| 使用者工作 1 及 2 | 執行兩個即時 WebSocket 應用程式工作階段的要求。 |
| Controller 工作 | 依設定的 `period_us` 執行週期性運動控制引擎。 |
| SFC 工作 | 執行順序控制邏輯。 |

運動引擎管理軸與軸組協調、限制、補間、路徑預視、計時器及程序 I/O。硬體抽象層透過
原生 EtherCAT 主站，將這些責任轉換至支援的 EtherCAT 裝置。設定擁有權會留在週期
工作之外，直到刻意建立新的控制器世代。

## 軟體更新信任邊界

瀏覽器可以提供 Debian 套件內容，但不會取得 root 或套件管理程式權限。
`hmi-server` 會限制 HTTP 上傳，並以固定的 Unix socket 通訊協定串流至具權限的
更新代理程式。`update-agent` 會獨立檢查套件身分、架構、大小、中繼資料及 SHA-256，
再將確認操作綁定至操作人員檢查過的更新狀態版本。

已確認的 Botnana Control 套件會在下次開機重新驗證，並只嘗試安裝一次。更新程式會
在執行 `dpkg` 前記錄 Motion 封鎖；只有受管理的安裝成功才能清除封鎖。因此 HMI 及
Motion 服務不會將不完整的套件安裝誤認為安全的運動控制執行環境。

此邊界不是使用者驗證。Botnana Control 1.14.4 沒有新增 TLS、應用程式登入或套件
簽章身分。任何可連至控制網路 HMI 的用戶端都能提交套件供檢查，因此部署環境必須依賴
受保護且由現場管理的網路及操作程序。

## 故障隔離

| 故障 | 架構上的結果 |
|---|---|
| 控制器世代故障 | HTTP HMI 及程序層級的 WebSocket 狀態／設定作業仍可使用；即時執行環境操作無法使用。 |
| `motion-server` 服務停止 | 獨立的 HMI HTTP 服務仍可載入，但控制器 WebSocket 資料無法使用。 |
| HMI HTTP 服務停止 | 不會因此替換或停止作用中的控制器世代；已連線的客戶 WebSocket 是另一條獨立路徑。 |
| 一條 WebSocket 過載或停止讀取 | 每條連線的准入及輸出限制會隔離其他連線；飽和連線可能被關閉。 |
| 無法證明執行環境清理完成 | 拒絕同一程序內的替換；HMI 會要求授權的 `bnc-motion` 服務重新啟動。 |
| 受管理套件可能只完成部分安裝 | 持久更新狀態會封鎖 Motion，同時保留更新及復原邊界。 |

## 客戶 API 邊界

已發行的 `botnana-apis` 函式庫定義支援的客戶 WebSocket API。內建 HMI 的設定版本、
控制器復原、拓撲維護、連線流量診斷及更新通訊協定都是產品內部協作，除非之後的公開
API 版本明確提升其狀態。不能只因內部路由可在網路上看到，就將它們視為客戶 API。

操作程序請參閱 [EtherCAT 控制器復原](./ethercat-controller-recovery.md)、
[檢查並設定 EtherCAT 拓撲](./ethercat-topology-maintenance.md)及
[軟體更新](./update-software.md)。支援的客戶整合邊界請參閱 [JSON API](./json-api.md)。
