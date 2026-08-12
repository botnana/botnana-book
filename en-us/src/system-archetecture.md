# System Architecture

## System Concepts

```
    +---------------+------------+               +-----------+
    | User Program  |  Botnana   |               |           |
    |               |  API       |               |           |
    | Main thread   |------------|   JSON  1ms   |           |
    |               |         Tx |-------------->|           |
    |         call -----> Thread |               | WebSocket |
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

The left side of the architecture diagram represents the client for the motion-control/IIoT platform. It has three parts:

1. Application: The application may control semiconductor equipment or a production line and has its own threads.
2. Botnana API: Mapacode's application programming interface consists of three threads.
3. Browser WebApp: The HTTP server on the motion-control platform serves this WebApp. It provides learning, testing, configuration, and software-update services.

## Botnana Control Platform

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
    |             | Control | I/O                            |
    +-------------+---------+--------------------------------+
    | HTTP        | Hardware abstraction/detection layer     |
    | Server      |                                          |
    +-------------+------------------------------------------+
    | Linux       | Real-time kernel                         |
    +-------------+------------------------------------------+
     Non-real-time                                  Real-time
```

The platform has two parts. The non-real-time portion on the left runs on Linux and contains the HTTP server, WebSocket server, and system configuration files.

The real-time portion on the right includes a hardware-abstraction layer that supports EtherCAT slaves from multiple vendors. The motion-control engine above it provides axis groups, kinematics, path look-ahead, interpolation, and sequential-function-chart execution.

Above the motion-control engine, a virtual machine interprets and compiles the rtForth real-time scripting language. The VM provides 4 MB of data space and 4 MB of code space, enough for hundreds of thousands of rtForth instructions. It implements five cooperative tasks:

* Control task: Runs the motion-control engine.
* Foreground tasks 1 and 2: Accept commands from up to two client applications through the non-real-time WebSocket server.
* NC task: Uses the motion-control engine to perform complex motion and machining. The VM can store real-time scripts equivalent to approximately 100,000 lines of a CNC part program. Client software can translate a part program into these scripts or generate them directly in C# or another language.
