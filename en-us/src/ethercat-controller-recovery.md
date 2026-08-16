# EtherCAT Controller Recovery

Use this procedure when Botnana Control must rediscover connected EtherCAT
hardware or **Controller & Topology** reports **Controller unavailable**. For an
approved addition, removal, replacement, or reorder, use
[EtherCAT Topology Maintenance](ethercat-topology-maintenance.md) instead.

> **Safety:** Put the machine in the site-approved safe stopped condition before
> rescanning, starting, or restarting the controller. These HMI operations are
> maintenance controls, not safety functions. Motion, scripts, and live EtherCAT
> controls are unavailable while the controller is unavailable or starting.

## Understand the Controller States

The HMI keeps several states separate:

- The **draft profile** contains edits currently shown in the HMI.
- The **saved profile** is the durable configuration used by **Start
  controller**.
- **Last working settings** are the settings retained from the previously
  running controller and used by a normal rescan.
- The **running controller** is the active EtherCAT controller. Saving a profile
  does not start it, and starting it does not automatically save detected
  hardware.

Use the action that matches the current display:

| HMI state | Action |
|---|---|
| Controller is ready and **Rescan EtherCAT** is available | Perform a normal rescan. |
| Lifecycle is **failed**, **Details** is titled **Controller unavailable**, and **Start controller** is available | Review the saved profile, then start the controller. The command bar may also report that the last-working-settings attempt failed. |
| **Start controller** is unavailable because the profile has unsaved changes | Save the intended changes or discard them, then review the saved profile again. |
| An operator-requested controller start is retrying topology verification and the command bar offers **Stop waiting** | Continue waiting, or stop the unproductive topology wait. You do not need to open **Details** to find this action. The initial boot attempt is not stoppable. |
| Startup is in progress without **Stop waiting** | Wait for success or failure; do not submit another request. This may be the non-stoppable initial boot attempt, or the current stage may not yet allow stopping. |
| **Start controller** is disabled and the HMI says **Start controller is unavailable until authoritative recovery status is available.** | Wait for the HMI to reconnect and display fresh authoritative status. |
| The HMI says to restart the **Botnana Control motion service (`bnc-motion`)** | This is the controller-runtime service on the BN-B3A, not an EtherCAT slave. Have an authorized administrator follow [When cleanup fails](#when-cleanup-fails). |

## Rescan a Ready Controller

A normal rescan rebuilds the running controller using **Last working settings**.
It does not apply unsaved profile edits.

1. Confirm the machine is in the site-approved safe condition.
2. Open **Controller & Topology**.
3. Select **Rescan EtherCAT**.
4. Watch the displayed startup stage and topology retry countdown. During
   topology retry, **Detected slaves** updates from each complete physical scan,
   so added, removed, replaced, or reordered slaves become visible immediately.
5. Compare **Detected slaves** with the intended physical chain. Displaying a
   changed scan does not save or adopt that topology.
6. If **Stop waiting** appears and further retry is not useful, follow
   [Stop a Topology Wait](#stop-a-topology-wait). Otherwise, continue waiting.
7. When the controller reports **Ready**, confirm that all expected EtherCAT
   slaves appear and verify the machine state before resuming operation.

If the command bar reports **Controller start with last working settings
failed**, the controller is unavailable. Select **Details** to open the
**Controller unavailable** drawer, then use
[Recover an Unavailable Controller](#recover-an-unavailable-controller).

## Stop a Topology Wait

The **Controller & Topology** command bar offers **Stop waiting** only while an
operator-requested controller start is retrying EtherCAT topology verification
and the controller reports that attempt as stoppable. The initial boot attempt
is not stoppable. It is a cooperative stop, not a rollback or emergency stop. The
previous controller has already been dismantled, and the controller remains
unavailable after the wait stops.

1. Keep the machine in the site-approved safe condition.
2. Review the displayed controller generation and settings source: **Last
   working settings** for a normal rescan, or **Saved profile** for recovery.
3. Select **Stop waiting**.
4. In the confirmation, verify the same generation and settings source. Confirm
   only if leaving the controller unavailable is still intended.
5. While **Stopping controller start…** is displayed, wait for any EtherCAT scan
   already in progress to return. The request does not force-stop that scan, and
   there is no guaranteed maximum completion time.
6. Continue only after the HMI reports that startup stopped and displays
   **Controller unavailable**.
7. Correct the connected hardware or saved profile, start the controller again,
   and verify the slaves and machine state.

Stopping does not save or discard edits, alter the saved profile or last working
settings, or adopt detected hardware. If **Stop waiting** disappears or the
request is rejected, rely on the refreshed status; do not assume startup
stopped.

## Recover an Unavailable Controller

**Start controller** always uses the saved profile.

1. On **Controller & Topology**, select **Details** and confirm the drawer is
   titled **Controller unavailable**. Read the failure reason and attempt stage.
2. Review the saved profile version and whether it differs from **Last working
   settings**.
3. If correction is required, open the configuration screen named in the
   **Edit in** column, select **Edit profile**, and make the change.
4. Review all unsaved changes, then choose one action:
   - **Save changes** makes the draft the saved profile for the next start.
   - **Discard changes** restores the saved profile. It does not restore last
     working settings or start the controller.
5. Return to **Controller & Topology** and verify the intended saved profile
   version.
6. Select **Start controller**.
7. Wait through validation, cleanup, replacement startup, and any topology
   retry. If **Stop waiting** appears and retry is no longer useful, follow the
   stop procedure above.
8. When the controller reports **Ready**, confirm the expected EtherCAT slaves
   and machine state before resuming operation.

If **Save changes** fails, the edits remain unsaved. Correct the reported issue
and select **Retry save**. Do not treat the edits as durable until the HMI
confirms they were saved.

Another browser session can change the profile while it is being reviewed. In
that case, Botnana Control rejects the stale edit, save, discard, or start
request. Review the refreshed profile and revision before trying again.

## Reconnection During Recovery

A browser disconnection does not cancel a rescan, stop request, or controller
start. After reconnecting, review the restored controller generation, settings
source, stage, stop state, and outcome before taking another action.

If the HMI remains at **Stopping controller start…**, record the available
support information and escalate. Do not assume the request completed.

## When Cleanup Fails

`bnc-motion` is the **Botnana Control motion service** running on the BN-B3A. It
hosts the EtherCAT controller runtime; it is not an EtherCAT slave, drive, or
motor. Restarting it interrupts the controller connection and is an authorized
administrator action, not a normal operator control.

Cleanup stops remaining tasks from the failed controller and releases its
runtime connections. If cleanup fails, another start is unsafe in the same
`bnc-motion` process. The HMI disables **Start controller** and directs an
administrator to restart this service.

1. Do not submit another start or rescan request.
2. Record the generation, failure reason, attempt stage, and outcome.
3. Save profile changes that must survive the restart, or discard unwanted
   changes. If saving fails, record any required unsaved values because a
   service restart may lose them.
4. Confirm the machine remains in the site-approved safe condition.
5. Have an authorized administrator run:

   ```bash
   sudo systemctl restart bnc-motion
   ```

6. Wait for the HMI to reconnect and display fresh status.
7. Review the saved profile again. If the controller is ready, verify the
   slaves and machine state. If it is unavailable and **Start controller** is
   enabled, repeat the recovery procedure.
8. If cleanup or service startup fails again, stop and contact support instead
   of repeatedly restarting the service.

Restarting `bnc-motion` does not delete the saved profile. Unsaved edits are not
a recovery source and should not be expected to survive.

A startup failure after successful cleanup is different: **Start controller**
may become available again because the failed replacement can still be released
safely. Retry only when the HMI enables the action. If the HMI requires a
service restart, use the cleanup-failure procedure instead.

## Information to Collect for Support

Record:

- time of failure;
- controller generation;
- failure reason, attempt stage, and outcome;
- whether **Stop waiting** was requested and whether the stopped outcome was
  reached;
- saved profile version and whether unsaved changes were present;
- expected and observed EtherCAT slaves; and
- whether the failure repeated after one authorized `bnc-motion` restart.

Preserve this information with the site incident record. Do not use EtherCAT
write commands as a troubleshooting shortcut.
