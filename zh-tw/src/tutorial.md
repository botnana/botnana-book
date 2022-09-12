# 入門教學 (Tutorial)

-----------
## 系統概念

```
    +---------------+------------+               +-----------+
    | User Program  |  Botnana   |               |           |
    |               |  API       |               |           |
    | Main thread   |------------|   JSON  1ms   |           |
    |               |         Tx |-------------->|           |
    |         call -----> Thread |               | Websocket |
    |               |------------|   tag|value   | Server    |
    |               |         Rx |<--------------|           |
    |     callback <----- Thread |               |           |
    |               |------------|     100ms     |           |
    |               |       Poll |-------------->|           |
    |               |     Thread |               |         | |
    |---------------+------------|               |---------|-|
    | Device management software |               | Config. v |
    | on Browser                 |               | File      |
    |                            |               |           |
    |     Learning               |   Webapp      |-----------|
    |     Testing                |<--------------| HTTP      |
    |     Configuration          |               | Server    |
    |     Software update        |               |           |
    |----------------------------|               |-----------|
    | Windows/Linux              |               | Linux     |
    +----------------------------+               +-----------+
```

以上架構圖左方為此軸控／IIoT 平台的客戶端，分三個部份，

1. 應用程式：應用程式可能是一台半導體設備或一個產線的控制系統。此一控制系統有自己的線程。
2. Botnana API：是用動程科技提供的應用程式界面。又由三個線程構成。
3. 瀏覽器上的 Webapp。此一 Webapp 是右方軸控平台的 HTTP 伺服器產生。提供以下四種裝置管理服務：學習、測試、建構與軟體更新。

-----------------------
## Botnana 控制平台

```
    +-------------+------------------+-----------------------+
    |             |                  | Background task (NC)  |
    |             |                  +-----------------------+
    |             |                  | Background task (PLC) |
    |             | Real-time script +-----------------------+
    | Web socket  |<---------------->| Foreground task 2     |
    | Server      | Real-time script +-----------------------+
    |             |<---------------->| Foreground task 1     |
    |             |                  +-----------------------+
    |             |                  | Control Task          |
    |             |                  +-----------------------+
    |             | Realtime script VM (4MB Data + 4MB Code) |
    +-------------+---------+------------+-------------------+
    | Config.     |         | Axis Group | Kinematics        |
    | File        |         +------------+-------------------+
    |             |         | Look ahead | Interpolations    |
    |             |         +------------+-------------------+
    |             | Control | I/O        | SFC Engine        |
    +-------------+---------+------------+-----+-------------+
    | HTTP        | Hardware abstraction/detection layer     |
    | Server      |                                          |
    +-------------+------------------------------------------+
    | Linux       | Real-time kernel                         |
    +-------------+------------------------------------------+
     Non-real-time                                  Real-time
```
動程於 2015 開始投入此一平台的開發，從最底層的工業以太網路 (EtherCAT) 的硬體抽象層開始做起，上圖為到 2018 年十月已完成的架構。

此一架構分成兩大部份，左方為非實時的部份，在 Linux 作業系統下執行，具有兩個伺服器：HTTP 伺服器和 Websocket 伺服器，以及此一系統的各種建構檔案。

右端為實時的部份，在實時系統上建置了一層硬體抽象層。此一硬體抽象層支援各家的 EtherCAT 從站。以硬體抽象層為基礎，其上為軸控的引擎。又包括了軸組、運動學、路徑預視、補間功能、順序流程圖的執行引擎。

在軸控引擎之上是執行實時腳本語言 rtForth 的虚擬機，具直譯／編譯功能。虚擬機內建 4MB 的資料空間及 4MB 的程式碼空間，能儲存數十萬指令的 rtForth 程式。並以合作式多工的方式實作了五個工作：

* Control 工作：執行以控制下軸控引擎。
* 前景工作一和二：透過其左方非實時部份的 Websocket 伺服器，接受最多兩個客戶端應用程式的指令。
* PLC 工作：使用底下軸控引擎中順序流程圖引擎 (SFC Engine) 來執行可程式邏輯控制程式。
* NC 工作：使用底下軸控引擎中的各種功能執行複雜的運動及加工行為。虚擬機內建的空間使其能儲存相當於十萬行 CNC 工件程式的實時腳本。這些實時腳本可由是客戶端程式從工作程式轉譯得到，或是由客戶端直接以 C# 或其他語言規畫產生。