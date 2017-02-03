## Configuration File

Botnana Control Motion Server's configuration file is placed at: 
`/opt/mapacode/botnana-control/config/motion.toml`

The config file uses [Toml](https://github.com/toml-lang/toml) format.

### File section

* _spec_version_ column: Prints the version number of the config file, 
the current version is 0.0.1.

### Slave section

Multiple slaves can be owned, hence use `[[slave]]`. Every slave has the following columns:

* _position_: Position of slave.
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
