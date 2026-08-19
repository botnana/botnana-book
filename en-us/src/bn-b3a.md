# Botnana BN-B3A

The Botnana BN-B3A specifications are listed below.

**Ordering note:** Specify the BN-B3A-10S model when ordering.

## Product Model

| Model        | Controllable axes | Supported EtherCAT slaves | Runtime scan capacity |
|-------------|------------------:|---------------------------:|----------------------:|
| BN-B3A-10S  | 10                | 16                         | 16                    |

These are separate limits. The runtime can scan up to 16 EtherCAT slaves, but a
BN-B3A-10S provides 10 motion axes. I/O modules, gateways, and other non-axis
slaves can occupy the remaining supported slave positions.

## Hardware specifications

| Item | Specification |
|-------|--------------|
| Board | LubanCat-1N |
| Power input | Type-C, 5 V at 3 A DC |
| CPU   | RK3566 (4-core ARM Cortex-A55, 1.8 GHz, Mali-G52) |
| RAM   | LPDDR4/4X, 2GB |
| Storage | eMMC, 8GB |
|         | TF card: supports boot/expansion, maximum 512 GB |
| Ethernet | WAN, eth0, 1000M x1 |
| EtherCAT | LAN, eth1, Realtek RTL8111/8168/8411 (for connecting EtherCAT slave) |
| USB2.0 | Type-A x1 (HOST) |
| USB2.0 | Type-C x1 (OTG), power input |
| USB3.0 | Type-A x1 (HOST) |
| Buttons | PWR (Power), MR (MaskRom), REC (Recovery) |
| Display | HDMI 2.0 |
| Dimensions | |

The EtherCAT interface is the port marked **LAN**.

![](./figures/b3a.png)
