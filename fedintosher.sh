#!/bin/bash

if ! grep -iq '^id=fedora' /etc/os-release; then
    echo "This script only runs on Fedora. Bailing out."
    exit 1
fi


echo "1 - Installing GEXT and git."
echo "Please accept all the next incoming queries."
sudo dnf install python3-pip -y
sudo dnf install git -y
pip install gnome-extensions-cli

echo "2 - Installing extensions."
echo "Accept all the dialog popups you see!"
gext install blur-my-shell@aunetx
echo "2.1 - Applying Blur My Shell settings"
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/dynamic-opacity false
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/enable-all true
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/opacity 255
gext install dash-to-dock@micxgx.gmail.com
echo "2.2 - Applying Dash to Dock settings"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize'"
gext install arcmenu@arcmenu.com
echo "2.3 - Applying ArcMenu settings"
gext install user-theme@gnome-shell-extensions.gcampax.github.com
echo "2.4 - Applying user theme"
echo "Calling the themer, other extensions will continue later!"
cd ~
mkdir ".fedintosh"
cd ".fedintosh"
git clone https://github.com/vinceliuice/MacTahoe-gtk-theme
cd "MacTahoe-gtk-theme"
chmod +x install.sh
./install.sh -b -l -c dark
sudo ./tweaks.sh -g
sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
gext install rounded-window-corners@fxgn
echo "2.5 - Enabling titlebar buttons and changing the theme..."
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"
dconf write /org/gnome/desktop/interface/gtk-theme "'MacTahoe-Dark'"
dconf write /org/gnome/shell/extensions/user-theme/name "'MacTahoe-Dark'"
echo "2.6 - Installing the icon theme..."
cd ~/.fedintosh
git clone https://github.com/vinceliuice/MacTahoe-icon-theme
cd MacTahoe-icon-theme
./install.sh
dconf write /org/gnome/desktop/interface/icon-theme "'MacTahoe'"
echo "2.7 - Setting up the wallpaper..."
cd ~/.fedintosh/MacTahoe-gtk-theme/wallpaper
./install-gnome-backgrounds.sh
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/gnome/glass-chip-l.jxl'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/gnome/glass-chip-d.jxl'"

echo "3 - Cleaning up!"
cd ~
rm -rf ~/.fedintosh

echo "4 - Rebooting to apply changes..."
systemctl reboot -i
