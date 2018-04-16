# Real-time Script API

Botnana Control 在其 real-time event loop 中使用了 Forth VM 以滿足更複雜的程式需求。透過 Forth 執行的命令會立刻影響裝置的行為。一般使用者並不需要使用此一 API。

## 指令集

除了標準的 Forth 指令，Botnana Control 增加了以下 Forth 指令集。

### Host primitives

* `#dins ( -- n )` Digital input count
* `#douts ( -- n )` Digital output count
* `dout@ ( n -- t=on )` Read digital output
* `dout! ( t=on n -- )` Write digital output
* `din@ ( n -- t=on )` Read digital input
* `time-msec ( -- n )` Current time in milliseconds

### EtherCAT queries

* `.slave ( n -- )` Print information of slave n
* `.slave-diff ( n -- )` Print information difference of slave n
* `list-slaves ( -- )` Scan slaves

### EtherCAT IO primitives

* `ec-dout@ ( channel n -- t=on )` Get DOUT from EtherCAT slave n
* `ec-dout! ( t=on channel n -- )` Set DOUT of EtherCAT slave n
* `ec-din@ ( channel n -- t=on )` Get DIN from EtherCAT slave n
* `-ec-aout ( channel n )` Disable AOUT of EtherCAT slave n
* `+ec-aout ( channel n )` Enable AOUT of EtherCAT slave n
* `ec-aout@ ( channel n -- value )` Get AOUT from EtherCAT slave n
* `ec-aout! ( value channel n -- )` Set AOUT of EtherCAT slave n
* `-ec-ain ( channel n )` Disable AIN of EtherCAT slave n
* `+ec-ain ( channel n )` Enable AIN of EtherCAT slave n
* `ec-ain@ ( channel n -- value )` Get AIN from EtherCAT slave n

### EtherCAT Drive primitives

* `op-mode! ( mode n -- )` Set operation mode of slave n
* `pds-goal! ( goal n -- )` Set PDS goal of slave n
* `reset-fault ( n -- )` Reset fault for slave n
* `go ( n -- )` Set point for slave n
* `target-p! ( p n -- )` Set target position of slave n
* `target-v! ( v n -- )` Set target velocity of slave n
* `target-reached? ( n -- t=reached )` Has slave n reached its target position?
* `home-offset! ( offset n -- )` Set home offset of slave n
* `homing-a! ( acceleration n -- )` Set homing acceleration of slave n
* `homing-method! ( method n -- )` Set homing method of slave n
* `homing-v1! ( speed n -- )` Set homing speed 1 of slave n
* `homing-v2! ( speed n -- )` Set homing speed 2 of slave n
* `profile-a1! ( acceleration n -- )` Set profile acceleration of slave n
* `profile-a2! ( deceleration n -- )` Set profile deceleration of slave n
* `profile-v! ( velocity n -- )` Set profile velocity of slave n

### Sine Wave Trajectory

* `sine-start (n --)` Start sine wave trajectory of slave n
* `sine-stop (n --)` Stop sine wave trajectory of slave n
* `sine-ems (n --)` Emergency stop sine wave trajectory of slave n
* `sine-forth (n --)` Sine Wave trajectory forth of slave n
* `sine-p@ (n --)(F: -- p)` Get sine wave trajectory position of slave n
* `sine-v@ (n --)(F: -- v)` Get sine wave trajectory velocity of slave n
* `sine-running? (n -- running)` Is sine wave trajectory running of slave n
* `sine-cfg! (n -- )(F: freq start-pos amplitude)` Set sine wave trajectory parameters of slave n
* `sine-f! (n -- )(F: freq)` Change running frequency of sine wave trajectory of slave n
* `sine-amp! (n -- )(F: amplitude)` Change running amplitude of sine wave trajectory of slave n


### Start, Stop and Reset

* `start (--)` start 
* `stop (--)` stop
* `ems (--)` emergency stop
* `reset-job (--)` reset job

##### Configuration

**For System**

* `.motion (--)`  Print information of motion. Example of return message: `period_us|2000|group_capacity|7|joint_capacity|10` 

**For Group**

* `gvmax! (g --) (F: v)` Set vmax of group (g).
* `gamax! (g --) (F: a)` Set amax of group (g).
* `gjmax! (g --) (F: j)` Set jmax of group (g).
* `map1d (x g --)` Set axis mapping (x) of group (g). The group shall be Group1D.   
* `map2d (x y g --)` Set axis mapping (x, y) of group (g). The group shall be Group2D.
* `map3d (x y z g --)` Set axis mapping (x, y, z) of group (g). The group shall be Group3D.
* `.grpcfg (g --)`  Print information of group g. Example of `1 .grpcfg`, return message : `group_name.1|BotnanaGo|group_type.1|1D|group_mapping.1|1|group_vmax.1|0.100|group_amax.1|5.000|group_jmax.1|80.000`  

**For Axis**

* `enc-ppu! (j --) (F: ppu --)` Set encoder ppu (pulses_per_unit) of axis j.
* `enc-u! (u j --) ` Set encoder length unit of axis j. `u = 0 as Meter, u = 1 as Revolution, u = 2 as Pulse`
* `enc-dir! (dir j --) ` Set encoder direction of axis j.
* `hmofs! (j --) (F: ofs --)` Set home offset of axis j.
* `.axiscfg (j --)`  Print information of axis j. Example of `1 .axiscfg`, return message : `axis_name.1|X|home_offset.1|0.0500|encoder_ppu.1|120000.00000|encoder_length_unit.1|Meter|encoder_direction.1|-1`
`.    

#### Path Planning Commands for All Dimensions

* `group! ( n -- )` Select group `n`, `n` start by 1.
* `group@ ( n -- )` Get current group index `n`.
* `0path` ( -- ) Clear path.
* `feedrate! ( F: v -- )` Set programmed segment feedrate. `v` > 0.
* `feedrate@ ( F: -- v )` Get programmed segment feedrate. 
* `+coordinator (--)` Enable coordinator.
* `-coordinator (--)` Disable coordinator.
* `+group (--)` Enable current group.
* `-group (--)` Disable current group.
* `vcmd! ( F: v -- )` Set execution velocity command.`v` can be negataive.
* `gend? (-- flag )` Has path of current group ended ?
* `gstop? (-- flag )` Has path of current group stopped ?
* `empty? (-- flag)` Is path of current group empty?
* `end? (-- flag)` Has path of all groups of coordinator ended ?
* `stop? (-- flag)` Has path of all groups of coordinator stopped ?

#### 1D Path Planning

Current axis group should be 1D for the following commands to work without failure.

* `move1d (F: x -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line1d (F: x -- )` Add a line to `x` into path.

#### 2D Path Planning

Current joint group should be 2D for the following commands to work without failure.

* `move2d (F: x y -- )` Declare the current absolute coordinate to be `(x, y)`. (G92)
* `line2d (F: x y -- )` Add a line to `(x, y)` into path.
* `arc2d ( n --)(F: cx cy x y -- )` Add an arc to `(x, y)` with center `(cx, cy)` into path.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 3D Path Planning

Current joint group should be 3D for the following commands to work without failure.

* `move3d (F: x y z -- )` Declare the current absolute coordinate to be `(x, y, z)`. (G92)
* `line3d (F: x y z -- )` Add a line to `(x, y, z)` into path.
* `helix3d ( n --)(F: cx cy x y z -- )` Add a helix to `(x, y, z)` with center `(cx, cy)` into path. If z is the current z, the added curve is an arc.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 4D Path Planning (TODO)

Current joint group should be 4D for the following commands to work without failure.

* `move4d (F: x y z c -- )` Declare the current absolute coordinate to be `x, y, z, c`. (G92)
* `line4d (F: x y z c -- )` Add a line to `(x, y, z, c)` into path.

#### 5D Path Planning (TODO)

Current joint group should be 5D for the following commands to work without failure.

* `move5d (F: x y z a b -- )` Declare the current absolute coordinate to be `x, y, z, a, b`. (G92)
* `line5d (F: x y z a b -- )` Add a line to `(x, y, z, a, b)` into path.

#### 6D Path Planning (TODO)

Current joint group should be 6D for the following commands to work without failure.

* `move6d (F: x y z a b c -- )` Declare the current absolute coordinate to be `x, y, z, a, b, c`. (G92)
* `line6d (F: x y z a b c -- )` Add a line to `(x, y, z, a, b, c)` into path.


#### Information

* `.group (g --)` Print information of group g. Example of `1 .group`, return message : `group_enabled.1|false|group_stopping.1|true|move_count.1|0|path_event_count.1|0|focus.1|0|source.1|0|pva.1|0.00000,0.00000,0.00000|move_length.1|0.00000|total_length.1|0.00000|feedrate.1|0.000|vcmd.1|0.000|max_look_ahead_count.1|0|ACS.1|0.00000|PCS.1|0.00000`
* `.axis (j --)` Print information of axis j. Example of `1 .axis`, return message : `axis_command_position.1|0.00000|axis_corrected_position.1|0.00000|encdoer_position.1|-0.05000|following_error.1|0.00000`

### CPU Timing

* `.cpu-timing ( -- )` Print information of CPU timing
* `0cpu-timing ( -- )` Reset CPU timing

### Internal testing primitives

* `tester-chkusb ( -- )` Test USB memory stick
* `tester-chkusd ( -- )` Test microSD
* `-tester ( -- )` Disable all tester outputs
* `+tester ( -- )` Enable all tester outputs
* `tester-high ( -- )` Set all tester outputs to high
* `tester-low ( -- )` Set all tester outputs to 0V

### misc

* `.verbose ( -- )` Print verbose infornatiom

