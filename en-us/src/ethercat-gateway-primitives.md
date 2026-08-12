### EtherCAT Gateway Command Set

Gateway data is read and written in bytes, in a manner similar to memory access.

The currently supported hardware is the Anybus X-Gateway.

**Notes:**

1. Read and write lengths are limited to 1–4 bytes.
2. The starting position is zero-based.

#### `0gateway ( ch n -- )`

Reset the gateway on channel `ch` of EtherCAT slave `n`.

#### `gateway-in-be@ ( len start ch n -- data )`

Read `len` bytes of gateway input data from `start` on channel `ch` of EtherCAT slave `n`, interpret the bytes as big-endian, and place `data` on the integer stack.

#### `gateway-in-le@ ( len start ch n -- data )`

Read `len` bytes of gateway input data from `start` on channel `ch` of EtherCAT slave `n`, interpret the bytes as little-endian, and place `data` on the integer stack.

#### `gateway-in-len@ ( ch n -- len )`

Place the gateway input-register size, `len` bytes, for channel `ch` of EtherCAT slave `n` on the integer stack.

#### `gateway-out-be! ( cmd len start ch n -- )`

Write `cmd` as `len` bytes of big-endian gateway output data at `start` on channel `ch` of EtherCAT slave `n`.

#### `gateway-out-be@ ( len start ch n -- data )`

Read `len` bytes of gateway output data from `start` on channel `ch` of EtherCAT slave `n`, interpret the bytes as big-endian, and place `data` on the integer stack.

#### `gateway-out-le! ( cmd len start ch n -- )`

Write `cmd` as `len` bytes of little-endian gateway output data at `start` on channel `ch` of EtherCAT slave `n`.

#### `gateway-out-le@ ( len start ch n -- data )`

Read `len` bytes of gateway output data from `start` on channel `ch` of EtherCAT slave `n`, interpret the bytes as little-endian, and place `data` on the integer stack.

#### `gateway-out-len@ ( ch n -- len )`

Place the gateway output-register size, `len` bytes, for channel `ch` of EtherCAT slave `n` on the integer stack.

#### `gateway-ready? ( ch n -- t )`

Return whether the gateway on channel `ch` of EtherCAT slave `n` is ready.

#### Command Reference

| Command | Stack effect |
|---------|--------------|
| `0gateway`          | ( ch n -- ) |
| `gateway-in-be@`    | ( len start ch n -- data ) |
| `gateway-in-le@`    | ( len start ch n -- data ) |
| `gateway-in-len@`   | ( ch n -- len ) |
| `gateway-out-be!`   | ( data len start ch n -- ) |
| `gateway-out-be@`   | ( len start ch n -- data ) |
| `gateway-out-le!`   | ( data len start ch n -- ) |
| `gateway-out-le@`   | ( len start ch n -- data ) |
| `gateway-out-len@`  | ( ch n -- len ) |
| `gateway-ready?`    | ( ch n -- t ) |
