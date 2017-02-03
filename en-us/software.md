# Software Specification

Botnana A2 comes with the following FOSS programs:

* Debian Linux
* IgH EtherCAT Master for Linux
* nodejs

Plus an original program by MAPACODE INC:

* Botnana Control P2P: An axes contorl program written for EtherCAT and IIoT (Industrial Internet of Things).

## Axes Control Program

Botnana Control, an original axes contorl program, has 3 different levels.
Original Botnana A2 comes with level 1 Botnana Control P2P.

All levels of Botnana Control supports the following //hardware standards

* EtherCAT /非同動軸 up to 32 axes.
* Panasonic and Delta's EtherCAT motor drive,
support for other motor drive are currently under development.
* Delta's analogue and digital output module. 
Will support Beckhoff and other manufacturer's EtherCAT modules.

### Level 1: _Botnana Control P2P_, point-to-point control and monitoring

* 系統掃描與設定軟體，自動偵測 EtherCAT 從站。
* Axes contorl and monitoring.
* Supports EtherCAT motor drive's _hm_ and _pp_ operation.
* Conduct point-to-point and reset operation.

### Level 2: _Botnana Control Profiling_: 3 axis /同動軸控, monitoring

* Includes level 1 _Botnana Control P2P_ utilities.
* Real-time extenstion (Xenomai).
* Supports Modbus.
* 可進行三軸同動及直線圓弧補間。補間支援具 pp 模式的馬達驅動器。

### Level 3: _Botnana Control CNC_：CNC controller, 3 to 6 axes軸同動及多軸組控制器

* Includes level 2 _Botnana Control Profiling_ utilities.
* 工件程式解譯器
* CNC /Human-Computer Interaction.

並可依客戶需求特製四至六軸同動、多軸組、雷射及相機觸發等特殊控制器。
