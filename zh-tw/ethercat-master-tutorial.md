## EtherCAT Master 入門

### 自學 EtherCAT 建議

_Botnana A2_ 預裝 _IgH EtherCAT Master for Linux_。但是要以這個 EtherCAT master 開發軟體並不是一件容易的事，因此 Botnana A2 還內建了動程科技自行開發的 _Botnana Control_。

以下說明如果您想不依賴 _Botnana Control_，自行學習 EtherCAT 甚至建立自己的控制系統，可參考的文件，以及自學步驟：

* 閱讀 _IgH EtherCAT Master_ 的手冊。本文後面章節會簡單說明如何使用 _IgH EtherCAT Master_。
* 瞭解什麼是 _CANopen_。可以參考 [CANopen Basics](http://www.canopensolutions.com/english/about_canopen/about_canopen.shtml)，尤其要瞭解 _object dictionary_，_PDO_ 及 _SDO_ 的概念。
* EtherCAT Master 透過 _CANopen over EtherCAT_ 這協定進行 IO 及馬達驅動器控制。參考的 CANopen 標準是 _DSP401_ 及 _DSP402_。請透過網路找到這兩份文件。也可以下載 Copley 或 Elmo 的馬達驅動器說明文件作為參考。
* 控制馬達時，建議先瞭解馬達驅動器的有限狀態機 (state machine)。這有限狀態機描述了從馬達驅動器供電到操作致能 (_Operation Enabled_) 的過程，以及你所需下達的 _Control Word_ 命令。
* 再來要瞭解的就是在馬達驅動器的操作致能狀態 (_Operation Enabled_) 中的數種操作模式 (_Operation Mode_)。最基本的有 _pp_、_hm_ 模式。建議先從 _pp_ 模式開始瞭解。
    * _pp_ : 點到點運動。
    * _hm_ : 回歸原點。又依 limit switche 的位置及回歸原點的方向分成多種模式。

另一種學習方式是使用 Botnana Control 來學習。
*Botnana Control* 已於2017年2月1日推出支援 _pp_ 及 _hm_ 模式的基本款 _Botnana Control P2P_。
即將推出使用即時作業系統，支援 *csp* 及 *pv* 模式，
具備直線圓弧插補功能的進階版本 _Botnana Control Profiling_。

### 起動，檢查狀態及停止 EtherCAT Master

Botnana Control 在出廠時已預設自動起動 EtherCAT master。以下說明手動起動及停止的作法。

IgH EtherCAT Master 被安裝在 `/opt/etherlab` 目錄下。

以下是幾個基本操作：

    service ethercat start
    service ethercat status
    service ethercat stop

如果希望每次開機時會自動執行 EtherCAT master:

    update-rc.d ethercat defaults

若不希望自動執行：

    update-rc.d ethercat remove

### 檢查 EtherCAT Master 及 slaves 的狀態

TODO, Please check IgH EtherCAT master's manual。