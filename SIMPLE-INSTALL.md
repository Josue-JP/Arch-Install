__________________________________________________________________________________________________________
This page was created 
with the goal of 
providing you with all the 
essential commands for installing Arch Linux.

The idea is that if you're 
already familiar with the process, 
then you can simply just skip over 
the long explanations and focus on the commands themselves.

I also recommend reading the README.md file 
for a more detailed understanding of the commands.

### Intro

- loadkeys us

- iwctl

- ping google.com

### Partitions

- lsblk

- cfdisk /dev/sdb

Create:

EFI -- 1G  Type: EFISystem 

ROOT - 30+ Type: EFISystem 

SWAP - 8G+ Type: EFISystem 
### Formating
---------------------------------
EFI: 
- mkfs.fat -F32 /dev/sdb3
----------------------------------
ROOT: 
- cryptsetup luksFormant /dev/sdb4

- cryptsetup open /dev/sdb4 Croot

- mkfs.ext4 /dev/mapper/Croot
----------------------------------
SWAP: 
- mkswap /dev/sdb5    
---------------------------------
### Mounting

- mount /dev/mapper/Croot /mnt

- mkdir /mnt/boot

- mount /dev/sdb3 /mnt/boot

- swapon /dev/sdb5

### Faster Installs

- vim /etc/pacman.conf

Uncomment ParallelDownloads

This is to see how many threads your pc has
- nproc
OR
- grep -c processor /proc/cpuinfo

### Packages To Install

If you have an amd processor then change intel-ucode to amd-ucode:
- pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware intel-ucode sudo
Optional:
- pacstrap /mnt git neofetch vim 

Check whether you have amd or intel: 
- cat /proc/cpuinfo | grep -i 'vendor_id'
OR
- lscpu | grep Vendor


### Generate fstab file

- genfstab -U /mnt > /mnt/etc/fstab

### Enter arch

- arch-chroot /mnt

### Timezone and clock

- ls /usr/share/zoneinfo

- ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

- hwclock --systohc

- date

### Set locale

- vim /etc/locale.gen
Uncomment: 
en_US.UTF-8 UTF-8

- locale-gen

- vim /etc/locale.conf
Type: 
LANG=en_US.UTF-8

### Hostname 

- vim /etc/hostname

### Passwords 

For Root: 
- passwd

Custom user: 
- visudo 
Uncomment "%wheel ALL=(ALL:ALL) ALL"

- useradd -m -G wheel -s /bin/bash User1

- passwd User1

### Configure initcpio & Grub

In the HOOKS section add ecrypt & lvm2 after the word "block"
- vim /etc/mkinitcpio.conf

- mkinitcpio -P 
-----------------------------------------------------------------------------
- grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

- blkid -o value -s UUID /dev/sdb4 >> /etc/default/grub

- blkid -o value -s UUID /dev/mapper/Croot >> /etc/default/grub

- vim /etc/default/grub

Copy the two UUID's that are at the bottom of the file to the top of the file, 
after the word "quiet",where it says: 
"GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet""

Also make sure that everything is in the same line and that both UUID's,
have a name unto them. 
EX: 
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=4d8a927c-93b7-4bfa-a2b6-d9b497ff6a78:Croot root=UUID=8fada6ed-545a-4021-9c21-c3c9b847593e"

make sure to give the following names to the UUID's
1. cryptdevice=UUID=
2. :Croot
3. root=UUID=

Now run: 
- grub-mkconfig -o /boot/grub/grub.cfg
-----------------------------------------------------------------------------

### On Boot Programs

- systemctl enable NetworkManager

- systemctl enable bluetooth

### THE END

- exit

- umount -lR /mnt

- shutdown now

#####################################################################
#    WHILE THE COMPUTER IS IN SHUTDOWN MODE UNPLUG THE USB STICK    #
#####################################################################

props to you for making it this far, but as you can see Arch linux is basically a black void right now. 
What you need to do now is to choose a way to display your files, applications, and programs.

Below are documents that I have written or which are in progress, 
that handle the display and management of files, applications, and programs:

----Hyprland (In Progress)
----KDE plasma (In Progress)

For more information about window managers or desktop environments please refer to other trusted sources.
__________________________________________________________________________________________________________
