# Introduction

Botnana Control is an Industrial Ethernet EtherCAT controller’s development and learning environment. 
The goal of Botnana Control is to help users rapidly develop automation 
and IIoT (Industrial Internet of Things) applications based on Industrial Ethernet.

![Botnana Control](./botnana-a2-in-box.png)

## Applicable Field

Botnana Control can be utilized for the following applications:

* Data collection: Can be used as Remote Terminal Unit (RTU).
* Data analysis: Analyze collected data with built-in spreadsheet and Javascript.
* Motion control: Up to 32 axes can be controlled with EtherCAT through Botnana Control. 
  Currently supports Delta, Panasonic, Sanyo Denki, and Yaskawa’s EtherCAT drive,
  as well as Delta's R1-EC5621D0 1-channel pulse remote module.
  Will support Coply's EtherCAT drive.
* PLC-like control: Botnana can utilize EtherCAT 
  modules and conduct PLC-like control. Currently supports Delta and Beckhoff’s IO module.
* IIoT: Botnana Control can be integrated with client's cloud service
 or with HMI through built-in Websocket or MTConnect server.
* CNC controller.