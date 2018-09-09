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
    |             |         | Realtime script VM (4MB)       |
    +-------------+         +------------+-------------------+
    | Config.     |         | Axis Group | Kinematics        |
    | File        |         +------------+-------------------+
    |             |         | Look ahead | Interpolations    |
    |             |         +------------+-------------------+
    |             | Control | I/O        | SFC Engine        |
    +-------------+---------+------------+-----+-------------+
    | HTTP        | Hardware abstraction/detection layer     |
    | Server      +------------------------------------------+
    |             | IgH EtehrCAT Master                      |
    +-------------+------------------------------------------+
    | Linux       | Xenomai                                  |
    +-------------+------------------------------------------+
     Non-real-time                                  Real-time

--------

    +---------------+------------+               +-----------+
    | User          |  Botnana   |               |           |
    | Program       |  API       |               |           |
    | +-------------+------------|   JSON  1ms   |           |
    | | Main thread |         Tx |-------------->|           |
    | |       call -----> Thread |               | Websocket |
    | |             |------------|   tag|value   | Server    |
    | |             |         Rx |<--------------|           |
    | |   callback <----- Thread |               |           |
    | |             |------------|               |           |
    | |             |       Poll |               |           |
    | |             |     Thread |               |         | |
    | +-------------+------------|               |---------|-|
    |               |  Websocket |               | Config. v |
    |               |     Client |               | File      |
    |---------------+------------|               |           |
    | Browser                    |   Webapp      |-----------|
    |       Learning             |<--------------| HTTP      |
    |       Testing              |               | Server    |
    |       Configuration        |               |           |
    |       Software update      |               |-----------|
    |                            |               | Linux     |
    +----------------------------+               +-----------+


--------