# ARCH-INSTALL

Download Arch on a UEFI machine with encryption while dual booting using this guide.

This is a manual configuration guide as the arch installation should be personal to you.
### Excellent sources:
- https://wiki.archlinux.org/title/Installation_guide
- https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system
- https://www.youtube.com/watch?v=NxqU1G8hKWk
- https://www.youtube.com/watch?v=kXqk91R4RwU
- https://comfy.guide/client/luks/

If you are going to use the sources listed instead of this tutorial, I encourage you to start with the arch wiki page, but if it is to much for you, then just refer to the two youtube videos(*yes both of them, as one is only for dual boothing without encryption, and the other video is without dual booting but with encryption*).
# Intro
Firstly, set your keylayout. If you have a us keylayout, just copy the following command 

(for more info https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration)
```bash
loadkeys us
```
Next start to connect to wifi with the following command 

(for more info: https://wiki.archlinux.org/title/Iwd)
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

Make sure to write the changes and quit

# Format partitions
#### For sdb3 sdb4 and sdb5 change them to whatever is your EFI, ROOT, and SWAP partition.
- EFI - For this partition type the following command:
```bash
mkfs.fat -F32 /dev/sdb3
```
- ROOT - For this partition the following must be done:

Type and enter in a custom password for the encrypted partition.
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
# Edit package manager
In order to get faster download speeds for your installation, type: 
```bash
nano /etc/pacman.conf
```
Uncomment #ParallelDownloads = 5 and make the number change according to the number of threads your pc has

To see how many threads your pc has exit the editor by doing ctrl+x and type: 
```bash
nproc
```
or 
```bash
grep -c processor /proc/cpuinfo
```
After uncommenting ParallelDownloads and setting a number, remember to save and exit out of nano by doing ctrl+o [enter] and ctrl+x

What enabling ParrallelDownloads does is it allows multiple downloads to occur at the same time
# Packages to install 
I would reccomend to install all of these, but if you are using an amd processor then change intel-ucode to amd-ucode
```bash
pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware intel-ucode sudo  
```
Optional installs example:
```bash
pacstrap /mnt git neofetch vim 
```
# Generate fstab file
```bash
genfstab -U  /mnt > /mnt/etc/fstab
```
# Enter as root into arch
```bash
arch-chroot /mnt
```
You've successfully entered into your OS!!
# Set timezone & clock
To see the available timezones:
```bash
ls /usr/share/zoneinfo
```
To set a timezone 

(Change /America/Los_Angeles to your timezone):
```bash
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
```
To set the hardware clock: 
```bash
hwclock --systohc
```
Do the following to confirm the date:
```bash
date
```
### Set the locale
Uncomment your locale in this file:

Ex:en_US.UTF-8 UTF-8
```bash
nano /etc/locale.gen
```
remember to save and exit out of nano by doing ctrl+o [enter] and ctrl+x, now type: 
```bash
locale-gen
```
To set your language, edit and type "LANG=en_US.UTF-8" in the following file: 
```bash
nano /etc/locale.conf
```
# Change Hostname 
Edit and enter name for your hostname in the following file
```bash
nano /etc/hostname
```
*If you don't care about this just type Arch or skip this step*
# Passwords
### Root
To change the password for Root, run this command and enter a password:
```bash
passwd
```
### Custom users
*A Custom user is a daily used user*

To allow the wheel group to have root privileges:
```bash
EDITOR=nano visudo 
```
*^Uncomment "%wheel ALL=(ALL:ALL) ALL"^*

Save & exit the file and type the following, with the last word being whatever you want the custom user's name to be: 
```bash
useradd -m -G wheel -s /bin/bash User1
```
Next add a password to that user:
```bash
passwd User1
```
# Configure initcpio & Grub
### Initcpio 
Edit this file by going to the HOOKS section and adding ecrypt & lvm2 after the word "block"
```bash
nano /etc/mkinitcpio.conf
```
After that save & exit the file and run this command: 
```bash
mkinitcpio -P 
```
### Grub with encrypted setup
Install:
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```
#### Encryption with Grub
Run this command to see the UUID of your encrypted partition:
```bash
blkid -o value -s UUID /dev/sdb4
```
Now send the UUID of sdb4(encrypted) and Croot(decrypted) to grub 
```bash
blkid -o value -s UUID /dev/sdb4 >> /etc/default/grub
```
```bash
blkid -o value -s UUID /dev/mapper/Croot >> /etc/default/grub
```
Notice that on the second command /dev/sdb4 was changed to /dev/mapper/Croot, change those paths to the your own devices names.

Now type
```bash
nano /etc/default/grub
```
#### PLEASE PROCEED WITH CAUTION, AND BE SURE THAT WHAT YOU ARE DOING IS CORRECT 

#### IF YOU ARE NOT SURE ON WHETHER YOU ARE DOING IT RIGHT, PLEASE LOOK UP THE ISSUE ON TRUSTED SOURCES
#### FOR MORE DETAIL ABOUT THE NEXT PROCESS, REFER TO THE "GRUB Setup" SECTION OF THIS LINK (https://comfy.guide/client/luks/)

Step 1 - In this file scroll down to the very bottom and look for the UUID of the encrypted and decrypted device

Ex: 

4d8a927c-93b7-4bfa-a2b6-d9b497ff6a78

8fada6ed-545a-4021-9c21-c3c9b847593e

That is an example of what the two UUID's will look like at the bottom of your file. Remember that the top UUID is the encrypted device, and that the bottom one is the decrypted device 

Step 2 - copy the two UUID's to the top of the file, after the word "quiet", where it says "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"" 

The line should now look something like this Ex:

GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet 4d8a927c-93b7-4bfa-a2b6-d9b497ff6a78 8fada6ed-545a-4021-9c21-c3c9b847593e"

Step 3 - Define the name's for each UUID

Ex:

GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=4d8a927c-93b7-4bfa-a2b6-d9b497ff6a78:Croot root=UUID=8fada6ed-545a-4021-9c21-c3c9b847593e"

Notice how these were added 
- cryptdevice=UUID=
- :Croot
- root=UUID=.

Remember to save and exit out of nano by doing ctrl+o [enter] and ctrl+x

Now you can run the following: 
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```
# On start programs
Normally applications would not run at the start of powering on your pc/laptop, but when using "systemctl enable [The program you choose]" it them allows for that program to run at start

Recommendation: 
```bash
system enable NetworkManager
```
```bash
systemctl enable bluetooth
```
Remember that Linux is case-sensitive
# THE END 
You can now exit with the following commands:
```bash
exit
```
```bash
umount -lR /mnt
```
```bash
shutdown now
```
#####################################################################
#### WHILE THE COMPUTER IS IN SHUTDOWN MODE UNPLUG THE USB STICK
#####################################################################

After your computer shutsdown, you can now restart your pc/laptop.


If you can see the Grub menu at startup then that most likely means that you have successfully installed Arch-Linux/GNU on your pc/laptop while dual booting!!

As you can see chooseing Arch Linux from the grub menu will prompt you with a password to login into the decrypted device, and later it will ask for a user login with a password.

### What to do after?
First of all, props to you for making it this far but as you can see, Arch linux is basically a black void right now. What you need to do is to choose a way to display your files, applications, and programs.

Below are documents I have written that handle the display and management of files, applications, and programs:
- Hyprland
- KDE plasma

For more information about window managers or desktop environments please refer to other trusted sources.




