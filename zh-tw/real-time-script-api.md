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
* `jog ( position n -- )` Jog slave n to position
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

* `start-sine-trj (n --)` Start sine wave trajectory of slave n
* `stop-sine-trj (n --)` Stop sine wave trajectory of slave n
* `ems-sine-trj (n --)` Emergency stop sine wave trajectory of slave n
* `sine-trj-forth (n --)` Sine Wave trajectory forth of slave n
* `sine-trj-p@ (n --)(F: -- p)` Get sine wave trajectory position of slave n
* `sine-trj-v@ (n --)(F: -- v)` Get sine wave trajectory velocity of slave n
* `sine-trj-running? (n -- running)` Is sine wave trajectory running of slave n
* `sine-trj! (n -- )(F: freq start-pos amplitude)` Set sine wave trajectory parameters of slave n
* `sine-trj-f! (n -- )(F: freq)` Change running frequency of sine wave trajectory of slave n
* `sine-trj-amp! (n -- )(F: amplitude)` Change running amplitude of sine wave trajectory of slave n


### Manager

* `start (--)` start 
* `stop (--)` stop
* `ems (--)` emergency stop
* `reset-job (--)` reset job


### Joint Groups and Trajectory Planners

For all joint groups and trajectory planners:


* `end? (-- flag) ` all groups at end?
* `stop? (-- flag) ` all groups stopped?


##### Configuration

可能不需要 Forth 指令，用 config 檔處理。Config 檔還可以指定軸的英文名。

**For System**

* `.feature (--)`  Print information of joint system (capacity, group name, group type and joint name). example of `.feature`: `gnames|Main,Orbit|gtypes|1D,2D|jnames|X,Y,Z`. (只有初始化時會設定motion，之後不可變動 motion 的配置，但可以修改設定檔下次啟動生效)

**For Group**

* `gvmax! (g --) (F: v)` Set vmax of group.
* `gamax! (g --) (F: a)` Set vmax of group.
* `gjmax! (g --) (F: j)` Set vmax of group.
* `map1d (x g --)` Set joint mapping (x) of group (g). the group shall be Group1D.   
* `map2d (x y g --)` Set joint mapping (x, y) of group (g). the group shall be Group2D.
* `map3d (x y z g --)` Set joint mapping (x, y, z) of group (g). the group shall be Group3D.
* `.gconfig (g --)`  Print information of group g. Example of `1 .gconfig` : `gmap.1|1|vmax.1|0.100|amax.1|5.000|jmax.1|80.000`.   Example of `2 .gconfig` : `gmap.2|2,3|vmax.2|0.100|amax.2|5.000|jmax.2|80.000`.  

**For Joint**

* `enc-scale! (j --) (F: scale --)` Set encoder scale (pulses_for_unit) of joint j.
* `enc-dir! (dir j --) ` Set encoder polarity of joint j.
* `homofs! (j --) (F: ofs --)` Set home offset of joint j.
* `.jconfig (j --)`  Print information of joint j. Example of `1 .jconfig` : `enc-scale.1|1000000.00000|enc-polarity.1|1|jhmofs.1|-0.1000`
`.    


#### Path Planning Commands for All Dimensions

* `group! ( n -- )` Select group `n`, `n` start by 1.
* `group@ ( n -- )` Get current group index `n`.
* `0path` ( -- ) Clear path.
* `feedrate! ( F: v -- )` Set programmed segment feedrate. `v` > 0.
* `feedrate@ ( F: -- v )` Get programmed segment feedrate. 


#### 1D Path Planning

Current joint group should be a 1D for the following commands to work without failure.

* `move1d (F: x -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line1d (F: x -- )` Add a line to `x` into path.

#### 2D Path Planning

Current joint group should be 2D for the following commands to work without failure.

* `move2d (F: x y -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line2d (F: x y -- )` Add a line to `(x, y)` into path.
* `arc2d ( n --)(F: cx cy x y -- )` Add an arc to `(x, y)` with center `(cx, cy)` into path.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 3D Path Planning

Current joint group should be 3D for the following commands to work without failure.

* `move3d (F: x y z -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line3d (F: x y z -- )` Add a line to `(x, y, z)` into path.
* `helix3d ( n --)(F: cx cy x y z -- )` Add a helix to `(x, y, z)` with center `(cx, cy)` into path. If z is the current z, the added curve is an arc.
  Argument `n` should not be zero. For counterclockwise arc `n>0` and `n-1` is the _winding number_ with respect to center. For clockwise arc `n<0` and `n+1` is the _winding number_ with respect to center.

#### 4D Path Planning (TODO)

Current joint group should be 4D for the following commands to work without failure.

* `move4d (F: x y z c -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line4d (F: x y z c -- )` Add a line to `(x, y, z, c)` into path.

#### 5D Path Planning (TODO)

Current joint group should be 5D for the following commands to work without failure.

* `move5d (F: x y z a b -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line5d (F: x y z a b -- )` Add a line to `(x, y, z, a, b)` into path.

#### 6D Path Planning (TODO)

Current joint group should be 6D for the following commands to work without failure.

* `move6d (F: x y z a b c -- )` Declare the current absolute coordinate to be `x`. (G92)
* `line6d (F: x y z a b c -- )` Add a line to `(x, y, z, a, b, c)` into path.

#### Path Execution

* `+coordinated (--)` Enable coordinated joint groups.
* `-coordinated (--)` Disable coordinated joint groups.
* `+group (--)` Activate current group.
* `-group (--)` Inactive current group.
* `vcmd! ( F: v -- )` Set execution velocity command.`v` can be negataive.
* `gend? (-- flag )` At end of path of current group ?
* `gstop? (-- flag )` Is stopped of path of current group ?
* `empty? (-- flag)` Is path empty of current group ?
* `end? (-- flag)` At end of all groups of joint system ?
* `stop? (-- flag)` Are stopped of all groups of joint system ?

#### Information

* `.group (g --)` Print information of group g 
* `.joint (j --)` Print information of joint j 

### CPU Timing

* `.cpu-timing ( -- )` Print information of CPU timing
* `0cpu-timing ( -- )` Reset CPU timing

### Internal testing primitives

* `tester-chkusb ( -- )` Test USB memory stick
* `tester-chkusd ( -- )` Test microSD
* `-tester ( -- )` Disable all tester outputs
* `+tester ( -- )` Enable all tester outputs,
* `tester-high ( -- )` Set all tester outputs to high
* `tester-low ( -- )` Set all tester outputs to 0V

### misc

* `.verbose ( -- )` Print verbose infornatiom

