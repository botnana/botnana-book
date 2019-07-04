### EtherCAT Gateway 指令集
             
Gateway 的資料操作是以 Byte 為單位。以類似記憶體存取的方式進行讀取/寫入。
            
                                          
#### 本節指令集

| 指令 | 堆疊效果                       | 說明 |
|-----|------------------------------|-----|
| `gateway-ready?` |( channel n -- t ) | Is gateway ready?
| `0gateway` |( channel n -- ) |  Reset gateway
| `gateway-in-len@` |( channel n -- length ) | Fetch gateway input length
| `gateway-out-len@` |( channel n -- length ) | Fetch gateway output length
| `gateway-in-be@` |( len start_index channel n -- data ) |  Fetch gateway input data by big endian
| `gateway-in-le@` |( len start_index channel n -- data ) | Fetch gateway input data by little endian.
| `gateway-out-be@` |( len start_index channel n -- data ) |Fetch gateway output data by big endian
| `gateway-out-le@` |( len start_index channel n -- data ) | Fetch gateway output data by little endian.
| `gateway-out-be!` |( data len start_index channel n -- ) | Set gateway output data by big endian
| `gateway-out-le!` |( data len start_index channel n -- ) | Set gateway output data by little endian

注意事項：

1. 讀取/寫入資料長度限制 1 ~ 4 byte
2. start index 必須從 1 開始