### EtherCAT UART Command Set

#### Command Reference

| Command | Stack effect                       |
|-----|------------------------------|
| `+uart-p2p` |( channel n -- ) |
| `-uart-p2p` |( channel n -- ) |
| `+uart-hdt` |( channel n -- ) |
| `-uart-hdt` |( channel n -- ) |
| `+uart-tx-opt` |( channel n -- ) |
| `-uart-tx-opt` |( channel n -- ) |
| `uart-baud!` |( baud channel n -- ) |
| `uart-frame!` |( frame channel n -- ) |
| `uart-ready?` |( channel n -- flag ) |
| `uart-error?` |( channel n -- flag ) |
| `uart-error@` |( channel n -- error ) |
| `0uart` |( channel n -- ) |
| `uart-rx-len@` |( channel n -- len ) |
| `uart-tx-space@` |( channel n -- space ) |
| `uart-data!` |( d1 d2 .. len channel n -- ) |
| `uart-data@` |( len channel n -- d1 d2 .. ) |
