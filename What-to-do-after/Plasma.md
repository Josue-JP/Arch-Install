# KDE Plasma Full Guide
In this file, you will learn on how to install sddm (the display manager ) and KDE Plasma (the desktop environment).
I am also going to dive into autologin so that you wouldn't have you type two passwords to enter the system.

### Step 1
Run the following 
```bash
sudo pacman -S plasma-desktop konsole sddm
```
It will ask you for many options to choose, for the most part just type enter but I would reccomend 
to choose pipewire-jack instead of jack2

Now enable sddm
```bash
sudo systemctl enable --now sddm
```

You can now login into KDE Plasma by entering your user credentials in sddm.
You can stop right here and continue without setting up autologin, 
but I am going to setup autologin inside of SDDM in order for there to be 
only one one time where I in a password and not twice.

### Step 2
Make a configuration directory 
```bash
sudo mkdir /etc/sddm.conf.d
```

Make a file inside of that directory
```bash
sudo vim /etc/sddm.conf.d/autologin.conf
```

Now add the following text into that file,
and change the user according to your user
NOTE: This file is Case-Sensitive 

[Autologin]
User=user1
Session=plasma

You can now reboot
```bash
reboot
```

If you want to install other applications you can do the following
```bash
sudo pacman -S [applications that you want to install]
```



