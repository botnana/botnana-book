# EtherCAT Topology Maintenance

Use topology maintenance when an authorized commissioning technician deliberately
adds, removes, replaces, or reorders EtherCAT slaves. Use a normal **Rescan
EtherCAT** when the hardware layout is not meant to change. Use
[EtherCAT Controller Recovery](ethercat-controller-recovery.md) when a failure
was not caused by an approved layout change.

Scanning connected hardware does not save or adopt it. A changed layout becomes
active only after you use the complete scan as a proposal, review its
consequences, save it, apply that exact saved version, and reach **Ready**.

> **Safety:** Follow the site's lockout, motion-disable, electrical-isolation,
> and verification procedures. The HMI confirmation records your assertion that
> the machine is safe; it is not a safety interlock. Keep the machine in its
> approved safe condition while the controller is unavailable, starting, or
> reporting a failure.

## Understand the Topology States

**Controller & Topology** keeps physical observations, proposed edits, stored
configuration, and the running controller separate:

| HMI state | Meaning |
|---|---|
| **Configured slaves** | Read-only topology used as the saved comparison baseline during maintenance. |
| **Detected slaves** | Read-only hardware from the latest successful maintenance scan. During normal startup or rescan, it instead follows each latest complete physical startup scan. |
| **Proposed topology** | The complete detected topology after you explicitly select **Use complete detected topology**. Only **Expected Alias** is editable here. |
| **Shared draft** and **Draft version** | The configuration being reviewed. It is not yet stored for startup. |
| **Saved profile** and **Saved version** | The durable configuration stored on the controller. |
| **Running controller** | The configuration currently controlling the machine. Saving does not change it. |
| **Pre-maintenance controller settings** | The exact retained controller plan used when exiting without applying the proposal. |

The sheet counts are cross-checks. A difference between configured and detected
counts changes nothing by itself. During maintenance, **Detected slaves** shows
only the exact successful maintenance scan; it is not mixed with startup-scan
observations.

Use **Slave Configuration** to review drive, I/O, channel, and other device-type
settings. Changing sheets in **Controller & Topology** does not replace that
editor.

## Prepare the Change

Before entering maintenance:

1. Record the approved physical change, current slave order, aliases, vendor
   IDs, product codes, and rollback plan. Photograph labels and cabling when
   useful.
2. Confirm that the rollback plan from step 1 is practical: if the changed
   topology does not reach **Ready**, the previous slaves, physical order, and
   cabling can be restored.
3. On **Controller & Topology**, compare **Configured slaves** and **Detected
   slaves**.
4. Topology maintenance uses the saved profile as its comparison and recovery
   baseline. Save existing edits that must be retained, or discard unwanted
   edits, until the HMI no longer reports **Unsaved changes**. This prevents
   ordinary configuration edits from being mixed with the topology change.
5. Stop scripts, recipes, HMI jobs, and other work using the controller.
6. Put the machine in the site-approved safe condition.
7. Continue only when **Enter topology maintenance** is available and no nearby
   message reports an unresolved condition.

The controller may be **Ready**, or it may be **Failed** because the deliberate
physical layout already differs from the clean saved profile.

## Enter Topology Maintenance

1. Select **Enter topology maintenance**.
2. Read the confirmation and confirm only if the machine is already safe.
3. Wait while Botnana Control releases the controller generation and EtherCAT
   master. Do not repeat the request.
4. Confirm that **Scan connected slaves** becomes available.
5. Confirm that **Configured slaves** and **Detected slaves** remain separate
   and that no proposal exists yet.

The controller being unavailable is expected. Entering maintenance does not
change the draft or saved version. Normal profile editors remain visible but
are disabled during maintenance.

If entry is rejected, read the displayed reason. Do not bypass it. Causes can
include unfinished controller work, an active transition, unsaved profile
edits, another maintenance operation, or runtime resources that cannot safely
be released.

## Change, Scan, and Compare the Hardware

1. Keep the machine safe and isolate device power as required by the site and
   hardware instructions.
2. Perform only the approved addition, removal, replacement, or reorder.
3. Check device power, EtherCAT-IN/EtherCAT-OUT orientation, cable seating, and
   physical order. Restore power only when permitted.
4. Select **Scan connected slaves** and wait for completion. Reloading or closing
   the browser does not cancel the scan.
5. Select **Detected slaves**. Confirm its source identifies the current
   maintenance scan.
6. Compare every position, vendor ID, product code, and expected device with the
   approved change and physical labels.

There is no partial selection. Every detected row must belong to the intended
layout. If any row is unexpected, correct the hardware and scan again. A new
scan replaces the comparison and invalidates earlier review acknowledgements,
but it never silently saves the hardware.

If the detected topology matches the saved topology, you may exit and restore
the pre-maintenance controller settings. You can still create a proposal when
an expected alias must change.

## Build and Review the Complete Proposal

1. Confirm again that every detected row is intended.
2. Select **Use complete detected topology**. Partial adoption is not available.
3. Confirm that **Proposed topology** has the same positions, vendor IDs, and
   product codes as **Detected slaves**.
4. If required, edit **Expected Alias** using a whole number from 0 through
   65535. This changes the configuration expectation and may rebase references;
   it does not write the physical slave EEPROM.
5. Select **Review consequences**.
6. Review every cleared, defaulted, moved, retained, and alias consequence.
7. Confirm only when each result matches the approved settings and mapping plan.

Typical consequences include:

| Change | Required review |
|---|---|
| Added slave | A minimal entry is created; Botnana Control does not guess device settings or mappings. |
| Removed slave | Review every drive, axis, group, I/O, or channel relationship that referred to it. |
| Unique move | Identity-bound references may move, but position-dependent assumptions still require review. |
| Unlike replacement | Device-specific settings are cleared rather than copied to different hardware. |
| Ambiguous identical devices | Botnana Control does not guess a move; unmatched settings are conservatively cleared. |

Do not accept a cleared or default value merely to enable saving. If a
consequence is not intended, cancel, correct the hardware or plan, scan again,
or exit and discard the draft.

Removing the final slave can produce a valid zero-row proposal. An empty saved
slave list is treated as an uncommissioned topology; it does not enforce that no
slave may be connected later.

## Save and Apply the New Topology

1. Confirm that every required consequence has been accepted for the displayed
   draft version.
2. Select **Save reviewed topology (inactive)**.
3. Wait for the saved version to advance. Confirm that the controller remains
   unavailable and that the saved topology is reported as inactive.
4. Recheck the saved version and topology.
5. Select **Apply saved topology** and verify the confirmation identifies the
   intended saved change.
6. Wait for startup. Do not issue another apply or exit request.
7. Continue only when the controller reports **Ready**.
8. Verify slave order, identity, required device settings, and machine state
   before restoring motion permission.

Saving is not activation. If you stop after saving, the saved profile differs
from the inactive controller and the machine must not be treated as ready.

While apply or exit is starting a controller, the normal controller lifecycle is
the only progress display. If **Stop waiting** appears and you confirm it, the
attempt is cancelled, topology maintenance ends, and the HMI returns to the
ordinary unavailable-controller state. It does not return to maintenance or
show maintenance retry/restore actions automatically. Deliberately choose
**Enter topology maintenance**, **Start controller**, or profile correction from
the current state.

## Exit Without Adopting the Scan

Use an exit action when the detected hardware must not be activated:

- With no unsaved topology draft, select **Exit and restore pre-maintenance
  controller**.
- With unresolved reviews, select **Exit and discard draft**. Preserving is not
  available.
- With a fully reviewed draft, deliberately select **Exit and preserve draft**
  or **Exit and discard draft**.

Exit starts the retained pre-maintenance controller settings; it does not adopt
the detected scan. Restore compatible physical hardware first when necessary,
then wait for **Ready** and verify the machine.

If the proposal was already saved, exiting does not roll back the saved profile.
The saved topology remains stored but inactive.

## Reconnection and Failures

Topology maintenance belongs to the controller, not to one browser. After a
reload or reconnection, wait for **Restoring topology maintenance state** to be
replaced by a current phase. Verify the phase, state revision, draft and saved
versions, detected snapshot, proposal, and reviews before continuing. If another
session acted first, review the refreshed state rather than repeating an old
request.

- **Scan failure:** Do not use an older snapshot when it is marked non-current.
  Check power, links, cabling, and discovery state; retry only after correcting
  the cause.
- **Save failure:** The draft remains unsaved. Correct the reported problem and
  retry only when the same draft is still displayed.
- **Apply or exit failure:** Keep the machine safe. Use only the retry or retained
  pre-maintenance exit action offered by the HMI.
- **Service recovery is required:** Do not start another in-process operation.
  Record the phase, versions, generation, and error. Have an authorized
  administrator follow the `bnc-motion` procedure in
  [EtherCAT Controller Recovery](ethercat-controller-recovery.md#when-cleanup-fails).

For support, record the installed Botnana Control version, approved change,
physical identities and order before and after, maintenance phase, draft and
saved versions, detected snapshot, accepted consequences, final controller
state, and the time of any disconnect, retry, or service restart.
