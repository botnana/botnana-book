## Install the Windows 10 RNDIS Driver

Install the RNDIS driver before connecting a Botnana BN-B3A to Windows 10 through Type-C USB.

1. Connect the Botnana BN-B3A Type-C USB port to the computer.

1. If the following unknown device appears, uninstall it and then reinstall the RNDIS driver.

    ![](../figures/win10-unknown-device.png)

1. If a Remote NDIS or RNDIS device appears, the driver is installed. You may also choose to update it.

    ![](../figures/win10-recognized.png)

    Or:

    ![](./win10_12_got_usb_rndis_interface.png)

1. When installing the driver, select **Browse my computer for drivers**.

    ![](../figures/win10-browse-device-drivers.png)

1. Select **Let me pick from a list of available drivers on my computer**.

    ![](../figures/win10-select-from-computer.png)

1. Select **Network adapters** as the hardware type.

    ![](./win10_8_select_network_interface.png)

1. Select **Microsoft** as the manufacturer and **USB RNDIS Adapter** as the model.

    ![](./win10_9_select_rndis_drive.png)

1. Dismiss the warning message.

    ![](./win10_10_ignore_warning.png)

1. Confirm that the driver update succeeds.

    ![](./win10_11_install_rndis_ok.png)

1. In Device Manager, check for **Network adapters > USB RNDIS Adapter / Remote NDIS Device**.

    ![](../figures/win10-recognized.png)

    Or:

    ![](./win10_12_got_usb_rndis_interface.png)
