
  ARCH-INSTALL

Download Arch on a UEFI machine with encryption using this guide
You do need to do some manual configuration first as the arch installation is a little more personal to your own situation.


# Intro
Firstly, set your keylayout. If you have a us keylayout, just copy the following command (for more info https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration)
```bash
loadkeys us
```
Next start to connect to wifi with the following command (for more info: https://wiki.archlinux.org/title/Iwd)
```bash
iwctl
```
Confirm the connection by pinging any website, for ex: 
```bash
ping google.com
```

# Create partitions 
Firstly, check all the disks on your pc/laptop, and choose the disk that you want to partition.
```bash
lsblk
```

Then run the cfdisk command and the disk you will be partitioning.
```bash
cfdisk /dev/sdb
```
(make sure you put the /dev/ and then the disk)
*I will be partitioning "sdb" but for you it might be "mmcblk0", "sdX" or "nvme0n1"*


