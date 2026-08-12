## Configuration File

The Botnana Control Motion Server configuration file is located at `/opt/mapacode/botnana-control/config/motion.toml`.

Configuration files use the [TOML](https://github.com/toml-lang/toml) format.

### File Section

* _spec_version_ field: lists the version of the configuration file being used, the current version of this document is 0.0.1.

### Slave Section

Multiple slaves are possible, so use `[[slave]]`. Each slave has the following fields.

* _position_: position of the slave.
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
