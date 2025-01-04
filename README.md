  ARCH-INSTALL

Download Arch on a UEFI machine with encryption using this guide
You do need to do some manual configuration first as the arch installation is a little more personal to your own situation.


# Section 1
Firstly, set your keylayout. If you have a us keylayout, just copy the following command
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
Check partitions
```bash
lsblk
```
<small>This is small text</small>




