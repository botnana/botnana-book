## Motion State SFC 範例

此範例將主站的運動模式規劃為 3 種，這 3 種模式不會同時運行。

1. Homing: 回歸機械原點模式。
2. Jogging: 軸運動模式。
3. Machining: 加工模式。


```

                            +--------+
+---------------------------+  Idle  |
|                           |        |
|                           +---+----+
|                               |
|            +------------------+-------------------+
|            |                  |                   |
|    homing-accepting?  jogging-accepted?  machining accepted?
|            |                  |                   |
|       +----v----+       +-----v----+        +-----v-----+
|       | Homing  |       |  Jogging |        | Machining |
|       |         |       |          |        |           |
|       +----+----+       +-----+----+        +-----+-----+
|            |                  |                   |
|     homing-stopped?    jogging stopped?   machining-stopped?
|            |                  |                   |
|            +------------------+-------------------+
|                               |
|                         +-----v-------+
|                         | post action |
|                         |             |
|                         +-----+-------+
|                               |
|                             True
|                               |
+------------------------<------+

```

## SFC 實作：


```

\ 定義是否接受運動模式要求的變數
variable homing-accepted
variable jogging-accepted
variable machining-accepted

\ 定義運動模式是否結束的變數
variable homing-stopped
variable jogging-stopped
variable machining-stopped

\ 要求運動停止
variable motion-stopping

\ 紀錄目前的運動模式
variable motion-state

\ 是否處於 Motion Idle 狀態
: is-motion-idle?  ( -- flag )
    motion-state @ 0=
    ;

\ 是否要求運動停止?
: is-motion-stopping? ( -- flag )
    motion-stopping @
    ;

\ 開始進行回歸機械原點
\ 可以規劃不同的判斷邏輯，發出回歸原點的指令或是啟動回歸機械原點的 SFC。
: start-homing ( -- )
    is-motion-idle? if
        true homing-accepted !
        1 motion-state !
        ." log|Start homing" cr
    else
        ." log|Not Motion Idle" cr
    then
    ;

\ 開始進行軸移動
\ 可以規劃不同的判斷邏輯，發出軸運動指令或是啟動軸運動的 SFC。
: start-jogging ( -- )
    is-motion-idle? if
        true jogging-accepted !
        2 motion-state !
        ." log|Start jogging" cr
    else
        ." log|Not Motion Idle" cr
    then
    ;

\ 開始進行加工
\ 可以規劃不同的判斷邏輯，發出加工指令或是啟動軸運動的 SFC。
: start-machining  ( -- )
    is-motion-idle? if
        true machining-accepted !
        3 motion-state !
        ." log|Start machining" cr
    else
        ." log|Not Motion Idle" cr
    then
    ;

\ 要求運動停止
\ 可以依運動模式發出不同的停止命令
: stop-motion  ( -- )
    is-motion-idle? not if
        motion-state @ case
            1 of  ." log|Stop Homing" cr endof
            2 of  ." log|Stop Jogging" cr endof
            3 of  ." log|Stop machining" cr endof
        endcase
        true motion-stopping !
    else
        ." log|motion idle" cr
    then
    ;

\ 要求運動緊急停止
: ems-motion  ( -- )
    true homing-stopped !
    true jogging-stopped !
    true machining-stopped !
    ." log|EMS motion" cr
    ;


\ Motion Idle Step
: motion-idle ( -- )
    ;

\ Motion Homing Step
\ 可以在此規劃 Homing 時的活動，與收到停止命令時的處置
: motion-homing ( -- )
    is-motion-stopping? if
        true homing-stopped !
    then
    ;


\ Motion Jogging Step
\ 可以在此規劃 Jogging 時的活動，與收到停止命令時的處置
: motion-jogging ( -- )
    is-motion-stopping? if
        true jogging-stopped !
    then
    ;

\ Motion Machining Step
\ 可以在此規劃 Machining 時的活動，與收到停止命令時的處置
: motion-machining ( -- )
    is-motion-stopping? if
        true machining-stopped !
    then
    ;

\ Motion Post Action
\ 運動停止後的處置
: motion-post-action ( -- )
    false homing-accepted !
    false jogging-accepted !
    false machining-accepted !
    false homing-stopped !
    false jogging-stopped !
    false machining-stopped !
    false motion-stopping !
    0 motion-state !
    ." log|motion-post-action" cr
    ;

\ Is homing accepted ?
\ 是否接受 Start homing 命令 ？
: homing-accepted?  ( -- flag )
    homing-accepted @
    ;

\ Is homing stopped ?
\ Homing 模式是否已經停止 ?
: homing-stopped? ( -- flag )
    homing-stopped @
    ;


\ Is jogging accepted ?
\ 是否接受 Start jogging 命令 ？
: jogging-accepted? ( -- flag )
    jogging-accepted @
    ;

\ Is jogging stopped ?
\ Jogging 模式是否已經停止 ?
: jogging-stopped? ( -- flag )
    jogging-stopped @
    ;

\ Is machining accepted ?
\ 是否接受 Start Machining 命令 ？
: machining-accepted? ( -- flag )
    machining-accepted @
    ;

\ Is Machining stopped ?
\ Machining 模式是否已經停止 ?
: machining-stopped? ( -- flag )
    machining-stopped @
    ;

\ Motion Post Action 自動切換到 Motion Idle
: motion-auto-passed? ( -- flag )
    true
    ;


\ 宣告 SFC Step
step motion-idle
step motion-homing
step motion-jogging
step motion-machining
step motion-post-action

\ 宣告 SFC Transition
transition  homing-accepted?
transition  homing-stopped?
transition  jogging-accepted?
transition  jogging-stopped?
transition  machining-accepted?
transition  machining-stopped?
transition  motion-auto-passed?


\ SFC Link
' motion-idle           ' homing-accepted?    -->
' homing-accepted?      ' motion-homing       -->
' motion-homing         ' homing-stopped?     -->
' homing-stopped?       ' motion-post-action  -->
' motion-post-action    ' motion-auto-passed? -->
' motion-auto-passed?   ' motion-idle         -->

' motion-idle           ' jogging-accepted?   -->
' jogging-accepted?     ' motion-jogging      -->
' motion-jogging        ' jogging-stopped?    -->
' jogging-stopped?      ' motion-post-action  -->

' motion-idle           ' machining-accepted? -->
' machining-accepted?   ' motion-machining    -->
' motion-machining      ' machining-stopped?  -->
' machining-stopped?    ' motion-post-action  -->

\ Activate motion-idle step
' motion-idle +step

```
