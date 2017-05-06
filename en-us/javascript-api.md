# Javascript API

Botnana Control API can be downloaded at [npm registry](https://www.npmjs.com/).

While using nodejs, add the following dependency in your `package.json`.

    botnana: '*'

Then import the package into your program:

    var botnana = require("botnana");

`botnana` package can also be used in a browser.

## Examples

Following example uses Websocket to connect to Botnana Control, 
then obtains the version of Botnana Control:

    var botnana = require("botnana");

    botnana.on("version", function(version) {
        console.log("version: " + version);
    })

    botnana.once("ready", function() {
        botnana.version.get();
    });

    // Start communicating with Botnana Control at 'ws://192.168.7.2:3012'.
    // If the programm is running on a Botnana Control board, IP address should
    // be 'ws://localhost:3012'.
    botnana.start('ws://192.168.7.2:3012');

## Start、Ready and Poll

The program connects to Botnana Control at `ip_address` using `botnana.start(ip_address)`. 
Event `ready` means you have connected to Botnana Control and can start processing request.
`botnana.start` will automatically start polling Botnana Control every 100 ms.

    botnana.once("ready", function() {
        // work 1 //工作 1
        // work 2
        // ...
    });

    botnana.start("ws://192.168.7.2:3012");

## Data Event API

Botnana Control's response format:

    tag1|value1|tag2|value2...

After processing by `botnana.handle_response(response)`, tags convert to events.
Data Event API can be used to process these events. e.g.

    botnana.on("version", function(version) {
        console.log("version: " + version);
    })
    botnana.on("log", function (log) {
        console.log("log: " + log);
    });
    botnana.on("error", function (err) {
        console.log("err: " + err);
    });
    botnana.on("homing_method.3", function (value) {
        console.log("Homing method of slave 3 is " + result);
    });
    botnana.on("dout.1.2", function (value) {
        console.log("dout 1 of slave 2 is " + value);
    });

To only process the event once, use `once`. e.g.

    botnana.once("dout.1.2", function (value) {
        console.log("dout 1 of slave 2 is " + value);
    });

Or use `times` to specify the number of times to process the event. e.g.

    botnana.times("dout.1.2", function (value) {
        console.log("dout 1 of slave 2 is " + value);
    }, 5);

## Version API

e.g.

    botnana.on("version", function (version) {
        console.log("version: " + version);        
    });
    botnana.once("ready", function() {
        botnana.version.get();
    })

## Configuration API

Configuration API can process the configuration file.

### Altering the configuration //修改設定參數

Edits done to the configuration will not immediately save, 
and will not affect devices in use.
//修改設定參數並不會立刻將設定值儲存至參數設定檔，
也不會影響到各裝置目前使用的參數。

e.g. Altering slave 1's homing method within the configuration file. 
//範例：修改 configuration 檔中 slave 1 的回歸原點方法。

    botnana.config.set_slave({
      position: 1,
      tag: "homing_method",
      value: 33
    });

Edits done to the configuration file will not immediately save, 
and will not affect current EtherCAT configuration.
//修改 configuration 內容並不會立刻儲存至設定檔，
也不會影響到 EtherCAT slaves 目前使用的參數。

### Saving configuration

Saving configuration will immediately alter the configuration file, 
but will not affect parameter in use by devices.
//儲存設定參數會立刻將設定值儲存至參數設定檔，但不會影響到各裝置目前使用的參數。

Rebooting will apply new configurations. 
//關機再開後系統會使用新的設定。

e.g. Asking to save configurations: 
//範例：要求儲存 configuration：

    botnana.config.save();

## Slave API

### Reading slave info

`get()` can obtain slave info. e.g.

        botnana.ethercat.slave(1).get();

After data is processed by function `botnana.handle_response(response)`, 
response data will create a corresponding event, 
Event API can be used to process response data.
//因為經過函式 `botnana.handle_response(response)` 處理後，回傳的資訊會產生對應的事件，
可以使用 Event API 處理這些回傳的資料。

e.g. Obtaining homing method of position 1 slave
//範例：取得位於第一個 Slave 位置的馬達驅動器回原點的方式

    botnana.on("homing_method.1", function (homing_method) {
        console.log("result: " + homing_method);
    });
    botnana.once("ready", function() {
        botnana.ethercat.slave(1).get();
    });

### Configuring drive //設定馬達驅動器參數

Command to configure motor drive: //設定馬達驅動器參數的命令格式為

    botnana.ethercat.slave(i).set(tag, value);

e.g. Configuring drive's homing method: 範例：設定馬達回原點的方式

    botnana.ethercat.slave(1).set("homgin_method", 33);

### Clearing drive error //清除馬達驅動器異警

    botnana.ethercat.slave(i).reset_fault();

### Configuring and reading IO status //設定及讀取 IO 點狀態

e.g. Digital and analogue output/input //範例：數位及類比 IO 的輸出及輸入：

    botnana.on("dout.5.1", function (value) {
        console.log("dout 5 of slave 1 is " + value);
    });
    botnana.on("din.4.2", function (value) {
        console.log("din 4 of slave 5 is " + value);
    });
    botnana.on("aout.2.3", function (value) {
        console.log("aout 2 of slave 3 is " + value);
    });
    botnana.on("ain.2.4", function (value) {
        console.log("ain 2 of slave 2 is " + value );
    });
    botnana.once("ready", function() {
        botnana.ethercat.slave(1).set_dout{1, 1);
        botnana.ethercat.slave(3).set_aout(1, 30);
        botnana.ethercat.slave(1).get();
        botnana.ethercat.slave(2).get();
        botnana.ethercat.slave(3).get();
        botnana.ethercat.slave(3).get();
    });

e.g. Some slave's Analog IO is required to output致能
//範例：某些 slave 的 Analog IO 必須要輸出致能：

    botnana.ethercat.slave(1).disable_aout(5);
    botnana.ethercat.slave(1).enable_aout(5);
    botnana.ethercat.slave(1).disable_ain(2);
    botnana.ethercat.slave(1).enable_ain(2);

## Real-time Programming API

A simple real-time progrma
//一個最簡單的 real-time 程式：

    var p1 = new botnana.Program("p1");
    p1.deploy();
    //when finished deploying, execute the program // 當完成部署時執行程式。
    botnana.once("deployed", function() {
        p1.run();
    })

* `deploy()`: Deploy program to real-time thread. `deployed` even will occur when deployent completed.
//將程式部署至 real-time thread。當完成部署時，會發出事件 `deployed`。
* `run()`: Execute deployed program //執行已部署的程式。

Clear all deployed program: //清除所有已部署的程式：

    botnana.empty();

e.g. //範例：執行時會先單軸回 Home，然後再移動到位置 30000 的程式：

    var p2 = new botnana.Program("p2");
    var s1 = p2.ethercat.slave(1);
    s1.hm();
    s1.go();
    s1.pp();
    s1.move_to(30000);
    s1.go();
    p2.deploy();
    botnana.once("deployed", function() {
        p2.run();
    });

e.g. A program that will first move two axes homem then move to position (30000,40000).
//範例：執行時會先雙軸回 Home，再移動到位置 (30000,40000) 的程式：

    var p3 = new botnana.Program("p3");
    var s1 = p3.ethercat.slave(1);
    var s2 = p3.ethercat.slave(2);
    s1.hm();
    s2.hm();
    s1.go();
    s2.go();
    s1.pp();
    s2.pp();
    s1.move_to(30000);
    s2.move_to(40000);
    s1.go();
    s2.go();
    p3.deploy();
    botnana.once("deployed", function() {
        p3.run();
    });

The following program utilized `until_target_reached()` 
forcing the second axes to move after the first:
//以下程式使用 `until_target_reached()` 使得先走完第一軸再走第二軸：

    var p4 = new botnana.Program("p4");
    var s1 = p3.ethercat.slave(1);
    var s2 = p3.ethercat.slave(2);
    s1.hm();
    s2.hm();
    s1.go();
    s1.until_target_reached();
    s2.go();
    s1.pp();
    s2.pp();
    s1.move_to(30000);
    s1.go();
    s1.until_target_reached();
    s2.move_to(40000);
    s2.go();
    p4.deploy();
    botnana.once("deployed", function() {
        p4.run();
    });
