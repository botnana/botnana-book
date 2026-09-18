# Software Specifications

Botnana controllers ship with Linux, a real-time operating system, and Mapacode's Botnana Control multi-axis EtherCAT control software preinstalled.

| Item | Specification |
|-------|--------------|
| Operating system | Linux distribution Debian Buster 4.19.232-rt104 |
| Real-time System | Preempt RT + Xenomai 3.2.3 Mercury Core |
| EtherCAT Master | BotnanaCAT 2.0.1 based on IgH EtherCAT master branch stable 1.5 commit c8a512ac0 |
| Botnana Control | v1.14 (Latest release v1.14.12) |
| Period | 2 ms (Configurable via configuration file) |
| Controllable axes on BN-B3A-10S | 1–10 |
| Supported EtherCAT slaves | 1–16 |
| Runtime scan capacity | 16 EtherCAT slaves |

The axis count, supported slave count, and runtime scan capacity are different
limits. A BN-B3A-10S provides up to 10 motion axes and supports a topology of up
to 16 EtherCAT slaves, including non-axis I/O and gateway devices. The runtime
also scans at most 16 slaves; this implementation bound does not increase the
published product capacity beyond 16.

## Axis-Control Software

All levels of Botnana Control support the following specifications:

* Botnana Control supports 1–16 EtherCAT slaves; the BN-B3A-10S provides up to 10 motion axes.
* Supports EtherCAT motor drives from Panasonic, Delta, Sanyo Denki, Yaskawa, and Oriental Motor (AZD2B/AZD4A multi-axis drivers). Motor drives complying with the CiA 402 standard are supported.
* Supports analog and digital I/O modules from Beckhoff, Delta, Syn-Tek (R1 series), and Advantech, as well as the R1-EC5621 pulse motion module. Modules from additional manufacturers are continuously integrated based on customer requirements.

### Basic Functions

* Real-time extension (Xenomai).
* System scanning and configuration software that reports detected EtherCAT slaves. Detection is read-only evidence and does not automatically adopt a changed physical topology.
* Supports EtherCAT motor drives in modes *HM*, *PP*, *CSP*, *PV*, *CSV*.
* Monitoring software for EtherCAT motor drives and I/O modules.
* Two- and three-axis coordinated motion with linear and circular interpolation. Interpolation supports motor drives that provide *CSP* mode.
* Multiple axis groups.
* Real-time scripting with rtForth.
