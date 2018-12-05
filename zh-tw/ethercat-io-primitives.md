### EtherCAT IO primitives

#### `ec-dout@ ( channel n -- t=on )`

Get digital output state from EtherCAT slave n.

命令範例: 將 slave 3 的 channel 2 digital output state 放到整數堆疊 
    
    2 3 ec-dout@

#### `ec-dout! ( t=on channel n -- )`

Set digital output state of EtherCAT slave n.

命令範例 1: 將 slave 3 的 channel 2 digital output state 設定為 1。 

    1 2 3 ec-dout!

命令範例 2: 將 slave 3 的 channel 2 digital output state 設定為 0。 

    0 2 3 ec-dout!

#### `ec-din@ ( channel n -- t=on )`

Get digital input state from EtherCAT slave n.

命令範例: 將 slave 5 的 channel 3 digital input state 放到整數堆疊。 

    3 5 ec-din@

#### `-ec-aout ( channel n -- )`

Disable analog output of EtherCAT slave n

命令範例: 將 slave 2 的 channel 1 analog output 禁能。 

    1 2 -ec-aout

#### `+ec-aout ( channel n -- )`

Enable analog output of EtherCAT slave n

命令範例: 將 Slave 2 的 Channel 1 analog output 致能。 

    1 2 +ec-aout

#### `ec-aout@ ( channel n -- value )`

Get analog output data from EtherCAT slave n.

命令範例: 將 Slave 2 的 Channel 1 analog output data 放到整數堆疊。 

    1 2 ec-aout@

#### `ec-aout! ( value channel n -- )`

Set analog output data of EtherCAT slave n

命令範例: 將 slave 2 的 channel 1 analog output data 設定為 100。 
    
    100 1 2 ec-aout!

#### `-ec-ain ( channel n -- )`

Disable analog input of EtherCAT slave n

命令範例: 將 slave 6 的 channel 1 analog input 禁能。 

    1 6 -ec-ain

#### `+ec-ain ( channel n -- )`

Enable analog input of EtherCAT slave n

命令範例: 將 slave 6 的 channel 1 analog input 致能。 

    1 6 +ec-ain

#### `ec-ain@ ( channel n -- value )`

Get analog input data from EtherCAT slave n.

命令範例: 將 slave 6 的 channel 1 analog input data 放到整數堆疊。 

    1 6 ec-ain@

#### 本節指令集

| 指令 | 堆疊效果                       |
|-----|------------------------------|
| `ec-dout@` |( channel n -- t=on ) | 
| `ec-dout!` |( t=on channel n -- ) | 
| `ec-din@` |( channel n -- t=on ) | 
| `-ec-aout` |( channel n -- ) | 
| `+ec-aout` |( channel n -- ) |
| `ec-aout@` |( channel n -- value ) | 
| `ec-aout!` |( value channel n -- ) | 
| `-ec-ain` |( channel n -- ) | 
| `+ec-ain` |( channel n -- ) |
| `ec-ain@` |( channel n -- value ) | 
| `ec-ain-error` |( channel n -- error ) |
| `ec-ain-validity` |( channel n -- validity ) | 
