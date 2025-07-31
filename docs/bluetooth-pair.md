[Stackoverflow Answer](https://unix.stackexchange.com/a/255510)

# Why does this happen?
Basically, when you pair your device, your Bluetooth service generates a unique set of pairing keys. First, your computer stores the Bluetooth device's MAC address and pairing key. Second, your Bluetooth device stores your computer's MAC address and the matching key. This usually works fine, but the MAC address for your Bluetooth port will be the same on both Linux and Windows (it is set on the hardware level). Thus, when you re-pair the device in Windows or Linux and it generates a new key, that key overwrites the previously stored key on the Bluetooth device. Windows overwrites the Linux key and vice versa.

Bluetooth LE Devices: These may pair differently. I haven't investigated myself, but this may help Dual Boot Bluetooth LE (low energy) device pairing

# How to fix
Using the instructions below, we'll first pair your Bluetooth devices with Ubuntu/Linux Mint, and then we'll pair Windows. Then we'll go back into our Linux system and copy the Windows-generated pairing key(s) into our Linux system.


1. Pair all devices w/ Mint/Ubuntu
2. Pair all devices w/ Windows
3. Copy your Windows pairing keys in one of two ways:
    - Use psexec -s -i regedit.exe from Windows (harder). You need psexec as normal regedit doesn't have enough permissions to show this values.
        1. Go to "Device & Printers" in Control Panel and go to your Bluetooth device's properties. Then, in the Bluetooth section, you can find the unique identifier. Copy that (you will need it later). Note: on newer versions of windows the route to the device's properties is to go through Settings -> Bluetooth & devices -> Devices -> More devices and printer settings
        1. Download PsExec from http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx.
        1. Unzip the zip you downloaded and open a cmd window with elevated privileges. (Click the Start menu, search for cmd, then right-click the CMD and click "Run as Administrator".)
        1. cd into the folder where you unzipped your download.
        1. Run psexec -s -i regedit.exe
        1. Navigate to find the keys at HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\BTHPORT\Parameters\Keys.  If there is no CurrentControlSet, try ControlSet001.
        1. You should see a few keys labels with the MAC addresses - write down the MAC address associated with the unique identifier you copied before. Note: If there are no keys visible after pairing, you likely need to add permissions to read (right click -> permissions) Keys\
        1. For convenience export it as a text file. click file -> export -> as text and save it to a shared partition/cloud.

    - Use chntpw from your Linux distro (easier). Start in a terminal then:
        1. yay chntpw
        1. Mount your Windows system drive in read-write mode
            - To find the drive use sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL. Depending on how your dual boot is setup its usually the first ntfs partition on the drive with /boot/efi. Note the NAME.
            - sudo mkdir /mnt/c
            - sudo mount --read-only /dev/<NAME> /mnt/c
            - To safely unmount the drive sudo umount /mnt/c
                - If you need to try a different drive or when finished all these instructions
        1. cd /[WindowsSystemDrive]/Windows/System32/config
            - on Windows 10 the root folder is "Windows", on Windows 7 it is "WINDOWS"
        1. chntpw -e SYSTEM opens a console
        1. Run these commands in that console:
```bash
    > # If there is no ControlSet001, then try CurrentControlSet
    > # on Windows 7, "services" below is lowercased.
    > cd ControlSet001\Services\BTHPORT\Parameters\Keys
    > ls
    # shows you your Bluetooth port's MAC address
    Node has 1 subkeys and 0 values
      key name
      <aa1122334455>
    > cd aa1122334455  # cd into the folder
    > ls
    # lists the existing devices' MAC addresses
    Node has 0 subkeys and 1 values
      size     type            value name             [value if type DWORD]
        16  REG_BINARY        <001f20eb4c9a>
    > # Get the value of the REG_BINARY entry
    > hex 001f20eb4c9a
    => :00000 XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX ...ignore..chars..
    # ^ the XXs are the pairing key
```

        1.  Make a note of which Bluetooth device MAC address matches which pairing key. The Mint/Ubuntu one won't need the spaces in-between.  Ignore the :00000.
1. Go back to Linux (if not in Linux) and add our Windows key to our Linux config entries. Just note that the Bluetooth port's MAC address is formatted differently when moving from Windows to Linux - referenced as aa1122334455 in Windows in my example above. The Linux version will be in all caps and punctuated by ':' after every two characters - for example AA:11:22:33:44:55.  Based on your version of Linux, you can do one of these:
    - Before Mint 18/16.04 you could do this:
        1. `sudo edit /var/lib/bluetooth/[MAC address of Bluetooth]/linkkeys` - [the MAC address of Bluetooth] should be the only folder in that Bluetooth folder.
        2.  This file should look something like this:

```bash
[Bluetooth MAC]   [Pairing key]                 [digits in pin]  [0]
AA:11:22:33:44:55 XXXXXXXXxxXXxXxXXXXXXxxXXXXXxXxX 5 0
00:1D:D8:3A:33:83 XXXXXXXXxxXXxXxXXXXXXxxXXXXXxXxX 4 0
```
        3. Change the linux pairing key to the Windows one minus the spaces
