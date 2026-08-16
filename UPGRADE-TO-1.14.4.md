# Botnana Book Upgrade Plan for Version 1.14.4

## Purpose

Upgrade the English and Traditional Chinese Botnana Book from Botnana Control
1.14.3 to 1.14.4, using the implementation and operator documentation in:

```text
~/Projects/control.worktrees/bounded-hmi-websocket-throughput
```

The work must be completed step by step. Do not update generated HTML or PDFs
manually. Change the Markdown sources first, review them, and regenerate the
published outputs only after the source documentation is complete.

## Current release status

The 1.14.4 book update has been published to the `master` branch, but the
control repository still has release-closeout work:

- `motion/Cargo.toml` uses product version `1.14.4` and package revision `2`.
- `debian/changelog` uses `1.14.4-2`, includes the legacy-upgrade compatibility
  corrections, and remains marked `UNRELEASED`.
- The bilingual book identifies version 1.14.4 with publication date
  August 17, 2026.
- The release notes, software-update and rollback procedures, current HMI
  screenshot, and About-page IP-address procedure are published.
- The proposed third-party HMI WebSocket profile is still marked `draft`.
- The dedicated controller-recovery, topology-maintenance, public JSON API,
  configuration-file, and architecture updates in this plan remain open.
- The current-IP display correction is committed in the control worktree as
  `3190c96c3`; it was validated on a controller with temporary package
  `1.14.5-4` and is not part of the official 1.14.4 package.

Do not tag the book release until the remaining software release contract,
acceptance, and documentation scope decisions are complete.

## Working rules

- Treat `en-us/src/` and `zh-tw/src/` as the editable book sources.
- Keep English and Traditional Chinese behaviorally equivalent.
- Complete and review one step before moving to the next.
- Adapt control-repository documentation for book readers; do not copy internal
  design, development, or acceptance material unnecessarily.
- Clearly distinguish operator procedures from developer API contracts.
- Do not claim proposed or unverified behavior as a released guarantee.
- Do not edit `docs/`, generated `book/` directories, HTML, or PDFs by hand.
- Regenerate outputs with `./build-book.bash` after all source changes pass
  review.

## Step 1: Confirm the final 1.14.4 release contract

Before changing the book, resolve these release questions with the control
repository maintainers.

- [ ] Confirm that all commits currently on
      `bounded-hmi-websocket-throughput` belong in 1.14.4.
- [x] Confirm the final Botnana Control version string (`1.14.4`).
- [x] Confirm the final Debian package version and filename pattern
      (`botnana-control_1.14.4-2_arm64.deb`).
- [x] Confirm the book publication date (August 17, 2026).
- [ ] Approve and release the updated control repository Debian changelog
      (currently `1.14.4-2 UNRELEASED`).
- [ ] Decide whether the third-party HMI WebSocket profile is a supported
      integration contract or an operating recommendation.
- [ ] Confirm the exact WebSocket overload message and limits for the final
      build.
- [ ] Decide whether the new DoIP server is officially supported and should be
      included in the public manual.
- [ ] Confirm which controller-recovery and topology-maintenance scenarios have
      completed supported-hardware acceptance.

The book content is published for review, but do not create the final `v1.14.4`
tag until these decisions are complete. Any remaining candidate-only behavior
must stay out of public guarantees or be labelled accordingly.

## Step 2: Update basic version metadata

Update the manual version and release date in both languages.

Files:

- `en-us/src/cover.md`
- `zh-tw/src/cover.md`
- `en-us/src/software.md`
- `zh-tw/src/software.md`
- `presentation.md`

Tasks:

- [x] Change Botnana Control `1.14.3` to final `1.14.4`.
- [x] Update the publication date.
- [x] Ensure no alpha version appears in the final book.
- [x] Search all source Markdown for stale `1.14.1`, `1.14.2`, and `1.14.3`
      examples and retain intentional historical compatibility material.

## Step 3: Rewrite the release notes

Files:

- `en-us/src/release-notes.md`
- `zh-tw/src/release-notes.md`

Add a 1.14.4 section describing changes since 1.14.3:

- [x] In-process EtherCAT rescan.
- [x] Boot-time topology verification and retry window.
- [x] Ability to stop an unproductive topology wait.
- [x] Failed-controller recovery from the reviewed saved profile.
- [x] EtherCAT topology maintenance for adding, removing, replacing, or
      reordering slaves.
- [x] Revision-aware profile editing and stale-action rejection.
- [x] Redesigned HMI navigation and configuration workspaces.
- [x] Reviewed Debian package staging, next-boot installation, rollback, and
      partial-installation recovery.
- [x] Replacement of the legacy Node.js HMI server with the Rust HMI server.
- [x] Atomic profile and IP-address persistence.
- [x] Bounded WebSocket traffic, explicit overload behavior, non-blocking
      output, and connection cleanup.
- [x] Important reconnect, profile-editing, topology-refresh, and WebSocket
      lifecycle fixes.

Compatibility notes:

- [x] State that the bundled HMI and motion server must be upgraded together
      because configuration protocol v2 is required for profile mutations.
- [x] State that `script.evaluate` still has no generic success acknowledgement.
- [x] Avoid claiming that every field-reported motion-command issue is resolved
      unless final acceptance evidence supports that statement.

Primary control-repository references:

- `debian/changelog`
- `docs/operator-guides/`
- `docs/use-cases/`
- `docs/design-models/bounded-hmi-websocket-throughput.md`

## Step 4: Replace the software-update procedure

Files:

- `en-us/src/update-software.md`
- `zh-tw/src/update-software.md`

Retain **UPLOAD MANUALLY** only for the one-time transition from 1.14.3 or
earlier, and document the reviewed About-page package workflow for 1.14.4 and
later.

Document:

- [x] Safety and trusted-network requirements.
- [x] Selecting a Debian package.
- [x] Reviewing filename, package identity, version, architecture,
      classification, and SHA-256.
- [x] Staging the exact reviewed package for the next boot.
- [x] Cancelling a pending package before installation starts.
- [x] Rebooting to perform one installation attempt.
- [x] Checking installed version and the authoritative last result.
- [x] Understanding rejected, failed, timed-out, interrupted, bookkeeping, and
      unknown results.
- [x] Recovering when motion is blocked after a possibly partial installation.
- [x] Reviewing and staging the retained prior version for rollback.
- [ ] Recognizing externally managed packages.
- [x] Reboot and power-off behavior when an update is pending.

Reference:

- `docs/operator-guides/about-page.md`

Assets:

- [x] Capture new 1.14.4 About-page screenshots and managed-update workflow
      screenshots.
- [x] Retain the old **UPLOAD MANUALLY** screens only in the explicitly labelled
      one-time upgrade procedure for version 1.14.3 and earlier.
- [x] Use the final `1.14.4-2` package filename in transition and rollback
      examples.

## Step 5: Add an EtherCAT controller recovery chapter

Create bilingual chapters, with final filenames chosen consistently, for
example:

- `en-us/src/ethercat-controller-recovery.md`
- `zh-tw/src/ethercat-controller-recovery.md`

Add them to:

- `en-us/src/SUMMARY.md`
- `zh-tw/src/SUMMARY.md`

Document:

- [ ] Difference between a normal rescan and recovery from an unavailable
      controller.
- [ ] The **Controller & Topology** work area.
- [ ] **Rescan EtherCAT** for a ready controller.
- [ ] Startup stages and topology retry countdown.
- [ ] **Stop waiting** and its cooperative, non-rollback behavior.
- [ ] Reviewing the saved profile before **Start controller**.
- [ ] Saving or discarding profile changes before startup.
- [ ] Rejection of stale actions after another session changes the profile.
- [ ] Reconnect behavior during a controller start.
- [ ] Cleanup failure and the requirement for an authorized
      `sudo systemctl restart bnc-motion`.
- [ ] Information an operator should collect for support.

Reference:

- `docs/operator-guides/ethercat-controller-recovery.md`

## Step 6: Add an EtherCAT topology-maintenance chapter

Create bilingual chapters, for example:

- `en-us/src/ethercat-topology-maintenance.md`
- `zh-tw/src/ethercat-topology-maintenance.md`

Add them to both `SUMMARY.md` files near the controller-recovery chapter.

Document the concepts:

- [ ] Configured topology.
- [ ] Detected topology.
- [ ] Proposed topology.
- [ ] Shared draft and draft revision.
- [ ] Saved profile and saved revision.
- [ ] Running controller.
- [ ] Retained pre-maintenance controller settings.

Document the safe workflow:

- [ ] Prepare the machine and rollback plan.
- [ ] Enter topology maintenance.
- [ ] Change the physical hardware under the site's safety procedure.
- [ ] Scan connected slaves.
- [ ] Compare every detected slave with the intended physical change.
- [ ] Use the complete detected topology; explain that partial adoption is not
      available.
- [ ] Review additions, removals, moves, replacements, aliases, cleared
      settings, and ambiguous duplicate identities.
- [ ] Save the reviewed topology while it remains inactive.
- [ ] Apply the exact saved profile and wait for **Ready**.
- [ ] Exit while preserving or discarding the draft when the detected hardware
      should not be adopted.
- [ ] Recover after browser disconnection, scan failure, save failure, apply
      failure, or required service recovery.

Reference:

- `docs/operator-guides/ethercat-topology-maintenance.md`

The book chapter should be shorter than the repository guide. Internal
acceptance-fixture instructions belong in engineering documentation unless they
are needed by customers performing formal commissioning.

## Step 7: Update Getting Started and HMI navigation

Files:

- `en-us/src/botnana-control-tutorial.md`
- `zh-tw/src/botnana-control-tutorial.md`
- Related screenshots under each language's source tree

Tasks:

- [x] Replace the old HMI screenshot with the final 1.14.4 interface.
- [ ] Introduce the primary navigation.
- [ ] Explain the purpose of **Controller & Topology**.
- [ ] Explain the purpose of **Slave Configuration**.
- [ ] Explain the purpose of **Motion**.
- [ ] Explain the purpose of **Axis Group**.
- [ ] Explain the purpose of **About**.
- [ ] Explain that detected hardware, draft configuration, saved
      configuration, and the running controller are separate states.
- [ ] Link to the recovery, topology-maintenance, and update chapters rather
      than duplicating their full procedures.

## Step 8: Update the JSON API and custom-HMI contract

Files:

- `en-us/src/json-api.md`
- `zh-tw/src/json-api.md`

Preserve the 1.14.3 guidance as historical compatibility information, then add
the final 1.14.4 behavior.

### Client traffic profile

- [ ] Use one persistent WebSocket per application whenever possible.
- [ ] Explain that only two rtForth WebSocket user sessions are available.
- [ ] Route bootstrap, heartbeat, reads, polling, and commands through one
      outbound budget.
- [ ] Document burst capacity 5.
- [ ] Document sustained refill of 100 requests per second.
- [ ] Poll only values needed by the visible screen.
- [ ] Replace or discard superseded polls.
- [ ] Never send a catch-up burst after a delay or reconnect.
- [ ] Give deliberate commands priority without bypassing the budget.
- [ ] Keep read-only polling scripts within 512 UTF-8 bytes and 32 normalized
      operations.
- [ ] Keep mutations separate from discardable polling batches.

### Server overload behavior

After final release confirmation, document the exact response:

```text
error|WebSocket request limit exceeded. Non-admitted requests during the next 1 second have no effect; retry later.
```

Explain:

- [ ] Admission is per connection.
- [ ] Excess request rate alone does not close the connection.
- [ ] Non-admitted mutations during the reported overload period have no
      effect.
- [ ] The client must process every `error|...` message.
- [ ] A successful WebSocket send or absence of an error is not proof that a
      script completed.
- [ ] Reconcile controller state before retrying a state-changing request.

### Observable group command pattern

Retain and update the single-request pattern:

```json
{
  "jsonrpc": "2.0",
  "method": "script.evaluate",
  "params": {
    "script": "1 group! 100.0e mm/min vcmd! 1 .group"
  }
}
```

Explain:

- [ ] `group!` and commands depending on it must be in the same evaluation.
- [ ] The readback makes the stored result observable but does not prove
      physical velocity.
- [ ] Only one state-changing script should await reconciliation per
      connection.
- [ ] `vcmd!` intentionally does not change a Sine group's configured velocity
      amplitude.

Reference, after its release status is approved:

- `docs/proposals/third-party-hmi-websocket-profile-1.14.4.md`

## Step 9: Document configuration protocol v2

Update the configuration API section in both `json-api.md` files.

Document negotiation before a profile mutation:

```json
{
  "jsonrpc": "2.0",
  "method": "protocol.negotiate",
  "params": {
    "versions": [2]
  }
}
```

Successful response:

```text
configuration-protocol|selected|2
```

Tasks:

- [ ] Explain `configuration-protocol|upgrade-required|2`.
- [ ] Explain draft and saved profile revisions.
- [ ] Add `draft_revision` to configuration setter examples.
- [ ] Add `draft_revision` to save, discard, and server-address save examples.
- [ ] Explain stale-revision errors and refreshing authoritative profile state
      before retrying.
- [ ] Correct existing malformed or outdated JSON examples while editing the
      chapter.
- [ ] Decide which recovery and topology methods are supported public APIs.
- [ ] Document supported public methods, or explicitly state that the operator
      lifecycle methods are currently intended for the bundled HMI.

## Step 10: Expand the configuration-file reference

Files:

- `en-us/src/configuration-file.md`
- `zh-tw/src/configuration-file.md`

Add the currently relevant sections and defaults:

- [ ] `[file] spec_version`
- [ ] `[server] address`
- [ ] `[motion] period_us`
- [ ] `[motion] axis_capacity`
- [ ] `[motion] group_capacity`
- [ ] `[motion] boot_retry_window_ms`, default `120000`
- [ ] Existing slave, device, axis, group, and timer settings that customers
      are expected to edit directly or through the HMI.

If DoIP is approved as a public 1.14.4 feature, also document:

- [ ] `[doip] enabled`, default `false`
- [ ] `[doip] address`, default `0.0.0.0:13400`
- [ ] `[doip] ecu_logical_address`, default `4096` (`0x1000`)
- [ ] `[doip] discovery`, default `false`
- [ ] Optional `[doip] vin`

Explain that profile edits made through the HMI are revision-aware and that a
saved profile is not necessarily the currently active controller until the
appropriate start or apply workflow completes.

## Step 11: Update the system architecture chapter

Files:

- `en-us/src/system-archetecture.md`
- `zh-tw/src/system-archetecture.md`

Tasks:

- [ ] Replace the legacy Node.js HTTP-server description with the Rust
      `hmi-server`.
- [ ] Show the boot-only update agent separately from the normal HMI server.
- [ ] Describe the motion runtime supervisor and replaceable runtime
      generations.
- [ ] Show draft profile, saved profile, detected topology, and active
      controller as separate concepts.
- [ ] Explain that the HMI can remain available while the EtherCAT controller
      is unavailable.
- [ ] Add per-connection WebSocket admission and bounded output at an
      appropriate level of detail.
- [ ] Retain the existing real-time VM and motion-engine explanation where it
      remains accurate.

## Step 12: Update About-page IP instructions

Files:

- `en-us/src/faq/gadget.md`
- `zh-tw/src/faq/gadget.md`

Tasks:

- [x] Explain that the user enters the first three address numbers and the
      controller address always ends in `.2`.
- [x] Explain the preview and validation behavior.
- [x] Explain that the saved address takes effect only after reboot.
- [x] Explain the acknowledged save result.
- [x] Explain that unsaved machine-profile edits or another configuration
      operation can make IP saving unavailable.
- [x] Tell the user to record both old and new addresses before rebooting.
- [x] Show the original `192.168.7.2` address before the example change to
      `192.168.6.2`.

## Step 13: Review specifications and terminology

Files to review include:

- `en-us/src/software.md`
- `zh-tw/src/software.md`
- `en-us/src/hardware.md`
- `zh-tw/src/hardware.md`
- `en-us/src/bn-b3a.md`
- `zh-tw/src/bn-b3a.md`
- `presentation.md`

Tasks:

- [ ] Resolve the difference between the product-supported slave count and the
      runtime scan capacity before changing published capacity claims.
- [ ] Use consistent terms for controller, runtime generation, saved profile,
      draft, detected topology, rescan, recovery, and topology maintenance.
- [ ] Ensure safety wording does not imply that HMI confirmation is a safety
      interlock.
- [ ] Ensure commands requiring administrator access are clearly labelled.

## Step 14: Perform bilingual and technical review

- [x] Compare the published release notes, update procedure, Getting Started,
      and IP-address instructions between English and Traditional Chinese.
- [x] Verify button labels used by the published operator procedures against
      the HMI.
- [ ] Verify all JSON examples against the final server.
- [ ] Verify all error and status strings exactly where the book promises an
      exact value.
- [x] Verify links and anchors in both languages with the book test suites.
- [x] Verify published screenshots do not contain alpha versions, private data,
      or development-only controls.
- [ ] Review all safety-sensitive procedures with the control maintainers.
- [ ] Review the custom-HMI section with an API maintainer.

## Step 15: Build and validate the book

After all source changes are approved:

```bash
./build-book.bash
```

Then:

- [x] Run `tests/test-build-book.bash`.
- [x] Run `tests/test-language-switch.js`.
- [x] Run `tests/test-pages-workflow.bash`.
- [x] Run `tests/test-release-workflow.bash`.
- [x] Inspect the generated Traditional Chinese Pages site under `docs/`.
- [ ] Inspect both generated PDF files.
- [ ] Check page breaks, tables, code blocks, diagrams, images, and links.
- [ ] Search generated output for stale alpha and 1.14.3 references.

## Step 16: Publish the 1.14.4 book release

- [x] Commit source Markdown, assets, generated Pages output, and PDFs according
      to the repository's existing release process.
- [ ] Tag the book release `v1.14.4` only after the final software contract is
      confirmed.
- [x] Verify the GitHub Pages language-switch contract.
- [x] Verify the release PDF download-link contract.
- [x] Verify that the generated manual and PDFs identify the same version and
      release date.

## Recommended execution order

Work through the book in these small reviewable groups:

1. Confirm release contract.
2. Version metadata and release notes.
3. Software update/About procedure.
4. Controller recovery chapter.
5. Topology-maintenance chapter.
6. Getting Started and screenshots.
7. JSON API and configuration protocol v2.
8. Configuration-file and architecture references.
9. FAQ and terminology cleanup.
10. Bilingual review.
11. Build, test, and publish.

Each group should be reviewed before starting the next one. This keeps release
claims, operator procedures, API behavior, translation, and generated output
from changing all at once.
