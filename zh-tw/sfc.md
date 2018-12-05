## 順序功能流程指令

順序功能流程圖 Sequential Function Chart (SFC) 是 PLC 五種語言中的一種，是一種圖形程式語言。它的主要成份有：

* 步驟 (Step) 及其相關的動作。
* 轉態 (Transition) 及其相關的邏輯條件。
* 步驟及轉換之間的連結。

Botnana Control 提供了支援順序功能流程圖的指令集，可以把 Forth 指令轉變成順序功能流程圖中的「步驟」及「轉態」，並建立步驟及轉態之間的連結。

此外，Botnana Control 內建了一個執行順序功能流程圖的引擎，並且指派了多工系統中的一個 Task 負責執行這個引擎。這個 Task 會在每個控制週期執行以下運算：

    SFC Engine:

        +-----------+
        |           |
        |           v
        |   +---------------------+
        |   | pause               | CPU 控制權轉給下一 Task。
        |   +---------------------+
        |           |
        |           v 下一個週期時，控制權會再回到這個 Task。
        |   +----------------------+
        |   | execute_active_steps | 執行所有 active 的步驟。
        |   +----------------------+
        |           |
        |           v
        |   +----------------------------+
        |   | execute_active_transitions | 執行所有 active 的轉態。
        |   +----------------------------+
        |           |
        |           v
        |   +---------------+
        |   | update_states | 依轉態的結果，更新步驟的 active 狀態。
        |   +---------------+
        |           |
        +-----------+


以下以紅綠燈為例：

         r2g        g2y         y2r
    red -+-> green -+-> yellow -+-
     ^                           |
     |                           |
     -----------------------------

### 步驟 (Step)

red、green、yellow 分別是紅、綠、黃三個步驟。以下定義了紅黃綠三種步驟的相關動作。在此動作只是印出 r、g、y 三個字母。

    : red ( - )  ." r" ;
    : green ( - )  ." g" ;
    : yellow ( - )  ." y" ;

以 step 指令宣告 red、green、yellow 是順序流程圖中的步驟。

    step red
    step green
    step yellow

執行步驟動作的指令不需要堆疊上的參數，也不應產生資料到堆疊上。指令 `step` 會在 Botnana Control 內建的 SFC 引擎中建立一個和其後指令同名的步驟。並使得當這個步驟為 active 時，會不斷執行此一指令。

### 啟用 (Activate)：

一個順序狀態流程圖要能運作，至少有一個 active 的步驟。指令 `+step` 會啟用堆疊上的「令牌」對應的步驟，使其 active。以下敘述啟用了步驟 red。

    ' red  +step

### 轉態 (Transition)

r2g、g2y、y2r 分別是紅轉綠、綠轉黃、黃轉紅三種轉態。以下定義了三個轉態的相關邏輯條件。在此條件都是假，也就是不會轉態。

    : r2g ( - t )  false ;
    : g2y ( - t )  false ;
    : y2r ( - t )  false ;

以 transition 指令宣告 r2g、g2y、y2r 是順序流程圖中的轉態。

    transition r2g
    transition g2y
    transition y2r

執行轉態邏輯條件的指令不需要堆疊上的參數，但會在堆疊上產生一對應轉態條件的布林值。指令 `transition` 會在 Botnana Control 內建的 SFC 引擎中建立一個和其後指令同名的轉態。並在引擎運轉，當這個轉態前**所有**的步驟都為 active 時，執行此一條件指令，並檢查這指令留在堆疊上的數值。如果數值為真，就會使得轉態之前的步驟不再 active，並使得轉態後的步驟變成 active。

### 連結

步驟 red 連結到轉態 r2g，轉態 r2g 又連結到步驟 green。指令 `-->` 會從堆疊上取得步驟或轉態的「令牌 (execution token)，一個代表指令的數字，建立令牌所代表的步驟及轉態之間的連結。在 Forth 使用 `'` 可以取得其後指令的令牌。 以下程式建立了上圖中的連結。

    ' red  ' r2g  -->
    ' r2g  ' green  -->
    ' green  ' g2y  -->
    ' g2y  ' yellow  -->
    ' yellow  ' y2r  -->
    ' y2r  ' red  -->

### 平行 AND 結構

順序狀態流程有所有的平行處理的結構，或稱 AND 結構，如下圖，當轉態 t1 發生時，步驟 B 和步驟 C 都會 active。

          ||-> B -->||
       t1 ||        || t2     t3
    A -+--||-> C -->||-+-> D -+-
    ^                          |
    |                          |
    ----------------------------

以下程式建立上圖中的流程圖。

    step A
    step B
    step C
    step D

    ' A  +step

    transition t1
    transition t2
    transition t3

    ' A  ' t1  -->
    ' t1  ' B  -->
    ' t1  ' C  -->
    ' B  ' t2  -->
    ' C  ' t2  -->
    ' t2  ' D  -->
    ' D  ' t3  -->
    ' t3  ' A  -->

### 選擇 OR 結構

順序狀態流程有多選一的結構，或稱 OR 結構，如下圖，當步驟 A 為 active 時，若轉態 t1 為真，B 會在下一週期變為 active。若 t2 為真，則 C 在下一個週期變為 active。通常會設計使得 t1 和 t2 不會同時會真，達到二選一的目的。要注意如果 t1 和 t2 有可能同時為真，則 B 和 C 同時會 active，行為會類似之前的 AND 平行結構，但如果 t3 和 t4 不同時為真，則 D 可能由 t3 啟用一次，之後又被 t4 啟用一次，這樣的行為會變得難以分析。因此應避免 t1 和 t2 同時為真的設計。

          t1     t3
        |-+-> B -+->|
        | t2     t4 |       t5
    A --|-+-> C -+->|--> D -+-
    ^                        |
    |                        |
    --------------------------

以下程式建立上圖中的流程圖。

    step A
    step B
    step C
    step D

    ' A +step

    transition t1
    transition t2
    transition t3
    transition t4
    transition t5

    ' A  ' t1  -->
    ' A  ' t2  -->
    ' t1  ' B  -->
    ' t2  ' C  -->
    ' B  ' t3  -->
    ' C  ' t4  -->
    ' t3  ' D  -->
    ' t4  ' D  -->
    ' D  ' t5  -->
    ' t5  ' A  -->

### 本節指令集

| 指令 | 堆疊效果及指令說明                        | 口語唸法 |
|-----|----------------------------------------|--------|
| `step <name>` | ( -- ) &emsp; 在順序狀態流程引擎中定義一個名為 `<name>` 的步驟，並指派它的動作為指令 `<name>`。當步驟 `<name>` active 時，指令 `<name>` 每個週期都會被執行一次 | step |
| `+step` | ( xt -- ) &emsp; 設令牌 xt 對應的步驟為 active 。 | plus-step |
| `transition <name>` | ( -- ) &emsp; 在順序狀態流程引擎中定義一個名為 `<name>` 的轉態，並指派它的邏輯條件為指令 `<name>`。當轉態 `<name>` 之前的**所有**的步驟都為 active 時，指令 `<name>` 會被執行。順序狀態流程引擎會檢查執行後留在堆疊上的布林值，如果為真，就會轉態至其後的步驟 | transition |
| `-->` | ( xt1 xt2 -- ) &emsp; 連結對應令牌 `xt1` 和 `xt2` 的步驟或轉態。步驟只能連結到轉態，而轉態只能連結到步驟，其他情況會產生錯誤訊息。 | link-to |
