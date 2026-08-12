### EtherCAT Command Set

#### `.ec-dc ( -- )`

Display EtherCAT communication time-synchronization status.

example command:

    .dc-dc

return message:

    dc_adjust_ns|65|dc_diff_ns|-865935|reference_time_diff_ns|2003080
    |application_time_diff_ns|2052185

These include:

    dc_adjust_ns: The number of adjustments to the EtherCAT main station cycle.
    dc_diff_ns: EtherCAT is the time difference between the master slaves.
    reference_time_diff_ns: cycle of the EtherCAT slave.
    application_time_diff_ns: Cycle of the EtherCAT main station.

#### `.ec-emcy ( n -- )`

Display the emergency message for EtherCAT Slave Position `n`. Botnana Control currently sends `?ec-emcy` automatically when the Status Word fault bit is set.

example command:

    1 .ec-emcy  \ Get the emergency message from the first EtherCAT slave

return message:

    error_code.1|0x5441
    |error_register.1|0x20
    |error_data.1.1|0
    |error_data.2.1|19
    |error_data.3.1|0
    |error_data.4.1|0
    |error_data.5.1|0
    |error_message_cout|1

These include:

    Error code: is equal to Object 0x603F:00
    Error register: is equal to Object 0x1001: 00
    error_data.1 ~ error_Data.5: Discrete alerts defined by the drive manufacturer.
                                    This example is a message returned by a Delta A2-E drive.
                                    error_Data.2.1 = 19 indicates the counterclockwise code 0x13. (Emergency Stop)

#### `.ec-links ( -- )`

Displays the connection status of EtherCAT communications

example command:

    .ec-links

return message:

    slaves_responding|3|al_states|8|link_up|1
    |input_wc|3|output_wc|3|input_wc_state|1|output_wc_state|1
    |input_wc_error|8187|output_wc_error|8233
    |waiting_sdos_len|0|ec_ready|1

These include:

    slaves_Answering: The number of EtherCAT slaves
    al_states: The state of all EtherCAT slaves.
    input_wc: Input Data Working Count. There are slave numbers that process Input Data.
    output_wc: Output Data Working Count. There are slave numbers that process Output Data.
    input_wc_state: Input Data Working Count is correct or not, 1 is normal.
    output_wc_State: Output Data Working Count is correct or not, 1 is normal.
    input_wc_error: counting input_wc_The number of cycles of state = 0.
                        Usually, the time cannot be synchronized at the start, so it increases at the start.
    output_wc_error: count output_wc_The number of cycles of state = 0.
                        Usually, the time cannot be synchronized at the start, so it increases at the start.
    waiting_sdos_len: The number of SDO commands waiting to be processed.
    ec_Ready: 1 indicates that EtherCAT communication is normal.

#### `.ec-wdt-proc-data ( n -- )`

Display the ESC Watchdog Time Process Data register value for EtherCAT Slave Position `n`.

example command:

    1 .ec-wdt-proc-data

return message:

    ec_wdt_proc_data.1|1000|ec_wdt_proc_data_busy.1|0|ec_wdt_proc_data_error.1|0

These include:

    ec_wdt_proc_Data: Register setting of the ESC Watchdog Time Process Data
    ec_wdt_proc_data_busy: Are the instructions requested to set or read still being executed?
    ec_wdt_proc_data_error: Did the instruction requested to set or read fail to execute?

#### `.sdo ( n -- )`

Display the result of the SDO command for EtherCAT Slave Position `n`.

example command:

    2 .sdo

The return message:

    sdo_index.2|0x6041
    |sdo_subindex.2|0x00
    |sdo_error.2|false
    |sdo_busy.2|false
    |sdo_data.2|24
    |sdo_data_hex.2|0x0018

These include:

    by sdo_index.2 For example, .2 represents the second slave.
    sdo_index   : EtherCAT object index.
    sdo_subindex: EtherCAT object subindex.
    sdo_error: Is there a problem with the sdo request?
                  This could be due to index errors, data type errors, etc.
    sdo_busy: Is this SDO request still being processed?
    sdo_Data: The value of the object.
    sdo_data_Hex: The value of the object is represented by 16 digits.

#### `.slave ( n -- )`

Display information for EtherCAT Slave Position `n`.

example command:

    2 .slave

In this example, the second slave is a Shihlin Electric SDP drive.

The return message:

    vendor.2|0x000005BC
    |product.2|0x00000001
    |description.2|SDP-E CoE Drive
    |alias.2|0
    |device_type.2|0x00020192
    |profile_deceleration.1.2|50000
    |profile_acceleration.1.2|50000
    |profile_velocity.1.2|1000000
    |operation_mode.1.2|6
    |home_offset.1.2|0
    |homing_method.1.2|33
    |homing_speed_1.1.2|1000
    |homing_speed_2.1.2|250
    |homing_acceleration.1.2|500
    |supported_drive_mode.1.2|0x000003ED
    |control_word.1.2|0x0000
    |target_position.1.2|2641624
    |target_velocity.1.2|0
    |status_word.1.2|0x0050
    |real_position.1.2|2641624
    |digital_inputs.1.2|0x00000000
    |pds_state.1.2|Switch On Disabled
    |pds_goal.1.2|Switch On Disabled

The fields are described below:

    vendor.2 indicates the vendor id of the second slave
    Product 2 represents the product code of the second slave
    Description 2 indicates the description of the second slave
    device_Type 2 represents the device type of the second slave, 0x00020192.
    profile_deceleration.1.2 represents the profile deceleration of the first drive on the second slave. [pulse/s^2],
    profile_acceleration.1.2 shows the profile acceleration of the first drive on the second slave. [pulse/s^2],
    profile_velocity.1.2 shows the profile velocity of the first drive on the second slave. [pulse/s],
    operation_Mode.1.2 represents the operation mode of the first drive on the second slave, and currently supports the following mode:
        1: profile position mode
        3: profile velocity mode
        6: homing mode
        8: cycle sync. position mode
    homing_method.1.2 indicates the homing method of the first drive on the second slave.
        1 : homing on negative limit and index pulse
        2 : homing on positive limit and index pulse
        3, 4 : homing on positive home switch and index pulse
        5, 6 : homing on negative home switch and index pulse
        33: homing on negative index pulse
        34: homing on positive index pulse
        35: homing on the current position
        Other: Reference to drive 0x6098::0x00
    homing_speed_1.1.2 indicates the speed for search switch on the first drive on the second slave [pulse/s]
    homing_speed_2.1.2 indicates the speed for search zero of the first drive on the second slave. [pulse/s]
    homing_Acceleration is the homing acceleration of the first drive on the second slave. [pulse/s^2]
    supported_drive_mode.1.2 represents the supported drive mode of the first drive on the second slave, defined as follows:
        Bit 0 : profile posiiton mode
        Bit 2 : profile velocity mode
        Bit 5 : homing  mode
        Bit 7 : cycle sync. position mode
        Other: Reference to drive 0x6502::0x00
    control_word.1.2 represents the control word of the first drive on the second slave, defined as follows:
        Bit 0 : switch on
        Bit 1 : enable voltage
        Bit 2 : quick stop
        Bit 3 : enable operation
        Bit 4~6 : operation mode specification
        Bit 7 : fault Reset
        Bit 8 : halt
        Other: Reference to drive 0x6040::0x00
    target_Position.1.2 represents the target position of the first drive on the second slave. [pulse]
    target_velocity.1.2 represents the target velocity of the first drive on the second slave. [pulse/s]
    status_word.1.2 represents the status word of the first drive on the second slave and is defined as follows:
        Bit 0 : ready to switch on
        Bit 1 : switch on
        Bit 2 : operation enabled (servo on)
        Bit 3 : fault
        Bit 4 : voltage enabled
        Bit 5 : quick stop
        Bit 6 : switch on disabled
        Bit 7 : warning
        Bit 10 : target reached
        Other: References to drive 0x6041::0x00
    real_position.1.2 represents the real position of the first drive on the second slave. [pulse]
    digital_inputs.1.2 represents the digital inputs of the first drive on the second slave, defined as follows:
        Bit 0 : negative limit
        Bit 1 : positive limit
        Bit 2 : home switch
        Other: Reference to drive 0x60FD::0x00

    Note: Units will vary depending on the drive

Digital output return information example, with the EC7062 of Taipei:

    vendor.3|Delta|product.3|EC7062|dout.1.3|0|dout.2.3|0|dout.3.3|0|
    dout.4.3|0|dout.5.3|0|dout.6.3|0|dout.7.3|0|dout.8.3|0|dout.9.3|0|
    dout.10.3|0|dout.11.3|0|dout.12.3|0|dout.13.3|0|dout.14.3|0|
    dout.15.3|0|dout.16.3|0

    The dout.11.3 represents the 11th digital output of the third Slave.

For example, take the EC6022 for example:

    vendor.7|Delta|product.7|EC6022|din.1.7|0|din.2.7|0|din.3.7|0|
    din.4.7|0|din.5.7|0|din.6.7|0|din.7.7|0|din.8.7|0|din.9.7|0|
    din.10.7|0|din.11.7|0|din.12.7|0|din.13.7|0|din.14.7|0|din.15.7|0|
    din.16.7|0

    Din.15.7 represents the 15th digital input of the 7th Slave.

Analog output return data for example, using the example of the EC9144 from Taiwan:

    vendor.5|Delta|product.5|EC9144|aout.1.5|0|aout.2.5|0|
    aout.3.5|0|aout.4.5|0

Analog input return for example, with the EC8124 from Taiwan:

    vendor.4|Delta|product.4|EC8124|ain.1.4|0|ain.2.4|0|
    ain.3.4|0|ain.4.4|0

#### `.slave-diff ( n -- )`

Display information for EtherCAT Slave Position `n`, returning only values that differ from the previous request.

Use `.slave` to retrieve all parameters. Use `.slave-diff` to retrieve state that has changed since the last `.slave` or `.slave-diff` command. If no state has changed, the returned data is an empty string.

Command example:

    2 .slave-diff

#### `?ec-emcy ( n -- )`

Request an emergency message from a drive after an alarm occurs.

#### `@ec-wdt-proc-data ( n -- ) `

Request the ESC Watchdog Time Process Data register value from EtherCAT slave `n`. The result is asynchronous; use `ec-wdt-proc-data-busy?` to determine when it has returned.

#### `ec-a>n ( alias -- n )`

Find Slave Position `n` for EtherCAT slave alias `alias`.

Note:

1. `alias` cannot be zero.
2. An error is returned if `alias` does not exist.

#### `ec-ain? ( ch n -- t )`

Return whether channel `ch` of EtherCAT Slave Position `n` is an analog input.

#### `ec-alias! ( alias n -- )`

Set alias `alias` for EtherCAT Slave Position `n`.

Note:

1. `alias` It is not repeatable except for 0.
2. This setup command is the register that modifies the SII EEPROM correspondence. If it is controlled by a hard drive, it does not need to be set by this command.
3. No duplicate alias.
4. This command will cause a Real Time Cycle Overrun to be executed in all drive Servo OFF situations.

#### `ec-alias? ( alias -- t )`

EtherCAT slave alias `alias` Does it exist?

#### `ec-aout? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` Is it for analog output?

#### `ec-din? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` Is it for digital input?

#### `ec-dout? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` Is it for digital output?

#### `ec-drive? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` Is it a motor drive?

#### `ec-emcy-busy? ( n -- t )`

Is the `?ec-emcy` for EtherCAT slave position `n` waiting for an ongoing execution?

#### `ec-encoder? ( ch n -- t )`

EtherCAT slave position `n` Channel `ch` Is it a module for encoder input?

#### `ec-gateway? ( ch n -- t )`

Return whether channel `ch` of EtherCAT Slave Position `n` is a gateway module.

#### `ec-load ( n -- )`

Restore the factory-default settings for EtherCAT Slave Position `n`. This is equivalent to setting Object 0x1011:1 to 0x64616F6C (ASCII: l:0x6C, o:0x6F, a:61, d:64).

If the EtherCAT slave provides a return to the original factory default function, most will use this method.

#### `ec-ready? ( -- t )`

Is EtherCAT communication ready or normal?

#### `ec-save ( n -- )`

Store the current settings for EtherCAT Slave Position `n` in EEPROM. This is equivalent to setting Object 0x1010:1 to 0x65766173 (ASCII: s:0x73, a:0x61, v:76, e:65).

If the EtherCAT slave has the capability to set parameters to EEPROM, most will use this method.

#### `ec-uart?  ( ch n -- t ) `

Is the position `n` Channel `ch` of the EtherCAT slave connected to a UART module?

#### `ec-wdt-proc-data@  ( n -- interval )`

Place watchdog time `interval` for EtherCAT slave `n` on the integer stack.

#### `ec-wdt-proc-data!  ( interval n -- )`

Set watchdog time `interval` for EtherCAT slave `n`. Interpret `interval` according to the slave's watchdog configuration.

If you want to disable the Watchdog, set `interval` to 0.

#### `ec-wdt-proc-data-busy?  ( n -- t )`

Return whether `@ec-wdt-proc-data` is still executing for the slave.

#### `ec-wdt-proc-data-error? ( n -- t )`

Return whether `@ec-wdt-proc-data` completed with an error.

#### `list-slaves ( -- )`

It displays the vendor id and product code of the EtherCAT slave.

Test example: The first slave is a Delta A2-E drive, and the second slave is a Shihlin Electric drive.

The return message:

    slaves|477,271601776,1468,1

    A2-E: vendor_id = 477 (0x1DD)
                 product_code =  271601776 (0x10305070)
    S.D.P.: vendor_id = 1468 (0x5BC)
                 product_code =  1 (0x1)

#### `sdo-busy? ( n -- t )`

EtherCAT slave  position `n` Is the SDO order waiting to be executed?

Command example 1:

    2 sdo-busy?

Command example 2: Read the value of the Slave 2 0x6064:0x00 address and wait for the output message after the command is completed.

    : test-sdo 0 $6064 2 sdo-upload-i32
               begin 2 sdo-busy? while pause repeat
               2 .sdo ;
     deploy test-sdo ;deploy

     Note:
     1. pause: Indicates that the current command is suspended, and that the execution begins from where the command is suspended while waiting for the next real-time cycle.
     2. deploy test-sdo; deploy: Put the test-sdo command in the background to execute.
            Because the commands defined by test-sdo contain waiting instructions, such as execution of the current Task,
            It can no longer handle subsequent instructions sent in by the client.

#### `sdo-data@ ( n -- data )`

Get SDO data for position `n` of EtherCAT slave, and store it in `data`.

#### `sdo-error? ( n -- t )`

EtherCAT slave  position `n` Is there a problem with the execution of the SDO order?

#### `sdo-download-i16 ( data subindex index n -- )`

Set the value. `data` EtherCAT slave is written in a 16-bit integer format via SDO. `n` The Object Index `index`: subindex `subindex`.

#### `sdo-download-i32 ( data subindex index n -- )`

Set the value. `data` EtherCAT slave is written in 32-bit integer form via SDO. `n` The Object Index `index`: subindex `subindex`.

Example command:

    100 0 $60FF 2 sdo-download-i32 \ Write `100` to Object `0x60ff`:`0` on Slave Position `2`

#### `sdo-download-i8 ( data subindex index n -- )`

Set the value. `data` EtherCAT slave is written in 8-bit integer form via SDO. `n` The Object Index `index`: subindex `subindex`.

#### `sdo-download-u16 ( data subindex index n -- )`

Write `data` as an unsigned 16-bit integer through SDO to Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `sdo-download-u32 ( data subindex index n -- )`

Write `data` as an unsigned 32-bit integer through SDO to Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `sdo-download-u8 ( data subindex index n -- )`

Write `data` as an unsigned 8-bit integer through SDO to Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `sdo-upload-i16 ( subindex index n -- )`

Read EtherCAT slave through SDO in a 16-bit integer format. `n` The Object Index `index`: subindex `subindex`.

#### `sdo-upload-i32 ( subindex index n -- )`

Read EtherCAT slave through SDO in a 32-bit integer format. `n` The Object Index `index`: subindex `subindex`.

example command:

    0 $6064 2 sdo-upload-i32 \ Read the slave position. `2` Object `0x6064`:`0`

#### `sdo-upload-i8  ( subindex index n -- )`

Read EtherCAT slave through SDO in an 8-bit integer format. `n` The Object Index `index`: subindex `subindex`.

#### `sdo-upload-u16 ( subindex index n -- )`

Read an unsigned 16-bit integer through SDO from Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `sdo-upload-u32 ( subindex index n -- )`

Read an unsigned 32-bit integer through SDO from Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `sdo-upload-u8  ( subindex index n -- )`

Read an unsigned 8-bit integer through SDO from Object Index `index`, subindex `subindex`, on EtherCAT slave `n`.

#### `until-no-requests ( -- )`

Wait for all SDO Requests to be completed.

This is equivalent to

    : until-no-requests ( -- )
        ." log|until-no-requests" cr
        begin
            waiting-requests?
        while
            pause
        repeat ;

#### `waiting-requests? ( -- t )`

Have all the SDO orders been executed?

#### Command Reference

| Command | Stack effect                       |
|-----|------------------------------|
| `.ec-dc`              | ( -- ) |
| `.ec-emcy`            | ( n -- ) |
| `.ec-links`           | ( -- ) |
| `.ec-wdt-proc-data`  | ( n -- ) |
| `.sdo`                | ( n --  ) |
| `.slave`              | ( n -- ) |
| `.slave-diff`         | ( n -- ) |
| `?ec-emcy`            | ( n -- ) |
| `@ec-wdt-proc-data` | ( n -- ) |
| `ec-a>n`              | ( alias -- n ) |
| `ec-ain?`             | ( ch n -- t ) |
| `ec-alias!`           | ( alias n -- ) |
| `ec-alias?`           | ( alias -- t ) |
| `ec-aout?`            | ( ch n -- t ) |
| `ec-din?`             | ( ch n -- t ) |
| `ec-dout?`            | ( ch n -- t ) |
| `ec-drive?`           | ( ch n -- t ) |
| `ec-emcy-busy?`       |( n -- t ) |
| `ec-encoder?`         | ( ch n -- t ) |
| `ec-gateway?`         | ( ch n -- t ) |
| `ec-load`             | ( n -- ) |
| `ec-ready?`           | ( -- t ) |
| `ec-save`             | ( n -- ) |
| `ec-uart?`            | ( ch n -- t ) |
| `ec-wdt-proc-data@` | ( n -- data ) |
| `ec-wdt-proc-data!` | ( cmd n -- ) |
| `ec-wdt-proc-data-busy?` | ( n -- t ) |
| `ec-wdt-proc-data-error?` | ( n -- t ) |
| `list-slaves`         | ( -- ) |
| `sdo-busy?`           | ( n -- t ) |
| `sdo-data@`           | ( n -- data ) |
| `sdo-error?`          | ( n -- t ) |
| `sdo-download-i16`    |( data subindex index n -- ) |
| `sdo-download-i32`    |( data subindex index n -- ) |
| `sdo-download-i8`     |( data subindex index n -- ) |
| `sdo-download-u16`    |( data subindex index n -- ) |
| `sdo-download-u32`    |( data subindex index n -- ) |
| `sdo-download-u8`     | ( data subindex index n -- ) |
| `sdo-upload-i16`      |( subindex index n -- ) |
| `sdo-upload-i32`      |( subindex index n -- ) |
| `sdo-upload-i8`       |( subindex index n -- ) |
| `sdo-upload-u16`      |( subindex index n -- ) |
| `sdo-upload-u32`      |( subindex index n -- ) |
| `sdo-upload-u8`       | ( subindex index n -- ) |
| `until-no-requests`   | ( -- ) |
| `waiting-requests?`   | ( -- t ) |
