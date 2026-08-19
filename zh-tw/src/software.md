# 軟體規格

霸那控制器出廠時預裝了 Linux 以及實時作業系統，以及動程科技自行開發的 *Botnana Control*，針對 EtherCAT 開發的多軸控制軟體。

| 項目  | 規格 |
|-------|--------------|
| Operating system | Linux distribution Debian Buster 4.19.232-rt104 |
| Real-time System | Preempt RT + Xenomai 3.2.3 Mercury Core |
| EtherCAT Master | BotnanaCAT 2.0.1 based on IgH EtherCAT master branch stable 1.5 commit c8a512ac0 |
| Botnana Control | v1.14.4 |
| Period | 2 ms |
| BN-B3A-10S 可控軸數 | 1–10 |
| 支援 EtherCAT 從站數 | 1–16 |
| 執行期掃描容量 | 16 個 EtherCAT 從站 |

可控軸數、支援從站數與執行期掃描容量是不同限制。BN-B3A-10S 最多提供 10 個運動軸，
並支援最多 16 個 EtherCAT 從站的拓撲，其中可包含非軸類 I/O 及閘道裝置。執行期同樣
最多掃描 16 個從站；此實作界限不會把產品公布容量提高至 16 個以上。

## 軸控軟體

所有等級的 Botnana Control 都支援以下規格：

* 支援 1–16 個 EtherCAT 從站；BN-B3A-10S 最多提供 10 個運動軸。
* 支援 Panasonic、Delta、Sanyo Denki 和 Yaskawa 的 EtherCAT 馬達驅動器。基本上有符合 CiA 402 規範的馬達驅動器都有支援。
* 支援 Beckhoff，Delta 的類比及數位輸出入模組。因應客戶需求陸續整合其他廠牌的 EtherCAT 模組。

### 基本功能

* Real-time extenstion (Xenomai)
* 系統掃描與設定軟體會回報偵測到的 EtherCAT 從站。偵測結果是唯讀證據，不會自動採用已改變的實體拓撲。
* 支援 EtherCAT 馬達驅動器 *HM*, *PP*, *CSP*, *PV*, *CSV* 模式。
* 監控軟體。支援 EtherCAT 馬達驅動器與 IO 模組。
* 可進行二與三軸同動及直線圓弧補間。補間支援具 *CSP* 模式的馬達驅動器。
* 多軸組功能。
* 即時腳本 （rtForth）。
