# Software Specification

Botnana A2 comes with the following FOSS (Free and Open Source Software):

* Debian Linux
* IgH EtherCAT Master for Linux
* nodejs

Plus an original software by MAPACODE INC:

* Botnana Control P2P: A motion control software written for EtherCAT and IIoT (Industrial Internet of Things).

## Motion control software

Botnana Control, an original motion control software, has 3 different levels.
Original Botnana A2 comes with level 1 Botnana Control P2P.

All levels of Botnana Control supports the following specification:

* Up to 16 EtherCAT slaves.
* Delta, Panasonic, Sanyo Denki, and Yaskawa’s EtherCAT drive,
support for other drive are currently under development.
* Delta's analogue and digital output module. 
Will support Beckhoff and other manufacturer's EtherCAT modules.

### Level 1:_Botnana Control P2P: Point-to-point control and monitoring

* System scanning and configuration software, auto-detecting EtherCAT slaves.
* Motion control and monitoring.
* Supports EtherCAT motor drive's _hm_ and _pp_ mode.
 Conduct point-to-point and homing operation.

### Level 2:_Botnana Control Profiling: 3 axes interpolation

* Includes level 1 _Botnana Control P2P_ utilities.
* Real-time extenstion (Xenomai).
* Supports Modbus.
* Supports _csp_ and _pv_ mode.
* 3 axes linear and arc interpolation.

### Level 3:_Botnana CNC

* Includes level 2 _Botnana Control Profiling_ utilities.
* 3 to 6 axes interpolation.
* Axis group.
* G/M Code interpreter.
* CNC Human-Machine Interface.
