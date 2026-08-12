### EtherCAT I/O Command Set

EtherCAT IO consists of the following parts:

1. EtherCAT DIN/DOUT/AIN/AOUT module. A single or integrated signal module.
2. EtherCAT PWM module. Currently only supports BECKHOFF EL2502 module. Because the module can control PWM Period and Duty Cycle using the synchronous command (PDO), the SDO upload/download command can be used if the non-synchronous command (SDO) is controlled.

#### `+ec-ain ( ch n -- )`

Open Analog Input channel `ch` on EtherCAT slave `n`.

When using an analog input slave, enable the analog input channel to read the measurements, which can be done with this command.

example command:

    1 6 +ec-ain  \ Enable analog input channel 1 on EtherCAT slave 6.

#### `+ec-aout ( ch n -- )`

Open EtherCAT slave `n` channel `ch` analog output.

When using an analog output slave, enable the analog output channel to output signals, and use this command.

example command:

    1 2 +ec-aout  \ Enable Analog Output Channel 1 on EtherCAT Slave 2.

#### `+pwm-user-scale ( ch n -- )`

Open EtherCAT slave `n` with Mapacode PWM custom Duty Cycle command for channel `ch`.

#### `-ec-ain ( ch n -- )`

CLOSE the analog input on EtherCAT slave `n`, channel `ch`.

example command:

    1 6 -ec-ain off, channel 1 of analog input on EtherCAT slave 6.

#### `-ec-aout ( ch n -- )`

shutdown analog output channel `ch` of EtherCAT slave `n`

example command:

    1 2 -ec-aout  \ Turn off the analog output of EtherCAT slave number 2, channel 1.

#### `-pwm-user-scale ( ch n -- )`

CLOSE PWM Custom Duty Cycle Command for EtherCAT Slave `n`, Channel `ch`.

#### `ec-ain@ ( ch n -- value )`

Get the analog input from EtherCAT slave `n`, channel `ch`.

example command:

    1 6 ec-ain@ \ Obtain EtherCAT slave number 6's analog input on channel 1

#### `ec-ain-error  ( ch n -- error )`

Obtain the analog input error on channel `ch` of EtherCAT slave `n`, for axis group.

The BECKHOFF AI module provides this state, with two types of error:

* Over range
* Under range

#### `ec-ain-validity  ( ch n -- validity )`

Get whether the analog input on EtherCAT slave `n`, channel `ch` is valid.

The Beckhoff analog-input module provides this status to indicate whether the master read the channel data correctly using an EtherCAT PDO.
Originally published `0 = valid, 1 = invalid`In order to avoid literal confusion, reverse operations are carried out when the data is obtained.

#### `ec-aout! ( value ch n -- )`

Set the analog output on channel `ch` of EtherCAT slave `n` to `value`.

example command:

    100 1 2 ec-aout!  \ Set EtherCAT slave number 2, analog output of channel 1 to 100

#### `ec-aout@ ( ch n -- value )`

Get the analog output value `value` on channel `ch` of EtherCAT slave `n`.

    1 2 ec-aout@  \ EtherCAT slave number 2, analog output of channel 1

#### `ec-din@ ( ch n -- t )`

Get digital input signal `t` on channel `ch` of EtherCAT slave `n`.

example command:

    3 5 ec-din@  \ Get the digital input signal from the third channel of the EtherCAT slave number 5

#### `ec-dout! ( t channel n -- )`

Set EtherCAT slave number `n`, digital output signal on channel `ch` to `t`.

example command:

    1 2 3 ec-dout!  \ Set the EtherCAT slave number 3, the digital output signal in the second channel is 1.

#### `ec-dout@ ( ch n -- t )`

Get the digital output signal `t` on channel `ch` of EtherCAT slave `n`, for axis group.

example command:

    2 3 ec-dout@  \ Get the digital output signal from the second channel of EtherCAT slave number 3

#### `ec-wdout!  ( value index n -- )`

It's a 32-bit command file. `value` With a number `index` Set the EtherCAT slave number. `n` The digital output signals.

example command:

    $11 1 2 ec-wdout!  \ Set the digital output of EtherCAT slave numbers 2, 1 and 5.
    1   2 2 ec-wdout!  \ Set the digital output of EtherCAT slave number 2, channel 33.

#### `max-pwm-period@  ( n -- period )`

Get EtherCAT slave number `n`, and the maximum period time `period` [us] supported by the PWM module.

#### `min-pwm-period@  ( n -- period )`

Get EtherCAT slave number `n`, and the minimum period time `period` [us] supported by the PWM module.

#### `pwm-def-out!  ( output ch n -- )`

Set EtherCAT slave number `n`, PWM signal on channel `ch` with a default Duty Cycle value `output` in case of communication errors.

#### `pwm-def-out-ramp!  ( ramp ch n -- )`

Set EtherCAT slave number `n`, PWM signal on channel `ch` during ramp-down rate `ramp` for Duty Cycle when communication error occurs.

### `pwm-duty!  ( duty ch n -- period )`

Set EtherCAT slave number `n`, PWM signal on channel `ch` with Duty Cycle `duty`. Duty Cycle physical values can be referenced with the `pwm-presentation!` command.

#### `pwm-duty@  ( ch n -- duty )`

Get the PWM signal Duty Cycle `duty` for channel `ch` of EtherCAT slave `n`.

#### `pwm-period!  ( period ch n -- period )`

Set EtherCAT slave number `n`, PWM signal period `period` [us] on channel `ch`.

#### `pwm-period@  ( ch n -- period )`

Get EtherCAT slave ID `n`, PWM signal period `period` [us] for channel `ch`.

#### `pwm-presentation!  ( presentation ch n -- )`

Set EtherCAT slave number `n`, PWM signal Duty Cycle resolution `presentation` for channel `ch`.

The BECKHOFF EL2502 model can be set to:

| Presentation | Duty Setting Explanation |
|-------|-----|
| 0 (Signed presentation) | Effective value 0 ~ 0x7FFF, 0x3FFF is 50 % Duty|
| 1 (Unsigned presentation) | Effective value 0 ~ 0xFFFF, 0x7FFF is 50% Duty |
| 2 (Absolute value with MSB as sign) | 3276 represents 10% duty and -3276 represents 90% duty. |
| 3 (Absolute valuen) | 3276 represents 10% duty, and -3276 represents 10% duty. |

#### `pwm-wdt!  ( wdt ch n -- )`

Set EtherCAT slave number `n`, PWM signal on channel `ch`, output signal mode `wdt` when communication error occurs.

The BECKHOFF EL2502 model can be set to:

* 0: Default watchdog value
* 1: Watchdog ramp active
* 2: Last output value active

#### `pwm-user-gain!  ( gain ch n -- )`

Set EtherCAT slave number `n`, PWM signal gain `gain` for channel `ch` of Mapacode command to define the duty cycle.

Refer to the description for Object 0x8000:0x01 in the BECKHOFF EL2502 file.

#### `pwm-user-offset!  ( offset ch n -- )`

Set EtherCAT slave number `n`, PWM signal offset `offset` for channel `ch` of the Mapacode command to command a custom Duty Cycle.

#### Command Reference

| Command | Stack effect | Explanation |
|-----|---------|-----|
| +ec-ain           | ( ch n -- )               | Activate the AIN feature
| +ec-aout          | ( ch n -- )               | Activate the AOUT feature
| +pwm-user-scale   | ( ch n -- )               | Activate the PWM Custom Duty Cycle command feature
| -ec-ain           | ( ch n -- )               | Turn off the AIN feature
| -ec-aout          | ( ch n -- )               | Turn off the AOUT feature
| -pwm-user-scale   | ( ch n -- )               | Turn off the PWM Custom Duty Cycle command feature
| ec-ain@           | ( ch n -- value )         | Get the AIN measurement
| ec-ain-error      | ( ch n -- error )         | Whether the AIN measurement was incorrect
| ec-ain-validity   | ( ch n -- validity )      | Whether the AIN measurement is effective
| ec-aout!          | ( value ch n -- )         | Set the AOUT
| ec-aout@          | ( ch n -- value )         | Get the AOUT
| ec-din@           | ( ch n -- t )             | Receiving a DIN
| ec-dout!          | ( t ch n -- )             | Set the DOUT
| ec-dout@          | ( ch n -- t )             | Get the DOUT
| ec-wdout!         | ( value index n -- )      | Set the DOUTs
| max-pwm-period@   | ( n -- period )           | Maximum cycle time for obtaining PWM module support
| min-pwm-period@   | ( n -- period )           | Minimum cycle time for obtaining PWM module support
| pwm-def-out!      | ( output ch n -- )        | PWM Duty Cycle is defaulted when communication is incorrect
| pwm-def-out-ramp! | ( ramp ch n -- )          | The PWM Duty Cycle slope decreases when communication is incorrect
| pwm-duty!         | ( duty ch n -- )          | Set the PWM Duty Cycle
| pwm-duty@         | ( ch n -- duty )          | PWM Duty Cycle
| pwm-period!       | ( period ch n -- )        | Set the PWM Period
| pwm-period@       | ( ch n -- period )        | The PWM Period
| pwm-presentation! | ( presentation ch n -- )  | Set the PWM Duty Cycle resolution
| pwm-wdt!          | ( wdt ch n -- )           | PWM output mode when communication is wrong
| pwm-user-gain!    | ( gain ch n - )           | PWM Customized Duty Cycle Order Increase
| pwm-user-offset!  | ( offset ch n -- )        | PWM Customized Duty Cycle Command Deviations
