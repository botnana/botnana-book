### Job Operation

For coordinated motion using axis groups. A Job refers to the work done by all axis groups together.

Coordinate explanation

* ACS: Axis Coordinate System
* *MCS : Machine Coordinate System (Machine Coordinate System or Earth Coordinate System)*
* PCS: Product Coordinate System/Program Coordinate System (Workpiece Coordinate System)

**Axis group concept**

```

        +--------------+
        |  Coordinator |
        |              |
        +-------+------+
                |
    +-------------------------+
    |           |             |
+---+---+    +--+----+    +---+---+
| Group |    | Group |    | Group |
| (1D)  |    |  (2D) |    |  (3D) |
+---+---+    +--+----+    +--+----+
    |           |            |
    |           +----------+ +----------+------------+
    |           |          | |          |            |
+---+---+   +---+---+   +--+-+--+   +---+---+   +----+--+
|  Axis |   |  Axis |   |  Axis |   |  Axis |   |  Axis |
|       |   |       |   |       |   |       |   |       |
+---+---+   +---+---+   +---+---+   +---+---+   +-------+
    |           |           |           |
    |           |           |           |
    |           |           |           |
+---+---+   +---+---+   +---+---+   +---+---+
| Drive |   | Drive |   | Drive |   | Drive |
|       |   |       |   |       |   |       |
+-------+   +-------+   +-------+   +-------+

```

**Coordinator (Coordinated Motion Function)**:

Multi-axis coordinated motion control. EtherCAT communication has the characteristic of time synchronization, making it suitable for implementing coordinated motion functionality.

The EtherCAT motor drives selected for this multi-axis coordinated motion control must support Cyclic Synchronous Position Mode (CSP), which is generally supported by EtherCAT motor drives.

**Axis Group**:

Axis group motion function is as follows:

1. S-type plus deceleration curve
2. Planning the path of a straight line and a circular arc.
3. Path movement velocity limitation.
4. look-ahead.
5. Multiple axis groups can be operated simultaneously (whether the motion axis is limited or controlled by other motion functions).

Currently, the following types are available:

1. Single-axis (1D)
2. Two orthogonal axes (2D).
3. Three orthogonal axes (3D).
4. Synchronous wave.

Axis (Motion Axis)

Controlled by axis group, performing point-to-point motion or coordinated motion. If there is no corresponding drive device, it is a virtual axis. When the motion axis is a virtual axis, the actual position is calculated from the command position.

When performing point-to-point motion, pay attention to the following:

1. S-type plus deceleration curve
2. The velocity of motion can only change at a steady rate. The acceleration curve is planned according to the maximum acceleration and maximum velocity of the motion axis.
3. The target position can be changed at any time during the movement.

**Drive**: EtherCAT controller

Real-time motor drive device. Can be different brands or types of motor drives.

**Motion Axis**

The length unit in Botnana Control is by default in meters [m], and the time unit is in seconds [s].
The resulting units are `m/s` for velocity, `m/s^2` for acceleration, and `m/s^3` for jerk.

Suppose there is a 1D linear motion system, the resolution of the motor encoder is set to 1000000 pulse = 1 m.

Example: Length units in meters.

* Group vmax = 0.01 [m/s]
* Group amax = 5.0  [m/s^2]
* Group jmax = 40.0 [m/s^3]
* Group ignorable distance = 0.0000005 [m]
* Axis encoder_ppu = 1000000
* Axis encoder_length_unit = Meter
* Axis vmax = 0.01 [m/s]
* Axis amax = 5.0  [m/s^2]
* Axis ignorable distance = 0.0000005 [m]

Example: Setting for Length Units in Pulse (Pulse) Units.

* Group vmax = 10000.0 [pulse/s]
* Group amax = 5000000.0  [pulse/s^2]
* Group jmax = 40000000.0 [pulse/s^3]
* Group ignorable distance = 0.5 [pulse]
* Axis encoder_ppu = 1
* Axis encoder_length_unit = Pulse
* Axis vmax = 10000.0 [pulse/s]
* Axis amax = 5000000.0  [pulse/s^2]
* Axis ignorable distance = 0.5 [pulse]

Assuming there is a 1D rotational motion system, the resolution of the motor encoder is set to 3600000 pulse = 1 rev, with a rotational cutting velocity of 100 mm in radius to compare the linear velocity.
Botnana Control calculates in radians, so conversion is necessary.

Example: Length units in degrees.

* Group vmax = 0.1 [rad/s]
* Group amax = 50.0  [rad/s^2]
* Group jmax = 400.0 [rad/s^3]
* Group ignorable distance = 0.0000005 [rad]
* Axis encoder_ppu = 3600000
* Axis encoder_length_unit = Revolution
* Axis vmax = 0.1 [rad/s]
* Axis amax = 50.0  [rad/s^2]
* Axis ignorable distance = 0.0000005 [rad]

**Command Location:**

When the coordinated motion control function (+coordinator) is enabled, Botnana Control converts the motion axis commands to motor drivers commands based on the axis settings.
When coordinated motion control (coordinator) is enabled, and the controller is controlled by motion axes, it is not possible to directly set the command position of the motor driver.

If an axis group is running and coordinated motion is initiated according to a path plan, or paused during motion, Botnana Control will allocate the motion command to the corresponding motion axis based on the axis group settings.
Commands for motion axes are controlled by axis groups. When switching between groups, ensure there is no discontinuity in the command positions of shared motion axes.

**Large Following Error Handling**

When the commanded position differs significantly from the actual position during axis motion, it usually indicates an axis control issue. After resolving the fault, the following method can be used to eliminate the large following error:

* When coordinated motion is not enabled or the motion axis is not controlled by the motor driver, directly set the actual position of the motor driver. For example:

```
    1 1 real-p@ 1 1 target-p!
```

* When coordinated motion is enabled and the motion axis is not controlled by an axis group, for example:

```
    1 0axis-ferr    \ Removing backward errors on the 1st axis of motion
```

* When coordinated motion is enabled and the motion axis is controlled by an axis group, for example:

```
    1 group! 0path     \ Suppose the axis group is 1, switch axis group to 1, clear path.
    1 0axis-ferr       \ Suppose the 1st axis of motion is controlled by the 1st axis group and the 1st axis of motion is defective.
    2 0axis-ferr       \ Suppose the second axis of motion is controlled by the first axis group and the second axis of motion is deleted.
```

### Coordinator

#### `.coordinator ( -- )`

Outputs the status of the axis group.

foreground task for coordinated motion of motion axis in axis group.

```
    coordinator_enabled|0

    coordinator_enabled: 1 indicates that the coordinated motion function is turned on, and 0 indicates that the coordinated motion function is turned off.
```

#### `+coordinator ( -- )`

Enable coordinated motion control function.

Botnana Control performs trajectory planning and position interpolation for motion axes or axis groups based on the path or target positions.

In this mode, the driver must switch to CSP Mode.

#### `-coordinator ( -- )`

Disable coordinated motion control function.

#### `#groups ( -- len )`

Get the number of axis groups, `len`.

#### `#axes ( -- len )`

Get the number of motion axes, `len`.

#### `coordinator? ( -- t )`

Is the axis group enabled?

#### `empty? ( -- t )`

Are all axis groups' paths empty?

#### `ems-job ( -- )`

Emergency stop for coordinated motion. All point-to-point motions of axis groups and motion axes will immediately stop. Path information for axis groups will be cleared.

#### `end? ( -- t )`

Does coordinated motion between axis group and motion axis reach the path endpoint?

#### `reset-job ( -- )`

Clear all axis group's route information.

#### `start-job ( -- )`

Start coordinated motion for all axis groups.

#### `stop? ( -- t )`

So, has coordinated motion between axis groups and motion axes been stopped?

#### `stop-job ( -- )`

Command all axis groups and motion axes to point-to-point motion with deceleration and stop.

#### Command Reference

| Command | Stack effect                       | Explanation |
|-----|------------------------------|----|
| `.coordinator` |( --  ) | Output axis group status
| `+coordinator` |( -- ) | Activate the axis group function
| `-coordinator` |( -- ) | Turn off axis group functions
| `#groups`       |( -- len ) | Get the number of axis groups
| `#axes`         |( -- len ) | Get the number of motion axis
| `coordinator?` |( -- t ) | Is the axis group open?
| `empty?`        |( -- t ) |  Have all axis group paths been cleared?
| `ems-job`       |( -- ) | Order so axis group to stop urgently
| `end?`          |( -- t ) | Have all the axis groups reached the end of their path?
| `reset-job`    |( -- ) | Clear all axis group paths
| `start-job`    |( -- ) | Order all axis groups to move
| `stop?`         |( -- t ) | Have all the axis groups stopped moving?
| `stop-job`      |( -- ) | Order all axis groups to stop moving.

---

### Axis Group

#### `.group ( g -- )`

output group `g` News

example command:

    1 .group  \ output Information from the first axis group

return message

    group_enabled.1|0
    |group_stopping.1|1
    |move_count.1|0
    |path_event_count.1|0
    |path_id.1|0
    |path_mode.1|0
    |focus.1|0
    |source.1|0
    |pva.1|0.0000000,0.00000,0.00000
    |move_length.1|0.0000000
    |total_length.1|0.0000000
    |feedrate.1|0.00000
    |vcmd.1|0.00000
    |max_look_ahead_count.1|0
    |ACS.1|0.0000000,0.0000000,0.0000000
    |MCS.1|0.0000000,0.0000000,0.0000000
    |PCS.1|0.0000000,0.0000000,0.0000000

#### `.grpcfg ( g -- )`

output group `g` the setting parameters

Example command:

    1 .grpcfg  \ The output parameter of the first axis group

return message:

    group_name.1|Anonymous
    |group_type.1|3D
    |group_mapping.1|1,2,3
    |group_vmax.1|0.10000
    |group_amax.1|5.00000
    |group_jmax.1|80.00000
    |group_ignorable_distance.1|0.0000005

#### `+group`

Activate the currently selected axis group.

example command:

    1 group!   \ Select axis group 1.
    +group     \ Start the currently selected axis group.

#### `-group`

Close the currently selected axis group.

#### `0path`

The current axis group is cleared of routing information.

example command:

    1 group!  \ Select axis group 1.
    0ptah     \ Clearing the current axis group routing information

#### `acs-p@ ( n -- ) ( F: -- pos )`

The current axis group, the ACS coordinate system, has been obtained. `n` The coordinate position of the axis.

example command:

    1 acs-p@ f. \ Get the first axis coordinate position and then output position information

return message:

    0.0000000

#### `feedrate! ( F: v -- )`

Set the maximum motion velocity `v` for subsequently inserted paths. `v` must be greater than 0.

example command:

    100.0e mm/min feedrate!  \ Set the current group feed rate to 100.0 mm/min

#### `feedrate@ ( F: -- v )`

Get the maximum motion velocity `v` for subsequently inserted paths.

example command:

    feedrate@ f. \ Get group feedrate and output messages

return message:

    0.1000000

#### `gamax! ( g -- ) ( F: a -- )`

Set maximum acceleration `a` for axis group `g`.

Example command:

    2.0e 1 gamax! \ Set the maximum acceleration for Group 1 to be 2.0

#### `gend? ( -- flag )`

Is the selected axis group reaching the end of the path?

#### `gignore-dist! ( g -- ) ( F: dist --)`

Set the ignorable distance-calculation error `dist` for axis group `g`.

It is usually set to 0.5 or 0.1 in the pulse system. [pulse]Other settings are 0.5e-6 or 0.1e-6 [m] or [rad]

#### `gjmax! ( g -- ) ( F: j -- )`

Set maximum jerk `j` for axis group `g`.

Example command:

    40.0e 1 gjmax! \ Set the maximum acceleration for Group 1 to be 40.0

#### `gmap! ( j1 j2 j3 ... g -- )`

Set the axis group. `g` The motion axis is controlled. `j1 j2 j3 ...`The number of axis groups and the number of axis of motion should be considered.

Please note:

1. axis group `g` Can't be in the boot mode.
2. the axis of motion `j` It cannot be controlled by axis groups in other launches or point-to-point motion modes.
3. The axis group model and the number of motion axes must be matched correctly.

Example command:

                  \ Assume that the axis group 1 is a 3D axis group.
    2 3 4 1 gmap! \ Set the group 1 corresponding motion axis numbered 2, 3, 4 respectively
    2 1 gmap!     \ Set the group 1 corresponding motion axis number to 2 and return the stack underflow error.

#### `gmap@ ( g -- j1 j2 j3 ... )`

To obtain the axis group controlled motion axis, it is necessary to pay attention to the axis group pattern and the number of motion axis.

#### `group! ( g -- )`

Set the currently selected axis group. `g`, `g`  Numbers start with 1.

#### `group@ ( -- g )`

To get the axis group currently selected. `g`The command example:

    group@                  \ Get the current axis group number
    1 group! 0.1e feedrate! \ Select axis group 1 and set feedrate
    group!                  \ The axis group switches back to the original axis group.

#### `group? ( -- t )`

Is the currently selected axis group activated?

#### `grp1d? ( g -- flag )`

Specify the axis group `g` Is it a 1D axis group?

#### `grp2d? ( g -- flag )`

Specify the axis group `g` Is it a 2D axis group?

#### `grp3d? ( g -- flag )`

Specify the axis group `g` Is it a 3D axis group?

#### `grp-sine? ( g -- flag )`

Specify the axis group `g` Is it the Sine Wave axis group?

#### `gstart ( -- )`

The axis group selected by the command begins to move.

example command:

    1 group! gstart  \ Switch to axis group 1, command axis group 1 to start motion.

#### `gstop ( -- )`

The selected axis group is commanded to stop motion.

example command:

    1 group! gstop  \ Switch to axis group 1, order axis group 1 to stop movement.

#### `gstop? ( -- flag )`

Has the selected axis group stopped moving?

#### `gvmax! ( g -- ) ( F: v -- )`

Set maximum velocity `v` for axis group `g`.

Example command:

    1000.0e mm/min 2 gvmax! \ Set the maximum speed of Group 1 to 1000.0 mm/min

#### `map-len@ ( g -- len )`

Get the number of motion axes `len` in axis group `g`.

#### `map-sine ( j1 g -- )`

Map motion axis `j1` to axis group `g`.

Please note:

1. axis group `g` It must be for the Sine Wave axis group.
2. axis group `g` Can't be in the boot mode.
3. The axis of motion `j1` It cannot be controlled by axis groups in other launches or point-to-point motion modes.

Command example:

    3 1 map-sine  \ Set the motion axis of Group 1 to Axis 3.

#### `map1d ( j1 g -- )`

Map motion axis `j1` to axis group `g`.

Please note:

1. axis group `g` It has to be a 1D axis group.
2. axis group `g` Can't be in the boot mode.
3. The axis of motion `j1` It cannot be controlled by axis groups in other launches or point-to-point motion modes.

Example command:

    3 1 map1d  \ Set the motion axis of Group 1 to Axis 3.

#### `map2d ( j1 j2 g -- )`

Map motion axes `j1` and `j2` to axis group `g`.

Please note:

1. axis group `g` It has to be a 2D axis group.
2. axis group `g` Can't be in the boot mode.
3. The axis of motion `j1 j2` It cannot be controlled by axis groups in other launches or point-to-point motion modes.

Example command:

    3 5 2 map2d \ Set the motion axis of Group 2 to Axis 3, 5

#### `map3d ( j1 j2 j3 g -- )`

Map motion axes `j1`, `j2`, and `j3` to axis group `g`.

Please note:

1. axis group `g` It has to be a 3D axis group.
2. axis group `g` Can't be in the boot mode.
3. The axis of motion `j1 j2 j3` It cannot be controlled by axis groups in other launches or point-to-point motion modes.

Example command:

    3 5 6 2 map3d Set the motion axis of Group 2 to Axis 3, 5, 6

#### `mcs ( -- )`

Declares the selected axis group as the starting point of the path with the current MCS coordinate position (overlapping PCS and MCS coordinate system).

#### `mcs-p@  ( n -- ) ( F: -- pos )`

Get position `pos` for axis `n` in the selected axis group's MCS coordinate system.

Example command:

    1 mcs-p@  \ The MCS coordinate system position on the 1st axis.

#### `move-source#  ( -- n )`

Get the current path-event index `n` for the selected axis group.

#### `next-a@  ( F: -- a )`

Get tangential path acceleration `a` for the selected axis group.

#### `next-path-id@ ( -- id )`

Get the current path ID `id` for the selected axis group.

#### `next-path-mode@ ( -- mode )`

Get the current path mode `mode` for the selected axis group.

#### `next-path-p@  ( -- ) ( F: -- pos )`

Get position `pos` along the path from the selected axis group's motion starting point.

#### `next-v@ ( F: -- v )`

Get tangential path velocity `v` for the selected axis group.

#### `path-events-capacity@ ( -- n )`

Get the path capacity `n` of the selected axis group.

#### `path-events-len@ ( -- n )`

Get the current number of paths `n` in the selected axis group.

#### `path-id! ( id -- )`

Set path ID `id` for subsequently inserted paths.

Apply this example:

1. Storing the corresponding row of the NC program, when executing the axis group movement, can tell which row of the NC program the current position is interpreted from.

#### `path-id@ ( -- id )`

Get the ID `id` of the next path to be inserted.

#### `path-mode! ( mode -- )`

Set the mode `mode` for the subsequent insertion path.

#### `path-mode@ ( -- mode )`

Get the motion mode `mode` for the following path.

Apply this example:

1. It is used to distinguish between processed and non-processed pathways.

#### `pcs-p@  ( n -- ) ( F: -- pos )`

Get position `pos` for axis `n` in the selected axis group's PCS coordinate system.

#### `vcmd! ( F: v -- )`

Set path velocity `v`.

* When `v` > 0 will continue along the path until the end of the path.
* When `v` At 0, the velocity decreases to 0.
* When `v` When <0, it will retreat along the path until the start of the path.

The speed limit is as follows:

1. vcmd! specified velocity.
2. The axis group's maximum motion velocity (`gvmax!`).
3. The input velocity (feedrate) of the current path.
4. Foresee the path director and current position.

example command:

    100.0e mm/min vcmd! \ Set the speed of motion to 100.0 mm/min

#### Command Reference

| Command | Stack effect                       | Explanation |
|-----|------------------------------|------|
| .group                | ( g -- )                  | Display axis-group state. |
| .grpcfg               | ( g -- )                  | Show the axis group Set the parameter
| +group                | ( -- )                    | Start the selected axis group.
| -group                | ( -- )                    | Close the selected axis group.
| 0path                 | ( -- )                    | Delete selected axis group path information
| acs-p@                | ( n -- ) ( F: -- pos )    | Obtain the coordinate position of the specified axis of the selected axis group ACS coordinate system.
| feedrate!             | ( F: v -- )               | Set the maximum motion velocity of the subsequent insert path.
| feedrate@             | ( F: -- v )               | The maximum velocity of the subsequent insert path.
| gamax!                | ( g -- ) ( F: a --)       | Set the maximum acceleration of a specified axis group
| gend?                 | ( -- flag )               | Is the selected axis group reaching the end of the path?
| gignore-dist!         | ( g -- ) ( F: dist --)    | Setting a negligible length computation error to specify the axis group
| gjmax!                | ( g -- ) ( F: j --)       | Set the maximum added acceleration of a specified axis group.
| gmap!                 | ( j1 j2 j3 ... g -- )     | Set the motion axis controlled by the axis group and pay attention to the axis group pattern and the number of motion axes.
| gmap@                 | ( g -- j1 j2 j3 ... )     | To get the axis group controlled by the motion axis, it is necessary to pay attention to the axis group pattern and the number of motion axis.
| group!                | ( g -- )                  | Select the axis group.
| group@                | ( -- g )                  | To get the axis group currently selected.
| group?                | ( -- t )                  | Is the currently selected axis group activated?
| grp1d?                | ( g -- flag )             | The axis group is defined as the 1D axis group.
| grp2d?                | ( g -- flag )             | If the axis group is defined as a 2D axis group
| grp3d?                | ( g -- flag )             | If the axis group is specified as a 3D axis group
| grp-sine?             | ( g -- flag )             | Specify whether the axis group is a Sine Wave axis group
| gstart                | ( -- )                    | Axis group selected by the command to start movement
| gstop                 | ( -- )                    | The selected axis group is commanded to stop movement
| gstop?                | ( -- flag )               | Has the selected axis group stopped moving?
| gvmax!                | ( g -- ) ( F: v --)       | Set the maximum velocity of the specified axis group.
| map-len@              | ( g -- len )              | Number of motion axes for a specified axis group
| map-sine              | ( j1 g -- )               | Set the motion axis controlled by the Sine Wave axis group
| map1d                 | ( j2 g -- )               | Set the motion axis controlled by the 1D axis group
| map2d                 | ( j1 j2 g -- )            | Set the motion axis controlled by a 2D axis group.
| map3d                 | ( j1 j2 j3 g -- )         | Set the motion axis controlled by the 3D axis group
| mcs                   | ( -- )                    | Declares the selected axis group as the starting point of the path with the current MCS coordinate position
| mcs-p@                | ( n -- ) ( F: -- pos )    | Obtain the coordinate position of the specified axis of the selected axis group MCS coordinate system.
| move-source#          | ( -- n )                  | The selected axis group is currently on which path events are occurring
| next-a@               | ( F: -- a )               | Acceleration of selected axis group paths across lines.
| next-path-id@         | ( -- id )                 | Get the selected axis group, current route number
| next-path-mode@       | ( -- mode )               | Get the selected axis group, current path pattern
| next-path-p@          | ( -- ) ( F: -- pos )      | Get the selected axis group, starting from the starting point of the movement, along the direction of the path path.
| next-v@               | ( F: -- v )               | Get the selected axis group path cutting line direction velocity.
| path-events-capacity@ | ( -- n )                  | The number of paths that a selected axis group can accommodate
| path-events-len@      | ( -- n )                  | Get the current number of paths for the selected axis group
| path-id!              | ( id -- )                 | Set the number of subsequent insertion paths
| path-id@              | ( -- id )                 | Numbers for subsequent insertion routes
| path-mode!            | ( mode -- )               | Set the pattern of subsequent insertion paths
| path-mode@            | ( -- mode )               | Models for subsequent insertion paths
| pcs-p@                | ( n -- ) ( F: -- pos )    | Obtain the coordinate position of the specified axis of the selected axis group PCS coordinate system.
| vcmd!                 | ( F: v -- )               | Set the velocity command for the selected axis group

### 1D Path Planning

Please note:

1. The axis group currently selected must be 1D.
2. The starting point of the path is the target point of the previous path.
3. must declare the starting point of the path (( move1d, mcs, psc1d)

#### `line1d ( F: x -- )`

The target point is increased to: (`x`) The path of a straight line.

#### `move1d ( F: x -- )`

Declare the current position as the PCS coordinate. (`x`)It is also the starting point for the path. G92 code, similar to the GM code of the workflow program.

#### `pcs1d ( F: x0 -- )`

Declare the PCS coordinate zero(`x0`)G54, which is similar to the GM code of a workflow program.

#### Example: test-1d

Assume that Group 1 is a 1D group with a velocity of 100.0 mm.min through a relative starting point of -0.5, 1.0, and a coordinate position of 0.0 at the end.

    : test-1d                      \ Definition of test-1d instructions
        +coordinator               \ Axis movement control mode to start
        start-job                  \ Starting the deceleration mechanism
        1 group! +group            \ Switch to axis group and start group 1.
        0path                      \ Clear the path of Group 1
        0.0e move1d                \ Declare the current position as the starting position of the movement, the coordinates are 0.0
        -0.5e line1d               \ Insert a 1D straight line path with a target point of -0.5
        1.0e line1d                \ Insert a 1D straight line path with a target point of 1.0
        0.0e line1d                \ Insert a 1D straight line path at a target point of 0.0
        100.0e mm/min vcmd!        \ Set the speed of motion to 100.0 mm/min
        begin                      \ Waiting for the final position.
            1 group! gend? not     \ Check to see if you have reached the end, here is group 1! to avoid being modified by other instructions while waiting.
        while
            pause                  \ If the end is not reached, wait for the next cycle to be checked.
        repeat
        1 group! -group            \ Group 1 is closed.
    ;

    deploy test-1d ;deploy         \ Test-1d in the background

#### Command Reference

| Command | Stack effect        | Explanation |
|-----|----------------|-----|
| line1d | ( F: x -- ) | Insert a 1D linear path
| move1d | ( F: x -- ) | The current PCS coordinates are: (x)And it's the beginning of a path.
| pcs1d | ( F: x0 -- ) | Declare the PCS coordinate zero and use the current position as the starting point of the path

### 2D Path Planning

Please note:

1. The axis group currently selected must be 2D.
2. The starting point of the path is the target point of the previous path.
3. must declare the starting point of the path (( move2d, mcs, psc2d)

#### `arc2d ( n -- )( F: cx cy x y -- )`

Add a 2D circular path centered at (`cx`, `cy`) with target position (`x`, `y`). `n` specifies the number of revolutions from the starting point to the target.

* `n` >0 represents the movement of the counterclockwise direction.
* `n` <0 indicates the timeline of movements,
* `n` It can't be 0.

#### `line2d ( F: x y -- )`

The target point is increased to: (`x`,`y`) The path of a straight line.

#### `move2d ( F: x y -- )`

Declare the current position as the PCS coordinate. (`x`, `y`)It is also the starting point for the path. G92 code, similar to the GM code of the workflow program.

#### `pcs2d ( F: x0 y0 -- )`

Declare the PCS coordinate zero(`x0`, `y0`)G54, which is similar to the GM code of a workflow program.

#### Example: test-2d

Suppose Group 1 is a 2D group.

    : test-2d                          \ Defining the test-2d instruction
        +coordinator                   \ Axis movement control mode to start
        start-job                      \ Starting the deceleration mechanism
        1 group! +group                \ Starting Group 1
        0path                          \ Clear the path
        0.0e  0.0e  move2d             \ The current position is declared as the starting position of the movement, and the coordinates are: (0.0, 0.0)
        0.1e  0.0e  line2d             \ Inject the target point. (0.1, 0.0) The 2D linear path
        0.1e  0.1e  line2d             \ Inject the target point. (0.1, 0.1) The 2D linear path
        0.0e  0.1e  line2d             \ Inject the target point. (0.0, 0.1) The 2D linear path
        0.0e  0.05e 0.0e 0.0e 1 arc2d  \ Go backwards to the target point (0.0, 0.0) with the center position (0.0, 0.05)
        100.0e mm/min vcmd!            \ Set the speed of motion to 100.0 mm/min
        begin                          \ Waiting for the final position.
            1 group! gend? not         \ Check to see if you have reached the end, here is group 1! to avoid being modified by other instructions while waiting.
        while
            pause                      \ If the end is not reached, wait for the next cycle to be checked.
        repeat
        1 group! -group                \ Group 1 is closed.
    ;

    deploy test-2d ;deploy         \ Test 2d in the background

#### Command Reference

| Command | Stack effect        | Explanation |
|-----|----------------|-----|
| arc2d     | ( n -- )( F: cx cy x y -- )   | Insert a 2D circular arc path
| line2d    | ( F: x y -- )                 | Insert a 2D linear path
| move2d    | ( F: x y -- )                 | The current PCS coordinates are: (x, y)And it's the beginning of a path.
| pcs2d     | ( F: x0 y0 -- )               | Declare the PCS coordinate zero and use the current position as the starting point of the path

### 3D Path Planning

Please note:

1. The axis group currently selected must be in 3D format.
2. The starting point of the path is the target point of the previous path.
3. must declare the start of the path (( move3d, mcs, psc3d))

#### `helix3d ( n -- )( F: cx cy x y z -- )`

Add a 3D helical path centered at (`cx`, `cy`) with target position (`x`, `y`, `z`). `n` specifies the number of revolutions required to reach the target.

* `n` >0 represents the movement of the counterclockwise direction.
* `n` <0 indicates the timeline of movements,
* `n` It can't be 0.

If `z` is the same as the origin, this spiral path is a circular arc in the XY plane.

#### `line3d ( F: x y z-- )`

The target point is increased to: (`x`,`y`, `z`) The path of a straight line.

#### `move3d ( F: x y z -- )`

Declare the current position as the PCS coordinate. (`x`, `y`, `z`)It is also the starting point for the path. G92 code, similar to the GM code of the workflow program.

#### `pcs3d ( F: x0 y0 z0 -- )`

Declare the PCS coordinate zero(`x0`, `y0`, `z0`)G54, which is similar to the GM code of a workflow program.

#### Example: test-3d

Suppose Group 1 is a 3D group.

    : test-3d                          \ Defining the test-3d instruction
        +coordinator                   \ Axis movement control mode to start
        start-job                      \ Starting the deceleration mechanism
        1 group! +group                \ Starting Group 1
        0path                          \ Clear the path of Group 1
        0.0e  0.0e  0.0e   move3d      \ The current position is declared as the starting position of the movement, and the coordinates are: (0.0, 0.0, 0.0)
        0.0e  0.1e  0.0e  line3d       \ Inject the target point. (0.0, 0.1, 0.0) 3D linear paths
        -0.1e  0.1e -0.2e 0.1e 0.1e  1 helix3d
                                       \ Inverted clockwise along the spiral path to the target point (-0.2, 0.1, 0.1) at the center of the circle (-0.1, 0.1)
        100.0e mm/min vcmd!            \ Set the speed of motion to 100.0 mm/min
        begin                          \ Waiting for the final position.
            1 group! gend? not         \ Check to see if you've reached the end, here's group 1!
        while
            pause                      \ If the end is not reached, wait for the next cycle to be checked.
        repeat
        1 group! -group                \ Group 1 is closed.
    ;

    deploy test-3d ;deploy         \ Test 3d in the background

#### Command Reference

| Command | Stack effect        | Explanation |
|-----|----------------|-----|
| helix3d   | ( n -- )( F: cx cy x y z -- )   | Insert a 3D spiral path
| line3d    | ( F: x y z -- )                 | 3D direct path inserted
| move3d    | ( F: x y z -- )                 | The current PCS coordinates are: (x, y, z)And it's the beginning of a path.
| pcs3d     | ( F: x0 y0 z0 -- )              | Declare the PCS coordinate zero and use the current position as the starting point of the path

### Sine Wave Planner

Please note:

1. The currently selected axis group must be in Sine Wave mode.
2. The path must be declared at the starting point (move3d, mcs, psc3d), where the starting point is the position of phase 0.

#### `move-sine ( F: x -- )`

Declare the current position as the PCS coordinate. (`x`)It's the beginning of a journey.

#### `sine-amp! (F: amp -- )`

Set the wavelength of the strings. It can be modified in motion and the wavelength can only be changed after the starting point.

#### `sine-f! ( F: f -- )`

Set the frequency of the string waves. It can be modified in motion, changing the frequency at the position of 270 deg.

#### `pcs-sine ( F: x0 -- )`

Declare the PCS coordinate zero(`x0`It is the starting point of the path with the current position.

#### Example: test-sine

Suppose Group 1 is SINE Wave Group

    +coordinator          \ Axis movement control mode to start
    start-job             \ Starting the deceleration mechanism
    1 group! +group       \ Starting Group 1
    0path                 \ Clear the path of Group 1
    0.0e   move-sine      \ The current position is declared as the starting position of the movement, and the coordinates are: (0.0)
    1.0e   sine-f!        \ Set the sine wave frequency to 1.0 Hz
    0.01e  sine-amp!      \ Set the sine wave amplitude to 0.01
    ...
    stop-job              \ Stop the deceleration mechanism

#### Command Reference

| Command | Stack effect        | Explanation |
|-----|----------------|-----|
| move-sine   | ( F: x -- )     | The current PCS coordinates are: (x)And it's the beginning of a path.
| sine-amp!   | ( F: amp -- )   | Set the amplitude of the string wave movement
| sine-f!     | ( F: f -- )     | Set the frequency of string wave movement
| pcs-sine    | ( F: x0 -- )    | Declare the PCS coordinate zero and use the current position as the starting point of the path

### Axis

The name suggests:

* command_Position: the target position of the motion axis.
* demand_Position: Command position in motion. If controlled by axis group, demand_position will work with command_position is equal. If the point-to-point motion of the motion axis is equal to the demand in the process_Position moves towards the target position, only when the demand reaches the target point._position will work with command_Position is equal.
* feedback_Position: The actual position returned by the motor encoder or dual position.
* position_correction: position Correction. The correction can be either a correction calculated by Pitch Corrector, or a correction calculated by other strategies.
* corrected_Position: The actual position that has been modified.

   corrected_position = feedback_position - position_correction + home_offset

* following_error: Backward error.

    following_error = demand_position - corrected_position

#### `.axis ( j -- )`

Display the state of motion axis `j`.

example command:

    1 .axis

return message

    axis_command_position.1|0.0000000
    |axis_demand_position.1|0.0000000
    |axis_corrected_position.1|0.0000000
    |encoder_position.1|0.0000000
    |external_encoder_position.1|0.0000000
    |feedback_position.1|0.0000000
    |position_correction.1|0.0000000
    |following_error.1|0.0000000
    |axis_interpolator_enabled.1|0
    |axis_homed.1|0

#### `.axiscfg ( j -- )`

Display the configuration of motion axis `j`.

Example command:

    1 .axiscfg

The return message:

    axis_name.1|A2
    |axis_home_offset.1|0.0000000
    |encoder_length_unit.1|Meter
    |encoder_ppu.1|1000000.00000
    |encoder_direction.1|1
    |ext_encoder_ppu.1|60000.00000
    |ext_encoder_direction.1|-1
    |closed_loop_filter.1|15.0
    |max_position_deviation.1|0.001000
    |drive_alias.1|0
    |drive_slave_position.1|1
    |drive_channel.1|1
    |ext_encoder_alias.1|0
    |ext_encoder_slave_position.1|0
    |ext_encoder_channel.1|0
    |axis_amax.1|5.00000
    |axis_vmax.1|0.10000
    |axis_ignorable_distance.1|0.0000005

#### `+homed ( j -- )`

Set the motion axis. `j` It has returned to its mechanical origin.

#### `-homed ( j -- )`

Set the motion axis. `j` This is not the end of the world, it's the end of the world.

#### `0axis-ferr ( j -- )`

Remove the axis of motion. `j` Backward error. Using the motion axis, the actual position corrects the command position, if the virtual axis is not affected.

#### `axis-amax! ( j -- ) ( F: amax -- )`

Set maximum acceleration `amax` for motion axis `j`.

Example command:

    2.0e 1 axis-amax!  \ Set the Axis 1 amax to 2.0

#### `axis-amax@ ( j -- ) ( F: -- amax )`

Obtain the maximum acceleration `amax` for motion axis `j`.

Example command:

    1 axis-amax@  \ Get the Axis 1 amax

#### `axis-clerr  ( j -- ) ( F: clerr -- )`

Obtain the following error `clerr` for motion axis `j`.

Usually, an external encoder is installed near the orbit or position of the workstation. If the position of the motor encoder differs from that of the main representative of the mechanical transmission system, it is possible to prioritize the inspection of the belt wheel or the connector.

#### `axis-cmd-p! ( j -- )( F: pos -- )`

Set target position `pos` for motion axis `j`.

#### `axis-cmd-p@ ( j -- )( F: -- pos )`

Get the target position `pos` for motion axis `j`.

#### `axis-demand-p@ ( j -- )( F: -- pos )`

Get the command position `pos` for motion axis `j`.

#### `axis-drive@ ( j --  channel slave )`

Get the EtherCAT slave position `slave` and drive-axis number `channel` configured for motion axis `j`.

`slave` The slave position, the closest slave to the main station, is numbered 1, and is incremented in sequence.

If a motor drive is specified by a slave alias, the slave position is obtained by the specified slave alias when the host station is initialized or set.

For a virtual axis, `axis-drive@` returns `channel = 0` and `slave = 0`.

#### `axis-ext-enc@ ( j --  channel slave )`

Get the EtherCAT slave position `slave` and input number `channel` of the external encoder configured for motion axis `j`.

When no external encoder is configured, `axis-ext-enc@` returns `channel = 0` and `slave = 0`.

#### `axis-ferr@ ( j -- ) ( F: ferr -- )`

Obtain the following error `ferr` for motion axis `j`.

#### `axis-ignore-dist! ( j --  ) ( F: dist -- )`

Set the ignorable distance-calculation error `dist` for motion axis `j`.

It is usually set to 0.5 or 0.1 in the pulse system. [pulse]Other settings are 0.5e-6 or 0.1e-6 [m] or [rad]

#### `axis-len ( -- len )`

Get the total number of motion axes `len` configured in Botnana Control.

#### `axis-real-p@ ( j -- )(F: -- pos )`

Obtain the actual position `pos` of motion axis `j`.

#### `axis-rest?  ( j -- flag )`

The motion axis `j` Did the order stop?

This state can be used as a different backward error or double position to switch the monitoring conditions for returning the error.

#### `axis-ts! ( j -- ) ( F: ts -- )`

Set the settling time `ts` sec to determine if motion axis `j` command is stationary.

#### `axis-vmax! ( j -- ) ( F: vmax -- )`

Set maximum velocity `vmax` for motion axis `j`.

Example command:

    0.5e 1 axis-vmax!  \ Set the Axis 1 vmax to 0.5

#### `axis-vmax@ ( j -- ) ( F: -- vmax )`

Obtain the maximum speed `vmax` for motion axis `j`.

#### `axis>pulse ( j -- pulse ) ( F: pos -- )`

Convert command position `pos` for motion axis `j` to encoder position `pulse`.

#### `cl-cutoff! ( j -- ) ( F: freq -- )`

Set cutoff frequency `freq` for the dual-position feedback error filter on motion axis `j`.

This intercept frequency affects the calculation of double position feedback errors, and if raised, the motion response will be closer to the external encoder's feedback position, but the system will be less stable.

#### `drv-alias!  ( drive-alias j -- )`

Use EtherCAT Station Alias `drive-alias` to specify the motor drive for motion axis `j`.

When `drive-alias` = 0 indicates using slave position to specify the motor drive. `drive-alias` In the absence of the motion axis, the motion axis is treated as a virtual axis.

#### `drv-channel!  ( drive-channel j -- )`

How to Use `drive-channel` Specify the motion axis. `j` The control axis of the motor drive.

The modularity of a single EtherCAT slave multi-axis drive is therefore required to use this parameter.

Example command:

    1 3 drv-channel! \ Set the control axis of the corresponding motor drive on Axis 3 to 1.

#### `drv-slave!  ( drive-slave j -- )`

Use EtherCAT Slave Position `drive-slave` to specify the motor drive for motion axis `j`.

Example command:

    2 1 drv-slave!  \ Set the Axis 1 corresponding to the motor drive station number 2.

#### `enc-dir! ( dir j -- ) `

Set motor-motion/encoder direction `dir` for motion axis `j`.

This parameter can be converted when the axis of the machine is defined in the opposite direction to the direction of operation of the motor.

dir can be set to:

* 1: In the same direction
* - One, the other way.

Example command:

    1 3 enc-dir!  \ Set the direction of the Axis 3 encoder

#### `enc-ppu! ( j --) ( F: ppu -- )`

Set motor-encoder pulses per unit distance `ppu` for motion axis `j`.

The command example can be referenced. `enc-u!`

#### `enc-u! ( u j -- )`

Set distance unit `u` for the motor encoder of motion axis `j`.

The units that can be set are:

* u = 0 as Meter,
* u = 1 as Revolution
* u = 2 as Pulse

Example command:

    1000000.0e 3 enc-ppu! \ Set Axis 3 to 1,000,000 encoder pulses per unit distance.
    0 3 enc-u!            \ The encoder unit set to Axis 3 is 1 m away.
                          \ That's 1 m with 100 million pulses. (The number of coding pulses)One pulse is one um.

#### `ext-enc-alias! ( enc-alias j -- )`

Specify the external encoder by EtherCAT Station Alias. See `drive-alias!`.

#### `ext-enc-channel! ( enc-channel j -- )`

Specify the encoder measurement channel for an external encoder. Refer to `drive-channel!`.

#### `ext-enc-dir! ( dir j -- )`

Specify the external encoder direction. See `enc-dir!`.

#### `ext-enc-ofs!  ( j -- )( F: ofs -- )`

Set external-encoder position offset `ofs` for motion axis `j`.

If the external encoder is of an absolute mode, this command can be used to adjust the distance between the external encoder and the physical position from the pulse wave count.

For example, an absolute optical scale with a length of 80 mm in Haydn can be used with a range of 20 ~ 100 mm.
If the direction of installation is the opposite of the direction of motion, it becomes -100 mm ~ -20 mm.
This command can be used to make adjustments in order to convert the adjustment to 20 ~ 100 mm.

##### `ext-enc-ppu!  ( j -- )( F: ppu -- )`

Set external-encoder pulses per unit distance. See `enc-ppu!`; the distance unit is configured with `enc-u!`.

#### `ext-enc-slave!  ( enc-slave j -- )`

Specify the external encoder by EtherCAT Slave Position. See `drive-slave!`.

#### `hmofs! ( j -- ) ( F: ofs -- )`

Set the motion axis. `j` Mechanical zero point coordinate deviation.

Example command:

    0.5e 3 hmofs! \ Set the Axis 3 home offset

#### `homed?  ( j -- flag )`

Is the motion axis `j` in homing state?

#### `max-pos-dev! ( j -- ) ( F: max-dev -- )`

Set the maximum dual-position feedback correction `max-dev` for motion axis `j`. This prevents correction from converging to an incorrect fixed value when the transmission system or its configuration is faulty.

#### `virtual-axis?  ( j -- flag )`

The motion axis `j` Is it a virtual axis?

#### Motion-Axis Following Example

Follow the command position movement of Axis 1 with Axis 2

    ...
    begin
        ... \A condition for the execution
    while
        ........
        2 axis-demand-p@ 1 axis-cmd-p!
        pause
    repeat
    ...

#### Command Reference

| Command | Stack effect                       | Explanation |
|-----|------------------------------|---|
| .axis             | ( j -- )                      | Displays the motion axis status
| .axiscfg          | ( j -- )                      | Show the motion axis set
| +homed            | ( j -- )                      | Set the motion axis back to mechanical origin
| -homed            | ( j -- )                      | Set motion axis not returning to mechanical origin
| 0axis-ferr        | ( j -- )                      | Removing Backward Errors
| axis-aff!         | ( j -- ) ( F: aff -- )        | Set acceleration Advantage gain (functionality not realized)
| axis-afactor!     | ( j -- ) ( F: afactor -- )    | Set the acceleration forward command to convert constants (function not enabled)
| axis-amax!        | ( j -- ) ( F: amax -- )       | Set the motion axis to maximum acceleration.
| axis-amax@        | ( j -- ) ( F: -- amax )       | Maximum acceleration at the axis of motion
| axis-clerr        | ( j --  ) ( F: clerr -- )     | Getting double positions and returning errors
| axis-cmd-p!       | ( j -- ) ( F: pos -- )        | Set the target position of the motion axis.
| axis-cmd-p@       | ( j -- ) ( F: -- pos )        | Get the target position of the motion axis.
| axis-demand-p@    | ( j -- ) (F: -- pos )         | Get the motion axis at the current command position.
| axis-drive@       | ( j --  channel slave )       | EtherCAT station number to get a motor drive
| axis-ext-enc@     | ( j --  channel slave )       | EtherCAT station number for external encoders
| axis-ferr@        | ( j --  ) ( F: ferr -- )      | Get the following error
| axis-ignore-dist! | ( j --  ) ( F: dist -- )      | Set length computation errors that can be ignored
| axis-len          | ( -- len )                    | Get the total number of motion axes
| axis-real-p@      | ( j -- ) (F: -- pos )         | Get the actual position of the motion axis.
| axis-rest?        | ( j -- flag )                 | Is the motion axis command stationary?
| axis-ts!          | ( j -- ) ( F: ts -- )         | Set a stable time to determine whether the motion axis of the command is stationary
| axis-vff!         | ( j -- ) ( F: vff -- )        | Set velocity forward gain (functionality not realized)
| axis-vfactor!     | ( j -- ) ( F: vfactor -- )    | Set the velocity forward command to convert constants (function not enabled)
| axis-vmax!        | ( j -- ) ( F: vmax -- )       | Set the maximum velocity of the axis of motion
| axis-vmax@        | ( j -- ) ( F: -- vmax )       | The maximum velocity at the axis of motion.
| axis>pulse        | ( j -- pulse ) ( F: pos -- )  | Convert the position of the motion axis to the position of the encoder's waves.
| cl-cutoff!        | ( j -- ) ( F: freq -- )       | Set the shutter frequency of the double position return error filter
| drv-alias!        | ( drive-alias j -- )          | Use the EtherCAT Station Alias to specify a motor drive.
| drv-channel!      | ( drive-channel j -- )        | Specify the control axis of the motor drive
| drv-slave!        | ( drive-slave j -- )          | Use the EtherCAT Slave Position to specify a motor drive.
| enc-dir!          | ( dir j -- )                  | Set the motor motion/coding direction
| enc-ppu!          | ( j -- )( F: ppu -- )         | Set motor-encoder pulses per unit distance
| enc-u!            | ( u j -- )                    | Set the unit of distance corresponding to the pulse wave number of the motor encoder
| ext-enc-alias!    | ( enc-alias j -- )            | Use the EtherCAT Station Alias to specify an external encoder
| ext-enc-channel!  | ( enc-channel j -- )          | Specifies the measurement channel for an external encoder
| ext-enc-dir!      | ( dir j -- )                  | Specify the direction of the external encoder
| ext-enc-ofs!      | ( j -- )( F: ofs -- )         | Specify the position of the external encoder
| ext-enc-ppu!      | ( j -- )( F: ppu -- )         | Set external-encoder pulses per unit distance
| ext-enc-slave!    | ( enc-slave j -- )            | Use EtherCAT Slave Position to specify an external encoder
| hmofs!            | ( j -- ) ( F: ofs -- )        | Set the coordinate deviation of the mechanical zero points
| homed?            | ( j -- flag )                 | Whether to get the motion axis back to the state of mechanical origin
| max-pos-dev!      | ( j -- ) ( F: max-dev -- )    | Set the maximum number of command corrections to be returned to the dual position
| virtual-axis?     | ( j --  flag )                | Is the motion axis a virtual axis?

### Single-Axis Motion

The commands are directed to a single motion axis, allowing multiple motion axes to run simultaneously. If the motion axis is controlled by an axis group, no single-axis motion can be performed.

#### `+interpolator ( j -- )`

Start the Axis. `j` One-axis movement.

#### `-interpolator ( j -- )`

Turn off the Axis. `j` Single-axis motion. If in single-axis motion, the velocity will start to decrease to 0.

#### `interpolator-v! ( j -- )（ F: v -- ）`

Set the Axis  `j` Maximum velocity of single-axis motion.

#### Single-Axis Motion Example

Axis 1, for example:

    +coordinator                       \ Activate the axis group function
    1  +interpolator                   \ Start Axis 1 single-axis movement
    100.0e  mm/min  1  interpolator-v! \ Set Axis 1 single-axis motion velocity to 100.0 mm/min
    0.3e  1  axis-cmd-p!               \ Set the target position of Axis 1 to the coordinate position of 0.3 m.
    1 axis-demand-p@                   \ Get the current command position on Axis 1.
    1 axis-real-p@                     \ Axis 1 is the actual position of Axis 1.

#### Command Reference

| Command | Stack effect                         | Explanation |
|-----|---------------------------------|-----|
| +interpolator         | ( j -- )            | Starting the single-axis movement
| -interpolator         | ( j -- )            | Turn off the single-axis movement
| interpolator?         | ( j -- flag )       | Is the single-axis movement open?
| interpolator-reached? | ( j -- flag )       | Did the single-axis movement reach the target point?
| interpolator-v!       | ( j -- ) (F: v -- ) | Set the velocity of a single axis.

---
### Pitch Corrector

#### `+pcorr ( channel slave -- )`

Activate the Pitch Corrector for the specified drive

#### `-pcorr ( channel slave -- )`

Turn off the specified drive pitch corrector

#### `>pcorr ( channel slave -- )`

The Pitch Corrector reading the specified drive will cause real-time cycle overrun to be used in safe situations, such as Servo off.

#### `.pcorr ( channel slave -- )`

Output Currently viewed by Pitch Corrector

example command:

    1 1 .pcorr

return message

    pcorr_name.1.1|P0001-01.sdx
    |pcorr_len.1.1|10
    |pcorr_position.1.1|0.0000000
    |pcorr_forward.1.1|0.0000000
    |pcorr_backward.1.1|0.0000000
    |pcorr_corrected_position.1.1|0.0000000
    |pcorr_backlash.1.1|0.0000000
    |pcorr_direction.1.1|1
    |pcorr_factor.1.1|0.0020000
    |pcorr_enabled.1.1|0

#### Command Reference

| Command | Stack effect                       | Explanation |
|-----|------------------------------|------|
| .pcorr |( channel n -- )                                                  | Output Currently viewed by Pitch Corrector
| .pcorr-entry  |( index channel n -- )                                     | output Specify the contents of the correction table
| +pcorr        |( channel n -- )                                           | Starting up the corrective function
| -pcorr        |( channel n -- )                                           | Shutting down corrective functions
| >pcorr        |( channel n -- )                                           | Read files to the controller
| pcorr>        |( channel n -- )                                           | output to the file
| pcorr-entry!  |( index channel n -- ) ( F: position forward backward -- ) | Set up correctional positions
| pcorr-factor! |( channel n -- ) ( F: factor -- )                          | Set the conversion coefficient of the correction table position
| pcorr-resize  |( len channel n -- )                                       | Adjusting the position size of the correction table
