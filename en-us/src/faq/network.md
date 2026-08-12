## Network Configuration

Use `connmanctl` command for settings. Here are some common settings needs; for detailed explanations, refer to [connmanctl - ConnMan CLI](https://manpages.debian.org/bookworm/connman/connmanctl.1.en.html).

### Wi-Fi Settings

**Check the status of the wireless NIC**

After installing the wireless network card, use `sudo connmanctl technologies` to check the status of the wireless card.
Command output status follows:

```
debian@arm:~$ sudo connmanctl technologies
[sudo] password for debian: // Enter temppwd
/net/connman/technology/wifi
  Name = WiFi
  Type = wifi
  Powered = False
  Connected = False
  Tethering = False
/net/connman/technology/gadget
  Name = Gadget
  Type = gadget
  Powered = False
  Connected = False
  Tethering = False
```

If the wireless NIC is properly installed, you should be able to see information under `/net/connman/technology/wifi`.
Note that `Powered = False` indicates that WiFi must be powered on first, which can be done as follows:

```
debian@arm:~$ sudo connmanctl enable wifi
Enabled wifi
```

Success displays `Enabled wifi`. You can also run `sudo connmanctl technologies` again to confirm the status.

This connection is via DHCP; for using a specified IP, see the following section.


**Configure the connection**

First, go to the settings screen and enter `sudo connmanctl`, which will appear with the prompt `connmanctl>`.

```
debian@arm:~$ sudo connmanctl
connmanctl>
```

List the available network services. This example uses Mapacode's network:

```
connmanctl> services
    Mapacode_5G          wifi_1c5f2bc586d1_4d617061636f64655f3547_managed_psk
    Mapacode             wifi_1c5f2bc586d1_4d617061636f6465_managed_psk
```

Enable the connection agent:

```
connmanctl> agent on
Agent registered
```

Connect to the SSID named `Mapacode`:


```
connmanctl> connect wifi_1c5f2bc586d1_ // Try filling in with the tab key
connmanctl> connect wifi_1c5f2bc586d1_4d617061636f6465_managed_psk
Agent RequestInput wifi_1c5f2bc586d1_4d617061636f6465_managed_psk
  Passphrase = [ Type=psk, Requirement=mandatory, Alternates=[ WPS ] ]
  WPS = [ Type=wpspin, Requirement=alternate ]
Passphrase?
```

Enter the password and wait for `Connected wifi_1c5f2bc586d1_4d617061636f6465_managed_psk` to appear.

```
Passphrase? 062970665 // Input password
Connected wifi_1c5f2bc586d1_4d617061636f6465_managed_psk
connmanctl>
```

Enter `exit` to leave the configuration interface:

```
connmanctl> exit
debian@arm:~$
```

### Wired Network Settings

First connect the Ethernet cable, and use `sudo connmanctl technologies` to check the connection status. You should see the `/net/connman/technology/ethernet` item.

```
debian@Q190G4:~$ sudo connmanctl technologies
[sudo] password for debian: // Enter temppwd
/net/connman/technology/ethernet
  Name = Wired
  Type = ethernet
  Powered = True
  Connected = False
  Tethering = False
```

**Configure the connection**

First, go to the settings screen and enter `sudo connmanctl`, which will appear with the prompt `connmanctl>`.

```
debian@arm:~$ sudo connmanctl
connmanctl>
```

List of available network nodes:

```
connmanctl> services
*A  Wired                ethernet_00ecacce3a79_cable
connmanctl>
```

Enable the connection agent:

```
connmanctl> agent on
Agent registered
```

Connect to the wired service:

```
connmanctl> connect ethernet_00ecacce3a79_cable
Connected ethernet_00ecacce3a79_cable
```

The wired connection is now established.

This connection is via DHCP. For use with a specified IP, see the following section.

### Assign a Static IP Address

Example configuration:

* service : `ethernet_00ecacce3a79_cable`
* ip      : 192.168.7.2
* netmask : 255.255.255.0
* gateway : 192.168.7.1


```
Command format:
connmanctl config <service> --ipv4 manual <ip address> <netmask> <gateway>

Example:
sudo connmanctl config  ethernet_00ecacce3a79_cable --ipv4 manual 192.168.7.2 255.255.255.0 192.168.7.1
```

### Assign an IP Address Automatically

Example configuration:

service: `ethernet_00ecacce3a79_cable`


```
Command format:
connmanctl config <service> --ipv4 dhcp

Example:
sudo connmanctl config  ethernet_00ecacce3a79_cable --ipv4 dhcp
```
