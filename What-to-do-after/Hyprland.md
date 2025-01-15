# Hyprland Full Guide
In this file, you will learn on how to install Ly (the login manager) and Hyprland (the window tiling manager).
This tutorial was also made with the intension of installing Hyprland with nvidia hardware.


### Installing Ly 
Run the following command to refresh and update pacman which is short for package manager
```bash
sudo pacman -Syu
```

Now install ly
```bash
sudo pacman -S ly
```

Now enable it to run at start
```bash
sudo systemctl enable ly.service
```

### Installing Hyprland
Optionally you can firstly make sure that parallelDownloads is set to 4 or how many threads you have.
This is done so that you can have 4 things downloading at once, instaed of 1 or two.
You can do this by going into this file.
```bash
sudo vim /etc/pacman.conf
```
------- 
Now install the needed nvidia installs in order for Hyprland to be compatible with your hardware
```bash
sudo pacman -S nvidia nvidia-utils egl-wayland
```
------- 
You will also need to edit the /etc/mkinitcpio.conf file,
and change the MODULES section and add the following

BEFORE: MODULES = ()

AFTER: MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

-------  
Now create and edit /etc/modprobe.d/nvidia.conf and add this line

options nvidia_drm modeset=1 fbdev=1
------- 
Now rebuild the initramfs with   
```bash
sudo mkinitcpio -P
```
------- 
Now Install hyprland and needed applications
```bash
sudo pacman -S hyprland kitty firefox
```

Lastly you want to add these lines to your hyprland.conf file:
The file should be in ~/.config/hypr/hyprland.conf

env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia

-------  
Now you can run hyprland
```bash
hyprland
```

As you can see, Hyprland comes super bare-bone, there is no taskbar,
nothing that allows you run programs like a browsers,
and no real desktop.

But because we installed alongside hyprland the terminal kitty and the browser firefox,
we can access the terminal by pressing the keys SUPER + Q or your custom keybinds.
The terminal will essentially allow you to run commands and even open applications.
If you want to run your browser in the terminal just type the name of that browser into the terminal
```bash
firefox
```

What I reccomend is for you to do your own research on what applications you want.
There is a vast inventory of applications to install for your
- wallpaper
- taskbark
- application launchers

If you want to see the applications that I use then please go over to my Dump repository.
Over there you will see the applications that I have installed, and with a little research
you too can download those applications and configure then to your own liking.




------- 
------- 
-------
