## EtherCAT Master Tutorial

### Advises for self-taught EtherCAT

Botnana A2 comes preinstalled with _IgH EtherCAT Master_ for Linux. 
But software development using EtherCAT master is not a simple task. 
Therefore, Botnana A2 ships with a built in solution _Botnana Control_.

Following tips and sites are for in case you do not want to rely on Botnana Control, 
want to teach yourself EtherCAT, or want to build your own contorl system.

* Read _IgH EtherCAT Master_ manual. 
The end of this chapter will provide a quick guide for using _IgH EtherCAT Master_.
* Understand what _CANopen_ is. Websites for reference: 
[CANopen Basics](http://www.canopensolutions.com/english/about_canopen/about_canopen.shtml), 
read up on topics _object dictionary_, _PDO_, and _SDO_.
* EtherCAT Master uses _CANopen over EtherCAT_ to conduct IO and motor drive control. 
_CANopen_ standard used are _DSP401_ and _DSP402_. The two documents can be found on the web.
You can also download _Copley_ or _Elmo_'s motor drive manual for reference.
* When controlling motor drives, we recommend knowing your motor drive's state machine. 
State machine describes everything from power suppply to operation enabled, as well as the _Control Word_ for your motor drive.
* At last, understand the several operation mode of your motor drive when it is operation enabled. 
The basic ones are _pp_ and _hm_ mode. We recommend starting from _pp_ mode.
    * _pp_: Point to point motion. This mode does not require real-time OS support.
    * _hm_: Home seeking operation. 又依有沒有 limit switches 及回歸原點的方向分成多數子模式。
    This mode does not require real-time OS support.

 An alternative learning method is through Botnana Control. By 2016-11-30, we expect to launch basic _Botnana Control P2P_, 
supporting _pp_ and _hm_ operation, along with an advanced version _Botnana Control Profiling_, supporting real-time OS support and 直線圓弧插補功能.

### Launch, check status of, and stop EtherCAT Master
By default, Botnana Control will automatically launch EtherCAT master. 
The following are steps to manually start and stop EtherCAT Master:

_IgH EtherCAT Master_ is installed under directory `/opt/etherlab`.

Basic operations:

    service ethercat start
    service ethercat status
    service ethercat stop

Automatically launch EtherCAT master:

    update-rc.d ethercat defaults

### Check the status of EtherCAT and slaves

TODO, Please check IgH EtherCAT master's manual.
