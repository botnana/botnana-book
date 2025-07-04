### EtherCAT Gateway 指令集
             
閘道器 Gateway 的資料操作是以 Byte 為單位。以類似記憶體存取的方式進行讀取/寫入。

目前支援的硬體是： Anybus X-Gateway

**注意事項：**

1. 讀取/寫入資料長度限制 1 ~ 4 byte
2. 起始位置必須從 0 開始

#### `0gateway ( ch n -- )`

重置 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器。

#### `gateway-in-be@ ( len start ch n -- data )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸入資料，由起始位置 `start`，資料長度 `len` bytes，
以 Big-Endian 的位元組順序讀出，放到整數堆疊上 `data`。

#### `gateway-in-le@ ( len start ch n -- data )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸入資料，由起始位置 `start`，資料長度 `len` bytes，
以 Little-Endian 的位元組順序讀出，放到整數堆疊上 `data`。  

#### `gateway-in-len@ ( ch n -- len )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸入暫存器大小 `len` bytes 放到整數堆疊上。

#### `gateway-out-be! ( cmd len start ch n -- )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸出資料，起始位置 `start`，資料長度 `len` bytes，
以 Big-Endian 的位元組順序寫入 `cmd`。

#### `gateway-out-be@ ( len start ch n -- data )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸出資料，由起始位置 `start`，資料長度 `len` bytes，
以 Big-Endian 的位元組順序讀出，放到整數堆疊上 `data`。

#### `gateway-out-le! ( cmd len start ch n -- )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸出資料，起始位置 `start`，資料長度 `len` bytes，
以 Little-Endian 的位元組順序寫入 `cmd`。

#### `gateway-out-le@ ( len start ch n -- data )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸出資料，由起始位置 `start`，資料長度 `len` bytes，
以 Little-Endian 的位元組順序讀出，放到整數堆疊上 `data`。

#### `gateway-out-len@ ( ch n -- len )`

將 EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器的輸出暫存器大小 `len` bytes 放到整數堆疊上。

#### `gateway-ready? ( ch n -- t )`

EtherCAT 從站編號 `n`，第 `ch` 管道的閘道器是否備妥 ？

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `0gateway`          |( ch n -- )                      |
| `gateway-in-be@`   |( len start ch n -- data ) |
| `gateway-in-le@`   |( len start ch n -- data ) |
| `gateway-in-len@`  |( ch n -- len )                  |
| `gateway-out-be!`  |( data len start ch n -- ) |
| `gateway-out-be@`  |( len start ch n -- data ) |
| `gateway-out-le!`  |( data len start ch n -- ) |
| `gateway-out-le@`  |( len start ch n -- data ) |
| `gateway-out-len@` |( ch n -- len )                  |
| `gateway-ready?`   |( ch n -- t )                    |
