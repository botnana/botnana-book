# 入門教學 (Tutorial)

## Botnana Control 架構 

    +-------------+---------+--------+-----------------------+
    |             |         |        | Background task (NC)  |
    |             |         |        +-----------------------+
    |             |         |        | Background task (PLC) |
    |             | Real-time script +-----------------------+
    | Web socket  |<---------------->| Foreground task 2     |
    | Server      | Real-time script +-----------------------+
    |             |<---------------->| Foreground task 1     |
    |             |         |        +-----------------------+
    |             |         |        | Control Task          |
    |             |         |        +-----------------------+
    |             |         | Realtime script VM             |
    +-------------+         +--------------------------------+
    | HTTP        |         | Axis Group                     |
    | Server      |         +--------------------------------+
    |             | Control | I/O                            |
    +-------------+---------+--------------------------------+
    | Config.     | Hardware abstraction layer               |
    | File        +------------------------------------------+
    |             | IgH EtehrCAT Master                      |
    +-------------+------------------------------------------+
    | Linux       | Xenomai                                  |
    +-------------+------------------------------------------+
     Non-real-time                                  Real-time