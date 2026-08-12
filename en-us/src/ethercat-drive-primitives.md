### EtherCAT Drive Command Set

EtherCAT drives typically comply with the CiA 402 specification, which defines the drive's operating pattern and interface. In fact, the drive does not perform all the functions mentioned in the CiA 402 specification, and should be noted when selecting the drive.

Currently, Botnana Control supports the following drives:

* Position control mode PP (Profile Position Mode)
* Velocity control mode PV (Profile Velocity Mode)
* HM is the basic regression model. (Homing mode)
* Torque control mode TQ (Profile Torque Mode)
* Cyclic synchronous positioning model CSP (Cyclic Sync Position Mode)
* Cyclic synchronous velocity mode CSV (Cyclic Sync Velocity Mode)
* Cyclic synchronous torque mode CST (Cyclic Sync Torque Mode)

In terms of application, the cyclic synchronous pattern is suitable for multi-axis coordinated motion or special trajectory planning.

**The position pattern square graph:**

```
               +--------+
               | +----> |----------------------- +
               | |CSP   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Position    |-->o--->|  Position |----> Control
Position       |  PP    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Seletor

```

**The velocity pattern square graph:**

```
               +--------+
               | +----> |----------------------- +
               | |CSV   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Velocity    |-->o--->|  Velocity |----> Control
Velocity       |  PV    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Seletor

```

**The torque mode block diagram:**

```
               +--------+
               | +----> |----------------------- +
               | |CST   |                        |
               | |      |      +-------------+   v    +-----------+
Target   ----->|-+----> |----->| Torque      |-->o--->|  Torque   |----> Control
Torque         |  TQ    |      | Trajectory  |        |  Control  |      Effect
               |        |      | Generation  |        |           |
               +--------+      +-------------+        +-----------+
              Mode Selector

```

**Return to the original model**The following are some common regression methods, each of which must be based on a manufacturer-supported method.

* Method 1 and 2 : Homing on the limit switch and index pulse

Depending on the negative/positive direction selected, the starting position is the nearest index pulse after a reversal when encountering the limit switch.

```
++                    ++                     ++
||--------------------||---------------------||
||--------------------||---------------------||
++                    ++                     ++
                       |
     +-----------------|
     |.     .          |
     +-----(1)->
      .     .
      .     |         |       |    Index Pulse
------------+---------+-------+----------------
------+
      |                    Negativ Limit Switch
      +----------------------------------------
                       |             .   .
                       |-------------------+
                       |             .   . |
                                  <-(2)----+
                                     .   .
                                     .   .
Index Pulse            |       |     |   .
-----------------------+-------+-----+----------
                                         +------
Positive Limit Switch                    |
-----------------------------------------+
```

* Methods 3 to 6: Homing on the home switch and index pulse

Depending on the negative/positive direction and method chosen, the starting position is the nearest index pulse after encountering the home switch.

```
++                                           ++
||-------------------------------------------||
||-------------------------------------------||
++                                           ++
    |
    |------------------+
    |            .    .|   .
              <-(3)----+   .
                 .    .    .             |
              <-(3)----------------------|
                 .    .    .             |
    |            .    .    .
    |---------------------(4)->
    |            .    .    .             |
                 .   +-------------------|
                 .   |.    .             |
                 .   +----(4)->
                 .    .    .
Index Pulse      |    .    |
-----------------+----------------------------
                      +-----------------------
Home Switch           |
----------------------+
     |             .   .    .
     |---------------------(5)->
     |             .   .    .            |
                   .  +------------------|
                   .  |.    .            |
                   .  +----(5)->
     |             .   .    .
     |------------------+   .
     |             .   .|   .
                <-(6)--.+   .
                   .   .    .              |
                <-(6)----------------------|
                   .   .    .              |
Index Pulse        |   .    |
-------------------+--------+--------------------
Home Switch            .
-----------------------+
                       |
                       +-------------------------
```

* Methods 7 to 10: Homing on positive limit switch, home switch and index pulse

Similar to the method of Methods 3 to 6, a reversal after a positive boundary switch is encountered to find the index pulse according to its setting.

```
++                                                                ++
||----------------------------------------------------------------||
||----------------------------------------------------------------||
++                                                                ++
    |           .     .      .           .      .         .
    |--------------------------------------------+------(10)->
    |           .     .      .           .      .|        .
    |------------------+----(8)->     <-(9)------+        .
                .     .|     .           .      .         .
             <-(7)-----+     .           .      .         .
                .     .      .     |     .      .         .
             <-(7)---+-------------+-------------+------(10)->
                .    |.      .     |     .      .|        .
                .    +------(8)->     <-(9)------+        .
                .     .      .           .      .       | .  .
                .     .      .           .      .       |-----+
                .     .      .           .      .       | .  .|
                .     .      .           .      .         .  .|
             <-(7)---+----------------------------------------+
                .    |.      .           .      .         .  .|
                .    +------(8)->     <-(9)----+--------------+
                .     .      .           .     |.         .  .
                .     .      .           .     +--------(10)->
                .     .      .           .      .         .  .
Index Pulse     |     .      |           |      .         |  .
-------------------------------------------------------------------
                      +-------------------------+            .
Home Switch           |                         |            .
----------------------+                         +------------------
                                                             +-----
Positive Limit Switch                                        |
-------------------------------------------------------------+
```

* Methods 11 to 14: Homing on negative limit switch, home switch and index pulse

Similar to the method of Methods 3 to 6, a reversal after a negative boundary switch is encountered to find the index pulse according to its setting.

```
++                                                                       ++
||-----------------------------------------------------------------------||
||-----------------------------------------------------------------------||
++                                                                       ++
                  .      .     .           .      .      .         |
              <-(14)----+-------------------------.----------------|
                  .     |.     .           .      .      .         |
                  .     +-----(13)->   <-(12)---+-.----------------|
                  .      .     .           .    | .      .         |
                  .      .     .           .    +-.-----(11)->
                  .      .     .     |     .      .      .
              <-(14)----+------------+-------------+----(11)->
                  .     |.     .     |     .      .|     .
                  .     +-----(13)->   <-(12)------+     .
       .     |    .      .     .           .      .      .
      +------|    .      .     .           .      .      .
      |.     |    .      .     .           .      .      .
      |.          .      .     .           .      .      .
      +--------------------------------------------+----(11)->
      |.          .      .     .           .      .|     .
      +-------------------+---(13)->   <-(12)------+     .
       .          .      .|    .           .      .      .
       .      <-(14)------+    .           .      .      .
       .          .      .     .           .      .      .
Index Pulse       |      .     |           |      .      |
---------------------------------------------------------------------
       .                 +------------------------+
Home Switch              |                        |
+------------------------+                        +------------------
       +-------------------------------------------------------------
       |                                      Negative Limit Switch
+------+
```

* Methods 17 and 18: Homing on limit switch without an index pulse

Depending on the negative/positive direction chosen, the starting position is on the limit switch.

```
 ++                 ++                        ++
 ||-----------------||------------------------||
 ||-----------------||------------------------||
 ++                 ++                        ++
       .             |
    +----------------|
    |  .             |
    +-(17)->
       .
 ------+
       |                    Negative Limit Switch
       +-----------------------------------------
                      |                   .
                      |-----------------------+
                      |                   .   |
                                       <-(18)-+
                                          .
                                          +------
Positive Limit Switch                     |
------------------------------------------+
```

* Methods 19 to 22: Homing on home switch without an index pulse

Depending on the negative/positive direction and method chosen, the original position is on the home switch.

```
 ++    ++                                     ++
 ||----||-------------------------------------||
 ||----||-------------------------------------||
 ++    ++                 .                   ++
       |                  .
       |-------------------------+
       |                  .      |
                      <-(19)-----+
                          .            |
                      <-(19)-----------|
       |                  .            |
       |----------------(20)->
       |                  .            |
                  +--------------------|
                  |       .            |
                  +-----(20)->
                          .
                          +--------------------
Home Switch               |
--------------------------+

 ++    ++                                     ++
 ||----||-------------------------------------||
 ||----||-------------------------------------||
 ++    ++                 .                   ++
       |                  .
       |----------------(21)->
       |                  .            |
                  +--------------------|
                  |       .            |
                  +-----(21)->
       |                  .
       |-------------------------+
       |                  .      |
                      <-(22)-----+     |
                      <-(22)-----------|
                          .            |
Home Switch               .
--------------------------+
                          |
                          +--------------------
```

* Methods 33 and 34: Homing on the index pulse

Depending on the negative/positive direction chosen, the starting position is the index pulse closest to the current position.

```
++                   ++                      ++
||-------------------||----------------------||
||-------------------||----------------------||
++                   ++                      ++
                .     |     .
           <--(33)----|     .
                .     |---(34)--->
                .     |     .
 Index Pulse    .           .
    |           |           |            |
 -------------------------------------------------
```

* Methods 35 and 37: Homing on current position

The original position is in the current position.

```
++                   ++                      ++
||-------------------||----------------------||
||-------------------||----------------------||
++                   ++                      ++
                    (35)
                    (37)
```

**Drive running status**

```
               +-------+
-------------->| FSA   +-------------->
Control Word   |       |   Status Word
(0x6040)       +-------+   (0x6041)
```

FSA (Finite States Automaton) of PDS (Power Drive System)

```
             Start
               |
               |
               V 0
        +-------------------+
        | Not Ready to      |
        | switch on         |
        | (Not initialized) |
        +-------------------+
               |
               |
               V 1
 +------------------------------+       +-----------+
 |         Switch on            | 15    |   Fault   |
 |         Disabled             |<------|           |
 |  (Initialization completed)  |       |  (Alarm)  |
 +------------------------------+       +-----------+
  ^ 9        |   ^ 7   ^ 10   ^ 12            ^ 14
  |          |   |     |      |               |
  |          v 2 |     |      |               |
  |  +---------------+ |      |               |
  |  |  Ready to     | |      |               |
  |  |  Switch on    | |      |               |
  |  | (Main circuit | |      |               |
  |  |  power off )  | |      |               |
  |  +---------------+ |      |               |
  |    ^ 8   |   ^ 6   |      |               |
  |    |     |   |     |      |               |
  |    |     V 3 |     |      |               |
  |    | +-------------+----+ |        +------+-----------+
  |    | |   Switched on    | |        |  Fault reaction  |
  |    | |                  | |        |     active       |
  |    | |  (Servo ready)   | |        | (Deceleration    |
  |    | +------------------+ |        |  processing)     |
  |    |     |   ^ 5          |        +------------------+
  |    |     |   |            |               ^
  |    |     v 4 |            |               | 13
+-------------------+   11 +---------------+  |
|     Operation     |----->|Quick stop     |  |
|     Enabled       |<-----|active         |  |
|                   | 16   | (Deceleration |  |
|     (Servo on)    |      |  processing)  |  |
+-------------------+      +---------------+  |
                                              Error Occurs
```
FSA Transition

| No | FSA Transition |
|----|-------------|
| 0  | Auto skip |
| 1  | Auto skip |
| 2  | [Shutdown] |
| 3  | [Switch On] |
| 4  | [Enable operation]
| 5  | [Disable operation]
| 6  | [Shutdown]
| 7  | [Disable voltage]
| 8  | [Shutdown]
| 9  | [Disable voltage]
| 10 | [Disable voltage]
| 11 | [Quick stop]
| 12 | [Disable voltage]
| 13 | Error Occurs
| 14 | Auto skip
| 15 | [Fault reset]
| 16 | [Enable operation]

**Control Word (0x6040:0x0)**:

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 15                                                  Bit 0

* Bit 0: Switch On
* Bit 1: Enable Voltage
* Bit 2: Quick Stop
* Bit 3: Enable Operation
* Bit 4: Operation Mode Specification
* Bit 5: Operation Mode Specification
* Bit 6: Operation Mode Specification
* Bit 7: Fault Reset
* Bit 8: Halt
* Bit 9: Operation Mode Specification
* Bit 10: Reserved
* Bit 11: Reserved
* Bit 12: Reserved
* Bit 13: Reserved
* Bit 14: Reserved
* Bit 15: Reserved

Operation Mode Specification:

| OP mode | Bit 9 | Bit 6 | Bit 5 | Bit 4 |
|---------|--------|--------|--------|--------|
| PP  | change on set-point | absolute/relative | change set immediately | new set-point |
| PV  | -- | -- | -- |
| TQ  | -- | -- | -- |
| HM  | -- | -- | start homing |
| CSP | -- | -- | --             |
| CSV | -- | -- | --             |
| CST | -- | -- | --             |


| Commnad | bit 7 | bit 3 | bit 2 | bit 1 | bit 0 | Transitions |
|---------|-------|-------|-------|-------|-------|-------------|
| Shutdown                      | 0         | - | 1 | 1 | 0 | 2,6,8
| Switch on                     | 0         | 0 | 1 | 1 | 1 | 3
| Switch on + Enable operation  | 0         | 1 | 1 | 1 | 1 | 3+4
| Enable operation              | 0         | 1 | 1 | 1 | 1 | 4,16
| Disable voltage               | 0         | - | - | 0 | - | 7,9,10,12
| Quick stop                    | 0         | - | 0 | 1 | - | 7,10,11
| Disable operation             | 0         | 0 | 1 | 1 | 1 | 5
| Fault Reset                   | 0 -> 1    | - | - | - | - | 15


**Status Word (0x6041:0x0)**:

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 15                                                  Bit 0

* Bit 0: Ready to Switch On
* Bit 1: Switched On
* Bit 2: Operation Enabled
* Bit 3: Fault
* Bit 4: Voltage Enabled
* Bit 5: Quick Stop
* Bit 6: Switch On Disabled
* Bit 7: Warning
* Bit 8: Reserved
* Bit 9: Remote
* Bit 10: Operation Mode Specification
* Bit 11: Internal Limit Active
* Bit 12: Operation Mode Specification
* Bit 13: Operation Mode Specification
* Bit 14: Reserved
* Bit 15: Reserved

Operation Mode Specification:

| OP mode | Bit 13 | Bit 12 | Bit 10 |
|---------|--------|--------|--------|
| PP  | following error | set-point acknowledge | target reached |
| PV  | --              | speed                 | target reached |
| TQ  | --              | --                    | target reached |
| HM  | homing error    | homing attained       | target reached |
| CSP | following error |                       | --             |
| CSV | --              |                       | --             |
| CST | --              |                       | --             |

FSA State:

| FSA State | Bit 6 | Bit 5 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
|-----------|-------|-------|-------|-------|-------|-------|
| Not Ready to Switch on    | 0 | - | 0 | 0 | 0 | 0 |
| Switch on Disabled        | 1 | - | 0 | 0 | 0 | 0 |
| Ready To Switch On        | 0 | 1 | 0 | 0 | 0 | 1 |
| Switch on                 | 0 | 1 | 0 | 0 | 1 | 1 |
| Operation Enabled         | 0 | 1 | 0 | 1 | 1 | 1 |
| Quick Stop Active         | 0 | 0 | 0 | 1 | 1 | 1 |
| Faut Reaction Active      | 0 | - | 1 | 1 | 1 | 1 |
| Fault                     | 0 | - | 1 | 0 | 0 | 0 |

---

#### `+drive-halt ( ch n -- )`

Pause the motor drive on EtherCAT slave `n` channel `ch`.

The engine will then be based on 0x605D. (Halt option code) Set, temporary slowdown and stop.

#### `+drive-homed ( ch n -- )`

The EtherCAT slave channel `n` of motor drive on motion axis `ch` has completed homing.

This state is recorded by the master.

#### `+pp-cosp ( ch n -- )`

When EtherCAT slave `n` on channel `ch` of a motor drive is in PP mode, set the Bit 9 (Change on set-point) of the Control Word to 1.

When Control Word Bit 9 is 1 (Change on set-point) and Bit 5 (change set immediately) is 0, the same-directional motion does not slow down to 0 via a relay point.

For details, please refer to the PP model description of the selected drive.

#### `+pp-imt ( ch n -- )`

When the EtherCAT slave node `n` is in the PP mode of the motor drive on channel `ch`, set the Bit 5 (change set immediately) of the Control Word to 1.

When Control Word's Bit 5 (change set immediately) is 1, it indicates that the motor drive will only move towards the final accepted target position.

For details, please refer to the PP model description of the selected drive.

#### `+pp-rel ( ch n -- )`

When EtherCAT slave `n` on channel `ch` of a motor drive is in PP mode, set the Control Word's Bit 6 (absolute/relative) to 1.

For details, please refer to the PP mode description of the selected drive. When Control Word's Bit 6 (absolute/relative) is 1, the motor drive will handle the target position using the relative position.

#### `-drive-halt ( ch n -- )`

Command the motor drive on channel `ch` of EtherCAT slave `n` to resume operation.

Reference commands `+drive-halt`

#### `-drive-homed ( ch n -- )`

EtherCAT slave `n` channel `ch` motor drive has not completed homing to the mechanical origin.

This state is recorded by the master.

#### `-pp-cosp ( ch n -- )`

When the EtherCAT slave node `n` is in the PP mode of the motor drive on channel `ch`, set the Bit 9 (Change on set-point) of the Control Word to 0.

When Control Word Bit 9 is 0 (Change on set-point) and Bit 5 (change set immediately), the same direction of motion decreases to 0 through a relay point.

For details, please refer to the PP model description of the selected drive.

#### `-pp-imt ( ch n -- )`

When the EtherCAT slave `n` channel `ch` motor drive is in PP mode, set the Bit 5 (change set immediately) of the Control Word to 0.

When Control Word's Bit 5 (change set immediately) is 0, it represents the target position to be accepted by each motor drive.

For details, please refer to the PP model description of the selected drive.

#### `-pp-rel ( ch n -- )`

When the EtherCAT slave node `n` is in the PP mode of the motor drive on channel `ch`, set the Bit 6 (absolute/relative) of the Control Word to 0.

Please refer to the PP mode description of the selected drive. When Control Word's Bit 6 (absolute/relative) is 1, the motor drive uses the absolute position to handle the target position.

#### `drive-cw! ( cw ch n -- )`

Set the control word for EtherCAT slave `n` channel `ch` motor drive to `cw` (via PDO).

#### `demand-p@ ( ch n -- pos )`

Get the demand position `pos` of EtherCAT slave `n`'s channel `ch` motor drive on the motion axis.

Set the master configuration file, and the motor drive in this channel can map the demand position (object 0x6062) to the PDO Mapping.

#### `demand-tq@ ( ch n -- tq )`

Get the demand torque `tq` of the motor drive on channel `ch` of EtherCAT slave `n`.

The master configuration must map demand torque (object 0x6074) into the drive's PDO mapping.

#### `demand-v@ ( ch n -- vel )`

Get the demand velocity `vel` of EtherCAT slave `n`'s channel `ch` motor drive.

Set the master configuration file, and the motor drive in this channel can map demand velocity (object 0x606B) to the PDO Mapping.

#### `drive-dins@ ( ch n -- dins )`

Obtain the digital input state `dins` of the motor drive on channel `ch` of EtherCAT slave `n` (obtained via PDO).

The object 0x60FD is defined as:

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 31                                                  Bit 0

* Bit 0: Negative Limit
* Bit 1: Positive Limit
* Bit 2: Home Switch
* Bit 3 ~ 31: Depending on the manufacturer of the motor drive.

#### `drive-douts! ( douts ch n -- )`

Use an SDO command to set the digital output of the motor drive on channel `ch` of EtherCAT slave `n` to `douts`.

The object 0x60FE:0x01 is defined as follows:

    +-----------------------------------------------------------+
    +-----------------------------------------------------------+
    Bit 31                                                  Bit 0

* Bit 0: Brake.
* Bit 1 ~ 31: Depending on the manufacturer of the motor drive.

Normally the motor drive controls its digital outputs directly. To control an output from the master, use this command together with `drive-douts-mask!`.

#### `drive-douts-mask! ( mask ch n -- )`

Use SDO command to set the digital output mask of EtherCAT slave `n` channel `ch` motor drive to `mask`.

Use this command together with `drive-douts!`.

#### `drive-fault? ( ch n -- flag )`

Retrieve the status word Bit 3 (fault) state `flag` of the motor drive on EtherCAT slave `n` at channel `ch`.

#### `drive-homed? ( ch n -- flag )`

Get whether EtherCAT slave `n` channel `ch` motor drive has homed `flag`.

#### `drive-nl? ( ch n -- nl )`

Return in `nl` whether the negative limit switch of the motor drive on channel `ch` of EtherCAT slave `n` is active.

This status comes from the same source as `drive-dins@`.

#### `drive-nsl! ( nsl ch n -- )`

Use SDO command to set the negative software limit of motor driver channel `ch` on EtherCAT slave `n` to `nsl`.

Object 0x607D: 0x01

#### `drive-nsl@ ( ch n -- nsl )`

Set the negative software limit of EtherCAT slave `n` channel `ch` motor drive to stack.

The master reads this setting from the motor drive at startup. After startup, use `drive-nsl!` to set the negative software limit so that the SDO response is reflected correctly in memory.

#### `drive-off (ch n -- )`

Switch FSA state of EtherCAT slave `n` channel `ch` motor drive to Switch On Disabled.

#### `drive-on (ch n -- )`

Switch the FSA state of EtherCAT slave `n` channel `ch` motor drive to Operation Enabled.

#### `drive-on? ( ch n -- flag )`

Get the FSA state of EtherCAT slave `n` channel `ch` motor drive whether it is in `flag` of Operation Enabled.

#### `drive-org? ( ch n -- org )`

Determine if the home switch of EtherCAT slave `n`'s channel `ch` motor drive has been triggered `org`.

This status comes from the same source as `drive-dins@`.

#### `drive-pl? ( ch n -- pl )`

Return in `pl` whether the positive limit switch of the motor drive on channel `ch` of EtherCAT slave `n` is active.

This status comes from the same source as `drive-dins@`.

#### `drive-psl! ( psl ch n -- )`

Use SDO command to set the forward software limit of motor driver `ch` on EtherCAT slave `n` to `psl`.

The corresponding Object 0x607D: 0x02

### `drive-psl@ ( ch n -- psl )`

Set the forward software limit of EtherCAT slave `n` channel `ch` motor drive to stack.

The master reads this setting from the motor drive at startup. After startup, use `drive-psl!` to set the positive software limit so that the SDO response is reflected correctly in memory.

#### `drive-polarity! ( polarity ch n -- )`

Use SDO command to set the motor driver polarity `polarity` on EtherCAT slave `n` channel `ch`.

The corresponding Object 0x607E.

#### `drive-rpdo1@ ( ch n -- r1 )`

Get Rx PDO data for the first motor drive in the user program on EtherCAT slave `n` at channel `ch` (slave -> master) `r1`.

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `drive-rpdo2@ ( ch n -- r2 )`

Get the second user-defined Rx PDO value, `r2` (slave to master), for the motor drive on channel `ch` of EtherCAT slave `n`.

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `drive-stop ( ch n -- )`

Switch the FSA state of the motor drive on EtherCAT slave `n`, channel `ch`, to Quick stop active.

#### `drive-sw@ ( ch n -- sw )`

Get the Status Word `sw` of motor driver on channel `ch` of EtherCAT slave `n` (obtained via PDO).

#### `drive-vmax! ( vmax ch n -- )`

Use SDO command to set the maximum speed `vmax` of the motor driver on EtherCAT slave `n` channel `ch`.

The corresponding Object 0x6080:0x01..

#### `drive-wpdo1! ( w1 ch n -- )`

Set the first user-defined Tx PDO value, `w1` (master to slave), for the motor drive on channel `ch` of EtherCAT slave `n`.

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `drive-wpdo1@ ( ch n -- w1 )`

Get the Tx PDO data for the first motion axis of EtherCAT slave `n` on channel `ch` for the motor drive user program (`w1`) (master -> slave).

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `drive-wpdo2! ( w2 ch n -- )`

Set the second user-defined Tx PDO value, `w2` (master to slave), for the motor drive on channel `ch` of EtherCAT slave `n`.

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `drive-wpdo2@ ( ch n -- w2 )`

Get the second user-defined Tx PDO value, `w2` (master to slave), for the motor drive on channel `ch` of EtherCAT slave `n`.

Set the master configuration file, and the motor drive in this channel can map the corresponding object to PDO Mapping.

#### `go ( ch n -- )`

Set Bit 4 of the Control Word for EtherCAT slave `n`'s channel `ch` motor drive to 1.

In PP mode this requests a new set-point; in HM mode it starts homing. When the master receives the channel's response, it automatically resets Control Word Bit 4 to 0.

#### `homing-a! ( acceleration ch n -- )`

Use SDO instruction to set homing acceleration `acceleration` of EtherCAT slave number `n` channel `ch` motor drive.

The corresponding object is 0x609A. Note the set unit of the motor drive.

#### `homing-method! ( method ch n -- )`

Use an SDO command to set homing method `method` for the motor drive on channel `ch` of EtherCAT slave `n`.

The corresponding Object is 0x6098.

#### `homing-v1! ( v1 ch n -- )`

Use an SDO command to set homing speed for switch `v1` for the motor drive on channel `ch` of EtherCAT slave `n`.

The corresponding Object is 0x6099:0x01. Note the set unit of the motor drive.

#### `homing-v2! ( v2 ch n -- )`

Use SDO instruction to set homing speed for motor drive `n` on channel `ch` of EtherCAT slave `v2` to zero.

The corresponding Object is 0x6099:0x02.

#### `op-mode! ( mode ch n -- )`

Use SDO instruction to set the operation mode `mode` of the motor drive on EtherCAT slave `n` at channel `ch`.

The corresponding object is 0x6060.

Currently supported modes are as follows:

    1: PP
    3: PV
    4: TQ
    6: HM
    8: CSP
    9: CSV
    10: CST

There is also a well-defined pattern code command:

    : pp ( -- mode ) 1 ;
    : pv ( -- mode ) 3 ;
    : tq ( -- mode ) 4 ;
    : hm ( -- mode ) 6 ;
    : csp ( -- mode ) 8 ;
    : csv ( -- mode ) 9 ;
    : cst ( -- mode ) 10 ;

example command:

    1  1 1 op-mode!  \ Change the EtherCAT slave number 1 to PP mode
    pp 1 1 op-mode!  \ Change the EtherCAT slave number 1 to PP mode
    3  1 1 op-mode!  \ Switch the EtherCAT slave number 1 to PV mode
    pv 1 1 op-mode!  \ Switch the EtherCAT slave number 1 to PV mode
    4  1 1 op-mode!  \ Switch EtherCAT slave 1, channel 1 to TQ mode
    tq 1 1 op-mode!  \ Switch EtherCAT slave 1, channel 1 to TQ mode
    6  1 1 op-mode!  \ Switch the EtherCAT slave number 1 to HM mode
    hm 1 1 op-mode!  \ Switch the EtherCAT slave number 1 to HM mode
    8 1 1 op-mode! Switch EtherCAT slave #1 Channel 1 motor drive to CSP mode
    csp 1 1 op-mode! \ Switches the EtherCAT slave number 1, channel 1 motor drive to CSP mode
    9   1 1 op-mode! \ Switch the EtherCAT slave number 1 to CSV mode
    csv 1 1 op-mode! \ Switch the EtherCAT slave number 1 to CSV mode
    10  1 1 op-mode! \ Switch EtherCAT slave 1, channel 1 to CST mode
    cst 1 1 op-mode! \ Switch EtherCAT slave 1, channel 1 to CST mode

#### `pds-goal! ( goal ch n -- )`

Change the motor drive on channel `ch` of EtherCAT slave `n` to FSA state `goal`. The master sets the Control Word automatically for the requested state.

The FSA state of PDS can be changed as follows:

    : switch-on-disabled ( -- goal ) 1 ;
    : ready-to-switch-on ( -- goal ) 2 ;
    : switched-on        ( -- goal ) 3 ;
    : operation-enabled  ( -- goal ) 4 ;
    : quick-stop-active  ( -- goal ) 5 ;

The `drive-on`, `drive-off`, and `drive-stop` commands are composed from `pds-goal!` as follows:

    : drive-on ( ch n -- )
        operation-enabled -rot pds-goal! ;

    : drive-off ( ch n -- )
        switch-on-disabled -rot pds-goal! ;

    : drive-stop ( ch n -- )
        quick-stop-active -rot pds-goal! ;

#### `profile-a1! ( a1 ch n -- )`

Use SDO command to set EtherCAT slave number `n`, channel `ch` motor drive profile acceleration `a1`.

The corresponding object is 0x6083. In PP and PV mode, this acceleration is used for positioning or velocity planning.

#### `profile-a2! ( a2 ch n -- )`

Use SDO command to set EtherCAT slave number `n`, channel `ch` motor drive profile deceleration `a2`.

The corresponding object is 0x6084. In PP and PV mode, this is used for positioning or velocity planning.

#### `profile-v! ( vel ch n -- )`

Use SDO instruction to set the profile velocity `vel` of the motor drive on EtherCAT slave `n` at channel `ch`.

The corresponding object is 0x6081. In PP mode, velocity is used for positioning and velocity planning.

#### `real-p@ ( ch n -- pos )`

Obtain the real position `pos` of the motor drive on channel `ch` of EtherCAT slave `n`, obtained from PDO.

The corresponding object is 0x6064. Usually the unit is the number of pulses.

#### `real-tq@ ( ch n -- tq )`

Get the actual torque `tq` of the motor drive on channel `ch` of EtherCAT slave `n` through PDO data.

The master configuration must map torque actual value (object 0x6077) into the drive's PDO mapping. The unit is typically 0.1% of rated torque.

#### `real-v@ ( ch n -- vel )`

Obtain the real speed `vel` of EtherCAT slave `n`'s motor drive `ch` on a channel (obtained via PDO).

Set the master configuration file, and the motor driver in this channel can map the real velocity (object 0x606C) to the PDO Mapping. The units could be pulse/s or 0.1 rpm.

#### `reset-fault ( ch n -- )`

When EtherCAT slave `n` at channel `ch` of a motor drive is in the Fault of FAS state, switch that motor drive to the Switch on Disabled state. The master will automatically set the corresponding Control Word.

#### `target-p! ( pos ch n -- )`

Set the target position `pos` (via PDO) for the motor drive on EtherCAT slave `n` channel `ch`.

The corresponding object is 0x607A. The unit is usually encoder pulses.

#### `target-p@ ( ch n -- pos )`

Get the target position `pos` of motor drive `n` on channel `ch` of EtherCAT slave in Botnana Control using Mapacode.

#### `target-reached? ( ch n -- flag )`

Obtain the Status Word Bit 10 (target reached) for EtherCAT slave `n`'s motor drive channel `ch` to determine if it is 1.

This status comes from the same source as `drive-sw@`.

#### `target-tq! ( tq ch n -- )`

Use an SDO request to set target torque `tq` for the motor drive on channel `ch` of EtherCAT slave `n`.

The corresponding object is 0x6071. The unit is typically 0.1% of rated torque.

This command is intended for TQ mode. To provide a cyclic target torque in CST mode, map object 0x6071 as a user PDO and write it with `drive-wpdo1!` or `drive-wpdo2!`.

#### `target-v! ( vel ch n -- )`

Use an SDO command to set target velocity `v` for the motor drive on channel `ch` of EtherCAT slave `n`.

The corresponding Object is 0x60FF. The unit could be pulse/s or 0.1 rpm.

This command is intended for PV mode. To set target velocity in CSV mode, use `drive-wpdo1!` or `drive-wpdo2!`.

#### `tq-ofs! ( ofs ch n -- )`

Set torque offset `ofs` for the motor drive on channel `ch` of EtherCAT slave `n` through PDO data.

The master configuration must map torque offset (object 0x60B2) into the drive's PDO mapping. This command is typically used in CSP, CSV, or CST mode to adjust the torque target in the drive's torque-control loop. The unit is typically 0.1% of rated torque.

#### `tq-ofs@ ( ch n -- ofs )`

Get torque offset `ofs` for the motor drive on channel `ch` of EtherCAT slave `n` through PDO data.

The master configuration must map torque offset (object 0x60B2) into the drive's PDO mapping.

#### `tq-slope! ( slope ch n -- )`

Use an SDO request to set the torque slope `slope` for the motor drive on channel `ch` of EtherCAT slave `n`.

The corresponding object is 0x6087. The unit is typically 0.1% of rated torque per second.

In TQ mode, the drive uses this value to plan changes in torque output. It is commonly used with `drive-vmax!` to limit motor speed while the commanded torque has not yet been reached.

#### `until-drive-on ( ch n -- )`

Wait for the FSA State of EtherCAT slave `n` channel `ch` motor drive to reach Operation Enabled.

Because this command contains `pause`, it is suitable only for a background task.

This command is equivalent to:

    : until-drive-on ( ch n -- )
        begin
            over over drive-on? not
        while
            pause
        repeat
        drop drop ;

#### `until-no-fault ( ch n -- )`

Wait for Status Word Bit 3 (Fault) of EtherCAT slave `n`'s motor drive channel `ch` to be 0.

Because this command contains `pause`, it is suitable only for a background task.

It's equivalent to

    : until-no-fault ( channel slave -- )
        pause pause pause pause pause pause \ Make sure you get the latest status word from the drive
        begin
            over over drive-fault?
        while
            pause
        repeat
        drop drop ;

#### `until-target-reached ( ch n -- )`

Wait for Status Word Bit 10 (target reached) of motor drive on EtherCAT slave `n` channel `ch` to be 1.

Because this command contains `pause`, it is suitable only for a background task.

This command is equivalent to:

    : until-target-reached ( channel slave -- )
        pause pause pause pause pause pause \ Make sure you get the latest status word from the drive
        begin
            over over target-reached? not
        while
            pause
        repeat
        drop drop
    ;

#### `v-ofs! ( ofs ch n -- )`

Set Velocity Offset `ofs` for the motor drive on channel `ch` of EtherCAT slave `n`.

Set the master configuration file, and the motor drive in this channel can map the Velocity Offset (object 0x60B1) to the PDO Mapping.

This command is typically used in CSP or CSV mode, where the velocity control circuit within the motor drive can be further adjusted to the velocity target value. The unit is usually pulse/s or 0.1 rpm.

#### `v-ofs@  ( ch n -- ofs )`

Get the Velocity Offset `ofs` of EtherCAT slave `n`'s channel `ch` motor drive.

Set the master configuration file, and the motor drive in this channel can map the Velocity Offset (object 0x60B1) to the PDO Mapping.

#### PP-TEST example

A motor drive using the EtherCAT slave number 1.

    : pp-test
        pp 1 1 op-mode!          \ Switch to PP Mode
        until-no-requests        \ Wait op-mode! The command is actually set to drive.
        1 1 reset-fault          \ Unleash the drive.
        1 1 until-no-fault       \ Wait for the drive to be unleashed
        1 1 drive-on             \ Drive On
        1 1 until-drive-on       \ Waiting for the Drive on process to complete
        1000 1 1 target-p!       \ Set target position to 1000
        1 1 go                   \ New set-point
        1 1 until-target-reached \ Waiting to reach the target.
    ;

    deploy pp-test ;deploy       \ Perform the pp-test in the Background Task

#### Command Reference

| Command | Stack effect                       |
|-----|------------------------------|
| +drive-halt           | ( ch n -- )           |
| +drive-homed          | ( ch n -- )           |
| +pp-cosp              | ( ch n -- )           |
| +pp-imt               | ( ch n -- )           |
| +pp-rel               | ( ch n -- )           |
| -drive-halt           | ( ch n -- )           |
| -drive-homed          | ( ch n -- )           |
| -pp-cosp              | ( ch n -- )           |
| -pp-imt               | ( ch n -- )           |
| -pp-rel               | ( ch n -- )           |
| csp                   | ( -- 8 )              |
| cst                   | ( -- 10 )             |
| csv                   | ( -- 9 )              |
| drive-cw!             | ( cw ch n -- )        |
| demand-p@             | ( ch n -- pos )       |
| demand-tq@            | ( ch n -- tq )        |
| demand-v@             | ( ch n -- vel )       |
| drive-dins@           | ( ch n -- dins )      |
| drive-douts!          | ( douts ch n -- )     |
| drive-douts-mask!     | ( mask ch n -- )      |
| drive-fault?          | ( ch n -- flag )      |
| drive-homed?          | ( ch n -- flag )      |
| drive-nl?             | ( ch n -- nl )        |
| drive-nsl!            | ( nsl ch n -- )       |
| drive-nsl@            | ( ch n -- nsl )       |
| drive-off             | ( ch n -- )           |
| drive-on              | ( ch n -- )           |
| drive-on?             | ( ch n -- flag )      |
| drive-org?            | ( ch n -- org )       |
| drive-pl?             | ( ch n -- pl )        |
| drive-psl!            | ( psl ch n -- )       |
| drive-psl@            | ( ch n -- psl )       |
| drive-polarity!       | ( polarity ch n -- )  |
| drive-rpdo1@          | ( ch n -- r1 )        |
| drive-rpdo2@          | ( ch n -- r2 )        |
| drive-stop            | ( ch n -- )           |
| drive-sw@             | ( ch n -- sw )        |
| drive-vmax!           | ( vmax ch n -- )      |
| drive-wpdo1!          | ( w1 ch n -- )        |
| drive-wpdo1@          | ( ch n -- w1 )        |
| drive-wpdo2!          | ( w2 ch n -- )        |
| drive-wpdo2@          | ( ch n -- w2 )        |
| go                    | ( ch n -- )           |
| hm                    | ( -- 6 )              |
| homing-a!             | ( acc ch n -- )       |
| homing-method!        | ( method ch n -- )    |
| homing-v1!            | ( v1 ch n -- )        |
| homing-v2!            | ( v2 ch n -- )        |
| op-mode!              | ( mode ch n -- )      |
| pds-goal!             | ( goal ch n -- )      |
| pp                    | ( -- 1 )              |
| profile-a1!           | ( a1 ch n -- )        |
| profile-a2!           | ( a2 ch n -- )        |
| profile-v!            | ( vel ch n -- )       |
| pv                    | ( -- 3 )              |
| real-p@               | ( ch n -- pos )       |
| real-tq@              | ( ch n -- tq )        |
| real-v@               | ( ch n -- vel )       |
| reset-fault           | ( ch n -- )           |
| target-p!             | ( pos ch n -- )       |
| target-p@             | ( ch n -- pos )       |
| target-reached?       | ( channel n -- flag ) |
| target-tq!            | ( tq ch n -- )        |
| target-v!             | ( vel ch n -- )       |
| tq                    | ( -- 4 )              |
| tq-ofs!               | ( ofs ch n -- )       |
| tq-ofs@               | ( ch n -- ofs )       |
| tq-slope!             | ( slope ch n -- )     |
| until-drive-on        | ( ch n -- )           |
| until-no-fault        | ( ch n -- )           |
| until-target-reached  | ( ch n -- )           |
| v-ofs!                | ( ofs ch n -- )       |
| v-ofs@                | ( ch n -- ofs )       |
