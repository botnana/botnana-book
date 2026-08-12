# Release Notes

## Changes Since Version 1.14.1

- The WebSocket watchdog period has increased from 4 to 10 seconds, improving tolerance for temporary communication delays.

## Recommendation for Custom HMI Applications

Version 1.14.3 does not enforce a bounded WebSocket request rate, and an
accepted `script.evaluate` request has no general success acknowledgement.
Custom HMI applications should follow the connection, request-rate, polling,
error-handling, and same-request command verification guidance in the
[JSON API](./json-api.md#websocket-recommendations-for-custom-hmis-version-1143).
