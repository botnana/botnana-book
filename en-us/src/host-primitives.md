### Botnana Basic Command Set

#### `mtime ( -- n )`

Current time in milliseconds

#### `.cpu-timing ( -- )`

Print information of CPU timing

#### `0cpu-timing ( -- )`

Reset CPU timing

#### `.verbose ( -- )`

Print verbose infornatiom

Return message example:

    version_number|1.3.1|period_us|2000|launch_time|2018-08-09T10:19:21Z

#### `.motion ( -- )`

Print information of motion.

It can only be set up through the Json API.

example command:

    .motion

The return message:

    period_us|2000
    |group_capacity|7
    |axis_capacity|10

#### Command Reference

| Command | Stack effect       |
|-----|---------------|
| `mtime`        | ( -- n ) |
| `.cpu-timing` | ( -- ) |
| `0cpu-timing` | ( -- ) |
| `.verbose`     | ( -- ) |
| `.motion`     | ( -- ) |

---

### Timer Commands

A total of 100 timers are available, numbered from 1 to 100.

Timers use nanoseconds internally and count with an unsigned 64-bit integer, giving a period of nearly 500 years before overflow.

Timer durations use signed 32-bit integers, allowing a maximum duration of 24.8 days.

Use the example:

```
   100 1 timer-ms!  \ Set the number 1 timer to 100 ms.
   1 0timer             \ Restart timer 1.
   1 timer-expired? .   \ Check if the timer number 1 has exceeded the timer time.
```

#### `.timer ( no -- )`

Display the state of timer `no`.

example command:

    1 .timer

The return message:

    timer_name.1|None|timer_duration.1|0.0 ms|
    timer_expired.1|1|elapsed_time.1|307537.1 ms|
    start_time.1|0.0 ms|current_time.1|307537.1 ms

#### `0timer ( no -- )`

Restart timer `no`.

#### `timer-ms! ( ms no -- )`

Set timer `no` to a duration of `ms` milliseconds.

#### `timer-expired?  ( no -- t )`

Return whether timer `no` has expired.

#### Command Reference

| Command | Stack effect       |
|-----|---------------|
| `.timer`     | ( no -- ) |
| `0timer`     | ( no -- ) |
| `timer-ms!`     | ( ms no -- ) |
| `timer-expired?`     | ( no -- t ) |

---

### Digital Flip-Flop

Digital flip-flops detect transitions in digital signals. The supported trigger types are:

* High-level trigger
* Low-level trigger
* Rising-edge trigger
* Falling-edge trigger

**High-level trigger condition**

```
 True              +--------------
                   |
 False ------------+

                   |-----------|
                     Hold Time

   As long as the hold time is satisfied, the digital counterfactor switches to true (true) status.
   This is the opposite of false (False).

   When the conditions are met, the digital counter can continue to output as True until the original signal is converted to False.

```

**Low-level trigger condition**

```
 True  ------------+
                   |
 False             +--------------

                   |-----------|
                     Hold Time

   As long as the hold time is satisfied, the digital counterfactor switches to true (true) status.
   This is the opposite of false (False).

   When the conditions are met, the digital counter can continue to output as True until the original signal is converted to True.

```

**Conditions triggered by the top edge**

```
 True              +---------
                   |
 False ------------+

         |---------|------|
           Set-up    Hold
           Time      Time

   In order to meet Set-up time and Hold Time simultaneously, the digital counterfactor switches to True.
   This is the opposite of false (False).

   Because it is an edge trigger, the digital counterfactor has only one cycle output for True.

```

**Conditions triggered by the bottom edge**

```
 True  ------------+
                   |
 False             +---------

         |---------|------|
           Set-up    Hold
           Time      Time

   In order to meet Set-up time and Hold Time simultaneously, the digital counterfactor switches to True.
   This is the opposite of false (False).

   Because it is an edge trigger, the digital counterfactor has only one cycle output for True.

```

There are a total of 100 digital inverters available, numbered from 1 to 100.
So the name is: `_uc` The final instruction does not check whether the numbering is within the correct range, so special attention should be paid to its use.

Use the example:

```
   3 1 ff-type!           \ Set digital flip-flop 1 to rising-edge trigger.
   2000 1 ff-setup!       \ Set the setup time for digital flip-flop 1.
   2000 1 ff-hold!        \ Set the hold time for digital flip-flop 1.
   true 1 ff-forth-uc     \ Set the raw state of digital flip-flop 1; execute this every cycle.
   ...
   1 ff-triggered-uc? .   \ Has the digital counter number 1 been triggered?
```

#### `.ff ( no -- )`

Display the state of digital flip-flop `no`.

example command:

    1 .ff

The return message:

    ff_type.1|High Level|setup_time.1|2000|hold_time.1|2000|
    setup_count.1|0|hold_count.1|0|last.1|0|triggered.1|0

#### `ff-forth-uc ( t no -- )`

Set state `t` for digital flip-flop `no` on every cycle.

**This command does not validate the stack depth or the range of `no`; use it with care.**

#### `ff-hold! ( us no -- )`

Set hold time `us`, in microseconds, for digital flip-flop `no`.

#### `ff-last-uc@ ( no -- t )`

Get the last/current raw state of digital flip-flop `no`.

**This command does not validate the stack depth or the range of `no`; use it with care.**

#### `ff-setup! ( us no -- )`

Set setup time `us`, in microseconds, for digital flip-flop `no`.

#### `ff-triggered-uc? ( no -- t )`

Return whether digital flip-flop `no` meets its trigger condition.

**This command does not validate the stack depth or the range of `no`; use it with care.**

#### `ff-type! ( type no -- )`

Set trigger type `type` for digital flip-flop `no`.

The available values for `type` are:

* 1: High-level trigger
* 2: Low-level trigger
* 3: Rising-edge trigger
* 4: Falling-edge trigger

#### `has-ff? ( no -- t )`

Is there a digital output with number `no`?

#### `reset-ff ( no -- )`

Clear the internal state of digital flip-flop `no` without changing its configuration.

#### Command Reference

| Command | Stack effect       |
|-----|---------------|
| `.ff`     | ( no -- ) |
| `ff-forth-uc`     | ( t no -- ) |
| `ff-hold!`     | ( us no -- ) |
| `ff-last-uc@`     | ( no -- t ) |
| `ff-setup!`     | ( us no -- ) |
| `ff-triggered-uc?`     | ( no -- t ) |
| `ff-type!`     | ( type no -- ) |
| `has-ff?`     | ( no -- t ) |
| `reset-ff`     | ( no -- ) |
