# Software Specifications

Botnana controllers ship with Linux, a real-time operating system, and Mapacode's Botnana Control multi-axis EtherCAT control software preinstalled.

| Item | Specification |
|-------|--------------|
| Operating system | Linux distribution Debian Buster 4.19.232-rt104 |
| Real-time System | Preempt RT + Xenomai 3.2.3 Mercury Core |
| EtherCAT Master | BotnanaCAT 2.0.1 based on IgH EtherCAT master branch stable 1.5 commit c8a512ac0 |
| Botnana Control | v1.14.3 |
| Period | 2ms |
| Supported slaves | 1-16 |

## Axis-Control Software

All levels of Botnana Control support the following specifications:

* Botnana Control can control 1–16 EtherCAT slaves.
* Supports EtherCAT motor drives from Panasonic, Delta, Sanyo Denki, and Yaskawa, including those that comply with CiA 402.
* Supports Beckhoff and Delta's analog and digital input/output modules. In response to customer needs, we are gradually integrating modules from other brands of EtherCAT controllers.

### Basic Functions

* Real-time extension (Xenomai).
* System scanning and configuration software that automatically detects EtherCAT slaves.
* Supports EtherCAT motor drives in modes *HM*, *PP*, *CSP*, *PV*, *CSV*.
* Monitoring software for EtherCAT motor drives and I/O modules.
* Two- and three-axis coordinated motion with linear and circular interpolation. Interpolation supports motor drives that provide *CSP* mode.
* Multiple axis groups.
* Real-time scripting with rtForth.
