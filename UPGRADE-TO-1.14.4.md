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

The current 1.14.4 book sources and generated outputs have been published to
the `master` branch for review, but the control repository and book still have
release-closeout work:

- `motion/Cargo.toml` currently uses product version `1.14.4` and package
  revision `30`; additional 1.14.4 package revisions may be required before
  final release closeout.
- `debian/changelog` records the current `1.14.4-30` candidate for `unstable`;
  revision 3 adds the current-IP display correction, revision 4
  refreshes Detected slaves during rescan, revision 5 exposes **Stop waiting**
  directly in the controller command bar, revision 6 hides inapplicable
  topology actions during non-interactive transitions, revision 7 reports
  initial boot as **starting** rather than **restarting**, revision 8 simplifies
  topology-maintenance exit progress, revision 9 allows stopping the
  initial-boot topology wait, revision 10 returns a stopped maintenance start
  to the ordinary unavailable-controller workflow, revision 11 retains the
  pre-maintenance detected count as reference until an explicit scan, revision
  12 removes redundant maintenance-entry acceptance feedback, revision 13
  keeps those pre-maintenance slave rows visible as labelled reference evidence,
  revision 14 removes redundant topology-scan acceptance feedback, and revision
  15 presents a guided detected-topology review with an automatic fresh scan,
  revision 16 automatically creates the proposal and combines review, save, and
  start under one approval action, revision 17 closes the proposal immediately
  after approval and uses ordinary controller recovery after startup failure,
  revision 18 makes approval, durable save, and startup one server-owned
  operation that does not depend on follow-up browser requests, and revision 19
  adds bounded structured topology traces for field diagnosis, revision 20
  restores the saved configured-slave projection after topology cancellation,
  revision 21 restores released customer configuration setters and repeated
  parameterless `config.save`, revision 22 rejects changed reserved-runtime
  identities and responder counts, revision 23 retains complete physical
  topology evidence across failures and keeps unknown distinct from zero,
  revision 25 adds bounded same-generation reserved-master acquisition and
  ordinary PDO failure handling, revision 26 requires settled PREOP, successful
  mailbox preparation, and stable OP/process-data readiness, revision 27 keeps
  startup progress and its countdown visible until readiness, revision 28
  closes the reviewed deadline, mailbox, and reserved-state correctness gaps,
  revision 29 distinguishes active Motion values from saved configuration, and
  revision 30 keeps EtherCAT vendor and product identity read-only in the
  built-in Slave Configuration editor. Revision 24 was a diagnostic package
  and is not a release changelog entry.
- The bilingual book identifies version 1.14.4 with publication date
  August 17, 2026.
- The release notes, software-update and rollback procedures, current HMI
  screenshot, and About-page IP-address procedure are published.
- The proposed third-party HMI WebSocket profile is still marked `draft`.
- The bilingual controller-recovery and topology-maintenance chapters are
  published, and the public JSON API reference has been reconciled with the
  released customer API baseline. Primary-navigation guidance, the
  configuration-file reference, and the system architecture update are now
  complete; the candidate custom-HMI traffic profile remains open.
- The current-IP display correction is committed as `3190c96c3` and included
  in official package revision `1.14.4-3`, prepared by `f9fa385ed`.
- Current candidate `1.14.4-30` is prepared by control commit `f5a149590` as
  `botnana-control_1.14.4-30_arm64.deb` with SHA-256
  `8b3cf0680da95b1023ccd3e160f9f1c955b0a861dc02578b0a206a1b4369a0bc`.
- Supported-hardware evidence currently covers a controlled rescan and repeated
  recovery on the EC5500/EC5621 chain with `1.14.4-26`, automatic initial
  startup with `1.14.4-28`, and installation and operation of `1.14.4-30` with
  three slaves in OP, both domains at complete `2/2` working counters, and
  `NRestarts=0`. Broader product acceptance, especially hardware using
  `sdo_inhibit_before_op`, remains open.
- Software-update screenshots are workflow examples. They may retain earlier
  package revisions and do not need replacement for every packaging-only
  revision; captions and surrounding text must remain clear that they are
  examples.

Do not tag the book release until the remaining software release contract,
acceptance, and documentation scope decisions are complete.

## Working rules

- Treat `en-us/src/` and `zh-tw/src/` as the editable book sources.
- Keep English and Traditional Chinese behaviorally equivalent.
- Complete and review one step before moving to the next.
- Adapt control-repository documentation for book readers; do not copy internal
  design, development, or acceptance material unnecessarily.
- Clearly distinguish operator procedures from developer API contracts.
- Treat `~/Projects/botnana-apis` as the authority and upper bound for the
  customer-facing API. For the released compatibility baseline, use tag
  `customer-release-2025-02-21` and source-equivalent commit `1946d8d28759`.
- Do not publish a Botnana Control server method, parameter, response, or HMI
  lifecycle command as public API merely because the server implements it.
  Promote it through `botnana-apis` and obtain API-owner approval first.
- Server implementation and tests may clarify observable behavior for an API
  already in `botnana-apis`, but may not expand the documented public surface.
- Do not claim proposed or unverified behavior as a released guarantee.
- Do not edit `docs/`, generated `book/` directories, HTML, or PDFs by hand.
- Regenerate outputs with `./build-book.bash` after all source changes pass
  review.

## Step 1: Confirm the final 1.14.4 release contract

Before changing the book, resolve these release questions with the control
repository maintainers.

- [x] Confirm that all commits through `dcb3fba51` on
      `bounded-hmi-websocket-throughput` belong in 1.14.4.
- [ ] Confirm final release inclusion of the subsequent current-candidate
      commits through `f5a149590`.
- [x] Confirm the final Botnana Control version string (`1.14.4`).
- [x] Confirm the Debian filename pattern
      (`botnana-control_<Debian-version>_arm64.deb`).
- [ ] Confirm the final 1.14.4 Debian package revision after the remaining
      packaging iterations.
- [x] Confirm the book publication date (August 17, 2026).
- [x] Record control repository Debian changelog entries through the current
      `1.14.4-30` candidate.
- [ ] Decide whether the third-party HMI WebSocket profile is a supported
      integration contract or an operating recommendation.
- [ ] Confirm the exact WebSocket overload message and limits for the final
      build.
- [x] Exclude the new DoIP server from the public manual because it is not an
      officially supported 1.14.4 feature.
- [x] Record initial-startup and rescan/recovery acceptance on the current
      EC5500/EC5621 chain.
- [ ] Complete broader supported-hardware acceptance, especially the deferred
      startup-mailbox path used by `sdo_inhibit_before_op` products.

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
- [ ] Readiness publication only after required startup mailbox work succeeds
      and EtherCAT remains stably operational with complete process-data working
      counters.
- [ ] Controller-start progress and countdown remaining visible while Rescan is
      unavailable through configuration, activation, and readiness checks.
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
      screenshots. Keep them as stable workflow examples instead of retaking
      them for every Debian package revision.
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

- [x] Difference between a normal rescan and recovery from an unavailable
      controller.
- [x] The **Controller & Topology** work area.
- [x] **Rescan EtherCAT** for a ready controller.
- [x] Startup stages and topology retry countdown.
- [ ] Continued operator-facing startup stage and countdown after topology
      acceptance while the controller is configuring and checking readiness.
- [ ] **Ready** only after required mailbox work and stable EtherCAT
      operation/process-data readiness, without exposing internal lifecycle
      tokens to operators.
- [x] **Stop waiting** and its cooperative, non-rollback behavior.
- [x] Reviewing the saved profile before **Start controller**.
- [x] Saving or discarding profile changes before startup.
- [x] Rejection of stale actions after another session changes the profile.
- [x] Reconnect behavior during a controller start.
- [x] Cleanup failure and the requirement for an authorized
      `sudo systemctl restart bnc-motion`.
- [x] Information an operator should collect for support.

Reference:

- `docs/operator-guides/ethercat-controller-recovery.md`

## Step 6: Add an EtherCAT topology-maintenance chapter

Create bilingual chapters, for example:

- `en-us/src/ethercat-topology-maintenance.md`
- `zh-tw/src/ethercat-topology-maintenance.md`

Add them to both `SUMMARY.md` files near the controller-recovery chapter.

Document the concepts:

- [x] Configured topology.
- [x] Detected topology.
- [x] Proposed topology.
- [x] Shared draft and draft revision.
- [x] Saved profile and saved revision.
- [x] Running controller.
- [x] Retained pre-maintenance controller settings.

Document the safe workflow:

- [x] Prepare the machine and rollback plan.
- [x] Enter topology maintenance.
- [x] Change the physical hardware under the site's safety procedure.
- [x] Scan connected slaves.
- [x] Compare every detected slave with the intended physical change.
- [x] Use the complete detected topology; explain that partial adoption is not
      available.
- [x] Review additions, removals, moves, replacements, aliases, cleared
      settings, and ambiguous duplicate identities.
- [x] Save the reviewed topology while it remains inactive.
- [x] Apply the exact saved profile and wait for **Ready**.
- [x] Exit while preserving or discarding the draft when the detected hardware
      should not be adopted.
- [x] Recover after browser disconnection, scan failure, save failure, apply
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
- [x] Introduce the primary navigation.
- [x] Explain the purpose of **Controller & Topology**.
- [x] Explain the purpose of **Slave Configuration**.
- [x] Explain the purpose of **Motion**.
- [x] Explain the purpose of **Axis Group**.
- [x] Explain the purpose of **About**.
- [x] Explain that detected hardware, draft configuration, saved
      configuration, and the running controller are separate states.
- [x] Link to the recovery, topology-maintenance, and update chapters rather
      than duplicating their full procedures.

## Step 8: Update the JSON API and custom-HMI contract

Files:

- `en-us/src/json-api.md`
- `zh-tw/src/json-api.md`

Preserve the 1.14.3 guidance as historical compatibility information, then add
the final 1.14.4 behavior without exceeding the public surface owned by
`botnana-apis`.

### Public API inventory gate

- [x] Generate the method and parameter inventory from the released
      `botnana-apis` baseline rather than from Botnana Control routing code.
- [x] Classify each existing book example as public and current, public but
      compatibility-limited, obsolete, or internal-only.
- [x] Keep bundled-HMI controller recovery and topology-maintenance wire methods
      out of the public JSON API reference unless they are first promoted
      through `botnana-apis`.
- [x] Use Botnana Control evidence only to verify current behavior for methods
      already inside the public API boundary.

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

## Step 9: Resolve configuration protocol v2 public API ownership

Botnana Control implements configuration protocol v2 for the bundled HMI, but
the released `botnana-apis` baseline does not expose `protocol.negotiate`,
revision-bound configuration setters, or bundled-HMI lifecycle methods. Release
1.14.4-21 restores the unchanged released setters and parameterless
`config.save` through a bounded legacy server path; the internal protocol-v2
surface remains unpublished.

Tasks:

- [x] Decide with the API owner that the released configuration mutations remain
      supported customer APIs for 1.14.4.
- [x] Preserve the released setter and `config.save` request shapes without
      requiring a `botnana-apis` change.
- [x] Retain revision-aware stale-edit checks for negotiated bundled-HMI and
      internal profile workflows.
- [x] Document that legacy customer configuration requests require a single
      active configuration editor because they cannot report stale revisions.
- [x] Correct malformed or obsolete examples only within the API surface
      confirmed by `botnana-apis`.
- [x] Keep recovery and topology wire methods internal to the bundled HMI unless
      a later API release explicitly promotes them.
- [x] Record the reviewed API repository tag or commit used for every final JSON
      API example.

## Step 10: Expand the configuration-file reference

Files:

- `en-us/src/configuration-file.md`
- `zh-tw/src/configuration-file.md`

Add the currently relevant sections and defaults:

- [x] `[file] spec_version`
- [x] `[server] address`
- [x] `[motion] period_us`
- [x] `[motion] axis_capacity`
- [x] `[motion] group_capacity`
- [x] `[motion] boot_retry_window_ms`, default `120000`
- [x] Explain that `boot_retry_window_ms` bounds topology acquisition and
      candidate retry; after a candidate is accepted, configuration and
      activation readiness preserve any later deadline and otherwise receive a
      fresh minimum 30-second window.
- [x] Existing slave, device, axis, group, and timer settings that customers
      are expected to edit directly or through the HMI.

Do not document the `[doip]` settings in the public 1.14.4 manual. The DoIP
server is not an officially supported 1.14.4 feature.

Explain that profile edits made through the HMI are revision-aware and that a
saved profile is not necessarily the currently active controller until the
appropriate start or apply workflow completes.

## Step 11: Update the system architecture chapter

Files:

- `en-us/src/system-archetecture.md`
- `zh-tw/src/system-archetecture.md`

Tasks:

- [x] Replace the legacy Node.js HTTP-server description with the Rust
      `hmi-server`.
- [x] Show the boot-only update agent separately from the normal HMI server.
- [x] Describe the motion runtime supervisor and replaceable runtime
      generations.
- [x] Show draft profile, saved profile, detected topology, and active
      controller as separate concepts.
- [x] Explain that the HMI can remain available while the EtherCAT controller
      is unavailable.
- [x] Add per-connection WebSocket admission and bounded output at an
      appropriate level of detail.
- [x] Retain the existing real-time VM and motion-engine explanation where it
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
- [ ] Verify equivalent bilingual wording for stable readiness, the separate
      acquisition/readiness timing, and the visible controller-start countdown.
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
