### Host primitives

#### `mtime ( -- n )`

Current time in milliseconds

#### `.cpu-timing ( -- )`

Print information of CPU timing

#### `0cpu-timing ( -- )`

Reset CPU timing

#### `.verbose ( -- )`

Print verbose infornatiom

回傳訊息範例 :

    version_number|1.3.1|period_us|2000|launch_time|2018-08-09T10:19:21Z

#### `.motion ( -- )`
    
Print information of motion. 

只能透過 Json API 進行設定。 
 
命令範例:   
    
    .motion
 
回傳訊息：
    
    period_us|2000
    |group_capacity|7
    |axis_capacity|10 

#### 本節指令集

| 指令 | 堆疊效果       |
|-----|---------------|
| `mtime`        | ( -- n ) |
| `.cpu-timing` | ( -- ) |
| `0cpu-timing` | ( -- ) |
| `.verbose`     | ( -- ) |
| `.motion`     | ( -- ) |

