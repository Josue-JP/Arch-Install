  ARCH-INSTALL

Download Arch on a UEFI machine with encryption while dual booting using this guide.
You do need to do manual configuration as the arch installation is personal to your situation.


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
(make sure you put the /dev/ and then the disk)
```bash
cfdisk /dev/sdb
```
*I will be partitioning "sdb" but for you it might be "mmcblk0", "sdX" or "nvme0n1"*
### The Three partitions
- EFI ----- Size: 1G, Type: EFISystem, This is the bootloader partition
- ROOT - Size: 30G+, Type: Linux filesystem, This is the actual OS
- SWAP - Size: 8G+, Type: Linux swap, This is the virtual RAM

Write the changes and quit

# Format partitions
### For sdb3 sdb4 and sdb5 change them to whatever is your EFI, ROOT, and SWAP partition
- EFI - For this partition type the following command:
```bash
mkfs.fat -F32 /dev/sdb3
```
- ROOT - For this partition the following must be done:
Type and enter in a custom password for the encrypted partition
```bash
cryptsetup luksFormant /dev/sdb4
```
Create the decrypted partition inside of the encrypted partition.
(you can change Croot to whatever you like (ex: cryptroot))
```bash
cryptsetup open /dev/sdb4 Croot
```
For the journaling-file-system ext4, run the following to format Croot:
```bash
mkfs.ext4 /dev/mapper/Croot
```
- SWAP - For this partition type the following command:
```bash
mkswap /dev/sdb5    
```
# Mounting
### Type the following:
```bash
mount /dev/mapper/Croot /mnt
```
*^Croot is the decrypted partition^*
```bash
mkdir /mnt/boot
```
```bash
mount /dev/sdb3 /mnt/boot
```
*^sdb3 is the bootloader partition^*
```bash
swapon /dev/sdb5
```
*^sdb5 is the swap partition^*







