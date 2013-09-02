xmonad
======
The purpose of this repository is to provide myself with source control for my xmonad configuration, as well as to make my configuration available to any others why may benefit from it.

The .xstart-xmonad script is called by .xinitrc to set up an inital environment and run some startup programs before finally calling xmonad to run up. Xmonad is then used to call on the topxmobar and bottomxmobar configuration files to build our status bars. The xmobarrc file is my original xmobar configuration which only used one status bar. I found a need for more text space and settled on a top and bottom bar.

My goal with xmonad.hs is to provide a clean way of changing the configuration without messing around in the code too much. I have tried to keep the main function as clean as possible so that any future changes will be headache free. I have plans to do a rework of the layouts, possibly removing the IM layout as I haven't used it much at all.

Dependencies
============
This is a (hopefully complete) list of all packages you will need installed on your system to just drop in my configuration and have it "just work". The core dependencies are what I feel will be needed to maintain the same look and feel of my desktop. The optional ones are just there for enhancement and to name off exactly what I use in my setup while saving you from looking through the configuration yourself. Note that if you use a terminal other than URxvt you may want to update the xmonad.hs to reflect that before running my setup. All of these packages can be found in the official Archlinux repositories or on the AUR.

1. Core
* XMonad
* XMonad-contrib
* dmenu
* yeganesh
* URxvt
* XMobar
* Trayer
* Terminus-font
2. Optional
* numlockx
* xplanetFX
* xscreensaver
* adeskmenu
* clipit

Installation
============
1. Clone the repository into ~/.xmonad.
2. Edit xmonad.hs and .xstart-xmonad to reflect your home directory and make any other changes to fit your system.
3. Edit your ~/.xinitrc script to call ~/.xmonad/.xstart-xmonad
4. startx!
