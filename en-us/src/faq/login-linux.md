# Login to the Linux system


--------------------
### Login

Connect the BN-B3A Type-C (OTG) port to a computer's USB port with a Type-C cable, then connect over SSH:

    ssh debian@192.168.7.2

The password is `temppwd`.

The following command grants an unrestricted root shell and requires an
authorized administrator. Prefer an exact `sudo <command>` where the procedure
provides one; use a root shell only for an approved service task, and exit it
when finished:

    sudo su
