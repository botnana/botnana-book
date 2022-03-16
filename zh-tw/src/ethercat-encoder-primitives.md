### EtherCAT Encoder primitives
                                          
#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `ec-enc-validity` |( channel n -- validity ) | 
| `ec-enc-warning` |( channel n -- warning ) | 
| `ec-enc-err` |( channel n -- err ) | 
| `ec-enc-ready` |( channel n -- ready ) | 
| `ec-enc-pos` |( channel n -- position ) | 
| `+ec-enc-reversed` |( channel n -- ) | 
| `-ec-enc-reversed` |( channel n -- ) |
| `ec-enc-ofs!` |( ofs channel n -- ) |
| `ec-enc-ofs@` |( channel n -- ofs ) | 