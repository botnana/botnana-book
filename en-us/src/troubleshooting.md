# Troubleshooting & Diagnostics Guide

This guide is designed for automation engineers, electrical technicians, and software developers developing machinery or creating custom HMIs (e.g., using C/C++ `libbotnana`) to rapidly diagnose and resolve issues such as stationary motors, communication errors, and operating mode mismatches.

---

## 1. Diagnostic Decision Table

When encountering an unresponsive motor or axis, consult the table below to cross-check symptoms, verification steps, and resolutions:

| Symptom | Probable Cause | Verification Step | Resolution |
| :--- | :--- | :--- | :--- |
| **Motor is energized (Servo On), but stays completely stationary after Jog or position command** | **Operation Mode Mismatch**: Point-to-point commands (`target-p!` and `go`) were sent while in **CSP mode**, or the controller is still in the startup default **HM (Homing) mode**. | Query the active operation mode:<br>Forth: `1 1 op-mode .`<br>or monitor tag `real_operation_mode.1.1` | • For point-to-point jog motion, **you must switch to PP mode**:<br>`pp 1 1 op-mode! until-no-requests`<br>• In CSP mode, do not use `target-p!` and `go`; use axis group interpolation commands instead. |
| **Motion command fails or motor does not move in CSP mode** | **Unconfigured Axis Group**: The drive is not mapped to an Axis and an Axis Group in `motion.toml`. | Query axis and group configuration:<br>`1 .slave 1 .axiscfg 1 .grpcfg`<br>or inspect the Axis and Group tabs in Web HMI. | In the Web HMI, create Axis 1 and map it to the drive, create Group 1 (1D/2D/3D), assign Axis 1 to Group 1, save the profile, and restart the controller. |
| **Motor is completely limp / unpowered (freewheeling) when commanding motion** | **PDS State is not Operation Enabled**: The drive is in Switch On Disabled (1), Ready to Switch On (2), or Fault. | Query PDS state:<br>Forth: `1 1 pds-state .`<br>(Must be `4` for energized)<br>or inspect drive statusword `0x6041`. | Clear faults and enable the servo:<br>`1 1 reset-fault 1 1 drive-on until-drive-on` |
| **In PP mode, `go` immediately asserts `target-reached`, but the shaft never rotates** | **Profile Velocity or Acceleration is 0**: The drive's internal RAM parameter `profile_velocity` (`0x6081`) or acceleration is 0. | Query profile velocity:<br>Forth: `1 1 profile-v@ .` | Configure valid velocity and acceleration values:<br>`100000 1 1 profile-v!`<br>`50000 1 1 profile-a1!`<br>then re-issue `target-p!` and `go`. |
| **EtherCAT slave fails to reach OP (stuck in PREOP or SAFEOP)** | **Wiring fault, configuration mismatch, or EtherCAT Distributed Clocks (DC) synchronization failure**. | In Web HMI **Detected Slaves**, inspect the **AL State** column, or run `list-slaves`. | 1. Check physical cables and port LEDs.<br>2. In CSP mode, ensure the drive supports and has enabled EtherCAT DC sync.<br>3. Run **Rescan EtherCAT** from the HMI. |
| **Custom C++ HMI receives `error\|No message_to_task_producer.`** | **WebSocket User Task Sessions Exceeded**: Botnana Control provides strictly **2** interactive real-time user task slots, which are exhausted by extra browser tabs or clients. | Check if multiple browser tabs or clients are connected. | Close unused browser tabs. Custom HMI client applications must maintain a single persistent WebSocket connection. |
| **Custom C++ HMI receives `error\|Scripts buffer is fulled.`** | **Request Rate Exceeds Token Bucket Envelope**: Unthrottled bursts of script evaluations have filled the ring buffer. | Check client evaluation loops and polling intervals. | Adhere to third-party HMI profile guidelines: batch commands into single `script.evaluate` inputs and limit polling rates to within 100 req/s. |

---

## 2. CiA 402 Core Mechanics: PP Mode vs. CSP Mode

A frequent pitfall in drive application development is confusing the ownership of trajectory generation between **PP mode** and **CSP mode**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│   PP Mode (Profile Position, Mode 1)                                   │
│   [Master: Botnana] ──(One-shot target-p! & go)──► [Drive onboard DSP] │
│                                                   (Internal S-curve)   │
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│   CSP Mode (Cyclic Synchronous Position, Mode 8)                       │
│   [Master: Botnana Coordinator] ──(Cyclic 1ms stream)──► [Drive]       │
│   (Master computes trajectory & group interpolation)   (Follows stream)│
└────────────────────────────────────────────────────────────────────────┘
```

### PP Mode (Profile Position, CiA 402 Mode 1)
* **Trajectory Calculation**: Handled inside the **drive's onboard DSP**.
* **Use Cases**: Single-axis manual jog, simple point-to-point moves, tool changer positioning.
* **Mechanism**:
  1. The master sets target position `0x607A` (`target-p!`) and profile velocity `0x6081` (`profile-v!`).
  2. The master issues `go` (asserting Bit 4 `New set-point` in Controlword `0x6040`).
  3. The drive detects Bit 4, computes internal acceleration/deceleration curves, and moves the motor.
* **Standard Forth Sequence**:
  ```forth
  pp 1 1 op-mode! 100000 1 1 profile-v! until-no-requests
  1 1 drive-on until-drive-on
  250000 1 1 target-p! 1 1 go
  ```

### CSP Mode (Cyclic Synchronous Position, CiA 402 Mode 8)
* **Trajectory Calculation**: Handled by **Botnana Control Master's Coordinator**.
* **Use Cases**: Multi-axis coordinated interpolation, CNC contouring, circular arcs, robot kinematics.
* **Mechanism**:
  1. The drive's internal profile generator is completely disabled.
  2. The drive **completely ignores Controlword Bit 4 (`go`)**. Commanding `go` in CSP mode produces zero motion!
  3. Botnana Control calculates group path interpolation every 1 ms and streams cyclic positions in PDO `0x607A`.
  4. Any static `target-p!` written via script will be overwritten on the next 1 ms tick by the coordinator.
* **Prerequisites**:
  * **Axis Group Configuration**: The drive must be mapped to an Axis and an Axis Group in `motion.toml`.
  * **Coordinator Enabled**: The coordinator must be activated via `+coordinator`.
* **Standard Sequence** (`botnanac/examples/group1d.c`):
  ```forth
  \ 1. Switch drive to CSP mode and enable servo
  csp 1 1 op-mode! until-no-requests
  1 1 drive-on until-drive-on

  \ 2. Enable coordinator and bind group path
  +coordinator
  1 group! 0path 1 0axis-ferr +group

  \ 3. Command motion via Group Interpolator (NOT target-p! / go)
  0.05e vcmd!          \ set path velocity
  10.0e move1d         \ interpolate 10 mm
  start-job            \ execute motion
  ```

### HM Mode (Homing Mode, CiA 402 Mode 6)
* **Important**: When Botnana Control finishes booting, it automatically initializes all connected drives into **HM (Homing) mode**.
* In HM mode, Controlword Bit 4 represents **Homing operation start**. If an operator commands `go` without changing the mode to PP, the drive initiates a homing search instead of a positioning move!

---

## 3. 5-Second Quick Health Check

When a machine fails to move, evaluate these commands via Web HMI terminal or C++ `script_evaluate` to isolate the root cause in under 5 seconds:

```forth
\ 1. Check active operation mode of Slave 1 Channel 1
1 1 op-mode .
\ Returns: 1 -> PP mode, 6 -> HM mode, 8 -> CSP mode

\ 2. Check drive PDS state
1 1 pds-state .
\ Returns: 1 -> Switch on disabled, 2 -> Ready to switch on, 4 -> Operation enabled (Servo On)

\ 3. Check for drive error codes
1 1 error-code .
\ Returns 0 if healthy; if non-zero, cross-reference the vendor drive manual

\ 4. Inspect axis and group mapping
1 .axiscfg
1 .grpcfg
\ If empty, the axis group is unconfigured in motion.toml
```

---

## 4. Collecting Support Diagnostics

If an issue persists, generate a support diagnostic bundle for analysis:

1. Open the Web HMI and click **About** in the upper-right corner.
2. Select **Support diagnostics**.
3. Click **Download diagnostic log**.
4. Submit the generated `botnana-support-<timestamp>.zip` archive to support engineering.
