# JavaScript API

The Botnana Control API can be found here. [npm registry](https://www.npmjs.com/) Downloaded

It's all about you using nodejs. `package.json` Add to this dependency:

    botnana: '*'

and included in the program.

    var botnana = require("botnana");

`botnana` Functional libraries can also be executed in browsers.

## Example:

The following example connects to Botnana Control over WebSocket and retrieves its version:

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

## Start, Ready, and Poll

Call `botnana.start(ip_address)` to connect to Botnana Control at `ip_address`. The `ready` event indicates that the connection is established and requests can be sent. `botnana.start` also starts the polling mechanism, which processes Botnana Control responses every 100 ms.

    botnana.once("ready", function() {
        // work 1
        // work 2
        // ...
    });

    botnana.start("ws://192.168.7.2:3012");

## Data Event API

The Botnana Control return file is formatted as

    tag1|value1|tag2|value2...

It's a function. `botnana.handle_response(response)` After processing, tags are converted into events. The data event API can be used to process these events. For example:

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

If only one incident is dealt with, use it. `once`For example:

    botnana.once("dout.1.2", function (value) {
        console.log("dout 1 of slave 2 is " + value);
    });

Times can also be used to specify the number of processing events. For example:

    botnana.times("dout.1.2", function (value) {
        console.log("dout 1 of slave 2 is " + value);
    }, 5);

## Version API

Example:

    botnana.on("version", function (version) {
        console.log("version: " + version);
    });
    botnana.once("ready", function() {
        botnana.version.get();
    })

## Configuration API

Programs can use the Configuration API to handle configuration files.

### Modify Configuration Parameters

Modifying the parameter settings will not immediately save the settings to the parameter configuration file, nor will it affect the parameters currently used by each device.

Example: Modify the method of returning slave 1 to the origin of the configuration file.

    botnana.config.set_slave({
      position: 1,
      tag: "homing_method",
      value: 33
    });

Modified configuration content will not be stored in the configuration file immediately, nor will it affect the parameters currently used by EtherCAT slaves.

### Save Configuration Parameters

Storage settings parameter will instantly store the settings value in the parameter configuration file, but will not affect the parameters currently used by each device.

The system will use a new setting once the switch is restarted.

Example: Requires storage configuration:

    botnana.config.save();

## Slave API

### Read Slave Status

It's a function. `get()` It can be used to obtain Slave status.

        botnana.ethercat.slave(1).get();

Because it's a function. `botnana.handle_response(response)` After processing the return information, the corresponding events are generated.
Event API can be used to process these returns.

Example: How to get the motor drive back to the original location in the first Slave position

    botnana.on("homing_method.1", function (homing_method) {
        console.log("result: " + homing_method);
    });
    botnana.once("ready", function() {
        botnana.ethercat.slave(1).get();
    });

### Configure a Motor Drive

The command format for setting the motor drive parameter is

    botnana.ethercat.slave(i).set(tag, value);

Example: How to set the motor back to the starting point

    botnana.ethercat.slave(1).set("homgin_method", 33);

### Reset a Motor Drive

    botnana.ethercat.slave(i).reset_fault();

### Set and Read I/O Status

Example: Outputs and inputs of digital and analog IO:

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

Example: Some slave's Analog IO must be able to output:

    botnana.ethercat.slave(1).disable_aout(5);
    botnana.ethercat.slave(1).enable_aout(5);
    botnana.ethercat.slave(1).disable_ain(2);
    botnana.ethercat.slave(1).enable_ain(2);

## Real-time Programming API

One of the simplest real-time programs:

    var p1 = new botnana.Program("p1");
    p1.deploy();
    // Execute the program when the deployment is complete.
    botnana.once("deployed", function() {
        p1.run();
    })

* `deploy()`: Deploy the program to a real-time task. When deployment completes, the `deployed` event is emitted.
* `run()`: Execute the programs already deployed.

Remove all programs that have been deployed:

    botnana.empty();

Example: When executing the program, the single axis returns to Home and then moves to position 30000:

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

Example: When executed, the two axes return to Home and then move to position. (30000,40000) The program:

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

The following program uses `until_target_reached()` to start the first motor drive and then the second:

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
