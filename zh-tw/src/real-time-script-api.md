## 前言

Botnana Control 在其 real-time event loop 中使用了 Forth VM 以滿足更複雜的程式需求。透過 Forth 執行的命令會立刻影響裝置的行為。

文件網址:

[https://botnana.github.io/botnana-book/real-time-script-api.html](https://botnana.github.io/botnana-book/real-time-script-api.html)

---
## 指令集

除了標準的 Forth 指令，Botnana Control 增加了以下 Forth 指令集。

- [基本指令集](./host-primitives.md)
- [EtherCAT 指令集](./ethercat-primitives.md)
- [EtherCAT Drive 指令集](./ethercat-drive-primitives.md)
- [EtherCAT IO 指令集](./ethercat-io-primitives.md)
- [EtherCAT UART 指令集](./ethercat-uart-primitives.md)
- [EtherCAT Encoder 指令集](./ethercat-encoder-primitives.md)
- [EtherCAT Gateway 指令集](./ethercat-gateway-primitives.md)
- [軸組 Axis Group 指令集](./axis-group.md)   