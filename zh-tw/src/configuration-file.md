## 設定檔

Botnana Control Motion Server 的設定檔位於 /opt/mapacode/botnana-control/config/motion.toml 。

設定檔使用 [Toml](https://github.com/toml-lang/toml) 格式。說明如下。

### File section

* _spec_version_ 欄位：列出使用的設定檔格式的版本，本文件目前的版本是 0.0.1。

### Slave section

可以有多個 slaves，因此使用 `[[slave]]`。每個 slave 有以下欄位。

* _position_: slave 的位置。
* _vendor_id_
* _product_code_
* _homing_method_
* _home_offset_
* _homing_speed_1_
* _homing_speed_2_
* _homing_acceleration_
* _profile_velocity_
* _profile_acceleration_
* _profile_deceleration_

### Example of a motion.toml

    [file]
      spec_version = "0.0.1"
    [[slave]]
      position = 1
      vendor_id = 6661
      product_code = 22049
      homing_method = 33
      home_offset = 0
      homing_speed_1 = 50
      homing_speed_2 = 5
      homing_acceleration = 8
      profile_velocity = 8000
      profile_acceleration = 9000
      profile_deceleration = 9000
