## Servo On/OFF SFC 範例 

```

          +-------------------+
          |       Init        |
          +--------+----------+
                   |
             Devices exist ?        檢查是否有對應的裝置。
                   |
          +--------v----------+
+-------> |       Idle        | 
|         +--------+----------+
|                  |
|          servo-on accepted ?      檢查 servo-on request。 
|                  |
|         +--------v-------------+   
|         |    Wait 1000 ms      |  可以在此 setp 才輸送動力電源， 1000 ms 是讓動力電源穩定的時間。
|         +--------+-------------+  
|                  |                      
|                True
|                  | 
|         +--------v-------------------+
|         |    Reset All Drives Fault  |
|         |    Change to CSP Mode      |
|         +--------+-------------------+
|                  |
|           No Drive Fault ?      驅動器異警有可能無法清除，所以需要有 2000 ms 的 timeout 時間。
|                  or
|           Elapsed 2000 ms ?          
|                  |
|        +---------v-----------+
|        |   All drives on     |  每個驅動器必須分時切換到 drive on 狀態，避免動力電源不穩定。 
|        +---------+-----------+
|                  |
|            All-drives-on?       等待所有驅動器是否都已經切換到 drive on 狀態，
|                 or              需要有 2000 ms 的 timeout 時間避免有驅動器無法到達 
|           Elapsed 2000 ms?      drive on 狀態。
|                  |
|        +---------v-----------+
|        |                     |  檢查驅動器狀態
|        |  Servo Loop Process |  檢查 following error
|        |                     |  有異常發出 servo-off 要求。
|        +---------+-----------+
|                  |                               
|          servo-off accepted ?   檢查 servo-off 要求。
|                  |              
|        +---------v-----------+
|        |   All Drives Off    | 
|        +---------+-----------+
|                  |
|            Elapsed 1000 ms ?
|                  |
|        +---------v---------------+
|        |   servo-post-operation  | 可以在此切斷動力電源 
|        +---------+---------------+
|                  |
|                 True
|                  |
+------------------+
                  

```



## SFC 實作：


```

\ Axes Description
\ 此範例為 3 軸的 Servo On/OFF SFC 範例
\ 分別為第 1, 2 , 3 運動軸 
\ 不使用 index 0 的運動軸
3 constant axes-len
create axes 0 , 1 , 2 , 3 ,

\ 使用 axes-enabled 可以暫時將指定軸排除在此 SFC 的運作邏輯之外
create axes-enabled false , true , true , true ,

\ 各軸 Servo lag 的檢查範圍， 當運動軸靜止時採用 min-ferr-limit
create min-ferr-limit falign 0e f, 0.05e mm f, 0.05e mm f, 0.05e mm f,
create max-ferr-limit falign 0e f, 1.00e mm f, 1.00e mm f, 1.00e mm f,


\ Debug flag
\ 顯示除錯訊息
variable servo-debug
: +servo-debug
    true servo-debug !
    ;
: -servo-debug
    false servo-debug !
    ;

\ 取得受控運動軸清單中的軸編號
: axis@ ( index -- axis-no )
    cells axes + @
    ; 

\ 取得受控運動軸清單中的致能狀態 (enabled/disabled)
: axis-enabled? ( index -- flag )
    cells axes-enabled + @
    ;

\ 將運動軸清單中的運動軸致能    
: +axis  ( index -- )
    cells axes-enabled + true swap ! 
    ;

\ 將運動軸清單中的運動軸禁能     
: -axis  ( index -- )
    cells axes-enabled + false swap ! 
    ;    

\ 設定 min-ferr-limit
: min-ferr-limit! ( index -- )( F: limit -- )
    floats min-ferr-limit faligned + f!
    ;

\ 設定 max-ferr-limit
: max-ferr-limit! ( index -- )( F: limit -- )
    floats max-ferr-limit faligned + f!
    ;


\ Is servo on
\ 使用此參數來紀錄目前是否處在 servo-on 的狀態
variable is-servo-on

\ Is servo idle
\ 用來紀錄是否處於 Servo Idle Step，在此 step 才會接受 servo on request
variable is-servo-idle

\ Servo On Accepted
\ 用來紀錄 servo on request 是否被接受
variable servo-on-accepted

\ Servo Off Accepted
\ 用來紀錄 servo off request 是否被接受
variable servo-off-accepted


\ Is servo on ?
\ 是否在 Servo On 的狀態
: servo-on?  ( -- flag )
    is-servo-on @
    ;

\ 取得目前適用的 following error limit
\ Servo Off 或是運動軸靜止的時候採用 min-ferr-limit
: ferr-limit@ ( index -- )( F: -- limit )
    axis@ dup axis-staying? servo-on? not or if
        min-ferr-limit  
    else
        max-ferr-limit
    then
    faligned swap floats + f@
    ;

\ 落後誤差檢查
\ servo-lag-err 是用來紀錄 servo-lag-check 檢查之後是否有異常的旗標
\ 所以要使用 servo-lag-err 前要先執行 servo-lag-check
variable servo-lag-err
: servo-lag-check ( -- )
    false servo-lag-err !
    1
    begin
        dup axes-len <=   
    while
        dup axis-enabled? if
            dup axis@ dup ferr-limit@ axis-ferr@ fabs f< if
                ." error|Axis (" dup axis@ 0 .r  ." ) Following error too large" cr
                servo-on? not if
                    dup axis@ 0axis-ferr
                then    
                true servo-lag-err !
            then
        then    
        1+    
    repeat
    drop
    ;


\ 發出 Servo On Request
\ 如果目前狀態可以允許 Servo On，會將 servo-on-accepted 變數設定為真。
: +servo-on ( -- )
    ." log|Servo On Request!" cr
    true servo-on-accepted !
    is-servo-idle @ not if false servo-on-accepted ! ." log|Not Servo Idle" cr then
    servo-lag-check servo-lag-err @ if false servo-on-accepted ! then  
    ;

\ 發出 Servo Off Request
\ 如果目前狀態可以允許 Servo Off，會將 servo-off-accepted 變數設定為真。
: -servo-on ( -- )
    ." log|Servo Off Request!" cr
    true servo-off-accepted !
    servo-on? not if false servo-off-accepted ! ." log|Not Servo On" cr then
    
    1
    begin
        dup axes-len <=   
    while
        dup axis-enabled? if
            dup axis@ axis-staying? not if
                ." error|Axis (" dup axis@ 0 .r  ." ) is not stopped" cr
                false servo-off-accepted !
            then
        then    
        1+    
    repeat
    drop
    
    ;
    
\ 發出 Servo Emergency Off Request
\ 不管目前狀態會將 servo-off-accepted 變數設定為真。
: ems-servo-off ( -- )
    ." log|Emergency Servo Off Request!" cr
    true servo-off-accepted !
    ;    
    

\ Servo Init Step
\ 檢查對應的硬體裝置是否存在，只在一開始的時候做一次，如果檢查沒有通過，SFC 會停留在這個 step。
variable servo-init-once
variable servo-devices-ok
: servo-init ( -- )
    servo-init-once @ not if        
        true servo-devices-ok !
        1
        begin
          dup axes-len <=   
        while
            dup axis-enabled? over axis@ virtual-axis? and if
                ." error|Axis (" dup axis@ 0 .r  ." ) is virtual axis" cr
                false servo-devices-ok ! 
            then
            1+    
        repeat
        drop
    
        true servo-init-once !    
        
        servo-debug @ if ." log|Servo Init Step" cr then
  
    then
    ;

\ Servo Idle Step
\ 在此狀態等待 servo-on-accetped 為真
: servo-idle ( -- )
    true is-servo-idle !
    ;

\ Servo Waiting Power Stable Step  
\ 可以在此送出動力電源的控制訊號
\ 在此狀態等待 1000 ms 動力電源穩定
variable servo-pre-operation-once
variable servo-disable-operation-once
: servo-waiting-power-stable ( -- )
    false is-servo-idle !
    false servo-on-accepted !
    false servo-pre-operation-once !
    false servo-disable-operation-once !
    ;

\ Servo pre operation 
\ 清除驅動器異警與切換到 CSP 模式.
\ 啟動軸組(axis group)運動控制
variable servo-current-axis
variable servo-old-axis
: servo-pre-operation ( -- )
    servo-pre-operation-once @ not if
        +coordinator
        1
        begin
          dup axes-len <=   
        while
            dup axis-enabled? if
                dup csp swap axis@ axis-drive@ op-mode!
                dup axis@ axis-drive@ reset-fault
            then    
            1+    
        repeat
        drop
               
        true servo-pre-operation-once !
        1 servo-current-axis !
        0 servo-old-axis !
    
        servo-debug @ if ." log|Servo pre. operation" cr then
    then
    ;

\ Servo Enable Operation
\ 分時將所有驅動器切換到 drive on 狀態 
variable servo-on-time
: servo-enable-operation ( -- )
    servo-current-axis @ servo-old-axis @ <> if
        servo-current-axis @ dup servo-old-axis !
        dup axis-enabled? if
            dup axis@ axis-drive@ drive-on
        then
        drop    
        mtime servo-on-time !
        servo-debug @ if ." log|Servo enable operation" cr then
    then
    
    mtime servo-on-time @ - 100 > if
        servo-current-axis @ dup axes-len < if
            1+ servo-current-axis !
        else
            drop
        then
    then
    ;

\ Servo Loop
\ 檢查以下條件：
\ 1. drive-on?
\ 2. drive-fault?
\ 3. following error 
\ 如果有問題就發出 ems-servo-off
: servo-loop ( -- )
    
    true is-servo-on !
    1
    begin
        dup axes-len <=   
    while
        dup axis-enabled? if
            dup axis@ axis-drive@ drive-on? not if
                ." error|Not expected drive off" cr
                ems-servo-off
            then
            
            dup axis@ axis-drive@ drive-fault? if
                ." error|drive fault" cr
                ems-servo-off
            then
        then    
        
        1+    
    repeat
    drop
    
    servo-lag-check servo-lag-err @ if ems-servo-off then
    
    ;

\ Servo Disable Operation
\ 接收到 servo-off-accepted 為真時，就執行 drive-off
\ 關閉軸組運動控制
: servo-disable-operation ( -- )
    
    false is-servo-on !
    false servo-off-accepted !
    servo-disable-operation-once @ not if
        true servo-disable-operation-once !
        -coordinator
        1
        begin
            dup axes-len <=   
        while
            dup axis-enabled? if
                dup axis@ axis-drive@ drive-off
            then    
            1+    
        repeat
        drop
        
        servo-debug @ if ." log|Servo disable operation" cr then
    then
    ;


\ Servo Post Operation 
\ Drive Off 後可以在此將動力電源關閉
: servo-post-operation ( -- )
    ;


\ 對應的裝置檢查是否通過 ？
: servo-devices-ok? ( -- flag )
    servo-devices-ok @ 
    ;

\ Servo On Request 是否被接受？
: servo-on-accepted? ( -- flag )
    servo-on-accepted @
    ;

\ Servo power stable 
\ 計數等待 power stable 的時間是否到達？ 
: servo-power-stable? ( -- flag )
    ['] servo-waiting-power-stable elapsed 1000 >
    ;

\ 所有的驅動器異警是否都已經清除
\ 或是經過 2000 ms 也無法清除異警 ?
variable all-drive-no-fault
: servo-wait-no-fault? ( -- flag )
    true all-drive-no-fault ! 
    1
    begin
        dup axes-len <=   
        all-drive-no-fault @ and
    while
        dup axis-enabled? if
            dup axis-drive@ drive-fault? not all-drive-no-fault ! 
        then
        1+    
    repeat
    drop
    
    all-drive-no-fault @
    ['] servo-pre-operation elapsed 2000 >
    or
    ;

\ 所有的驅動器是否都已經 drive on
\ 或是經過 2000 ms 也無法 drive on ?
variable all-drive-on
: servo-operation-enabled?  ( -- flag )
    true all-drive-on !
    1
    begin
        dup axes-len <=
        all-drive-on @ and   
    while
        dup axis-enabled? if
            dup axis@ axis-drive@ drive-on? all-drive-on !    
        then
        1+   
    repeat
    drop
    
    all-drive-on @
    ['] servo-enable-operation elapsed 2000 >
    or
    ;

\ Servo Off Request 是否被接受？
: servo-off-accepted?  ( -- flag )
    servo-off-accepted @
    ;


\ Is servo operation disabled ? 
\ 計數等待 servo disable operation 的時間是否到達？ 
: servo-operation-disabled? ( -- flag )
    ['] servo-disable-operation elapsed 1000 >
    ;


\ servo-default-true 
\ 預設要自動切換到 Servo Idle
: servo-default-true? ( -- flag )
    true
    ;

step servo-init
step servo-idle
step servo-waiting-power-stable
step servo-pre-operation
step servo-enable-operation
step servo-loop
step servo-disable-operation
step servo-post-operation 

transition servo-devices-ok?
transition servo-on-accepted?
transition servo-power-stable?
transition servo-wait-no-fault?
transition servo-operation-enabled?
transition servo-off-accepted?
transition servo-operation-disabled? 
transition servo-default-true?

' servo-init                 ' servo-devices-ok?  -->
' servo-devices-ok?          ' servo-idle        -->
' servo-idle                 ' servo-on-accepted? -->
' servo-on-accepted?         ' servo-waiting-power-stable -->  
' servo-waiting-power-stable ' servo-power-stable?  -->
' servo-power-stable?        ' servo-pre-operation -->
' servo-pre-operation        ' servo-wait-no-fault? -->
' servo-wait-no-fault?       ' servo-enable-operation -->
' servo-enable-operation     ' servo-operation-enabled? -->
' servo-operation-enabled?   ' servo-loop -->
' servo-loop                 ' servo-off-accepted? -->
' servo-off-accepted?        ' servo-disable-operation -->
' servo-disable-operation    ' servo-operation-disabled? -->
' servo-operation-disabled?  ' servo-post-operation -->
' servo-post-operation       ' servo-default-true? -->
' servo-default-true?        ' servo-idle          -->

' servo-init +step

```
