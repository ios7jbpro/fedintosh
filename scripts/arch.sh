#!/bin/bash

echo "PRE - installing yay."
echo "Please accept all the next incoming queries."
sudo pacman -S --needed base-devel git wget -y
cd ~
mkdir ".fedintosh"
cd ".fedintosh"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd "~/.fedintosh"
echo "yay installed. Proceeding with next step..."


echo "1 - Installing GEXT and git."
sudo pacman -S python-pip -y
pip install gnome-extensions-cli --break-system-packages
echo "Temporarily modifying PATH..."
export PATH="$HOME/.local/bin:$PATH"

echo "2 - Installing extensions."
echo "Accept all the dialog popups you see!"
gext install blur-my-shell@aunetx
echo "2.1 - Applying Blur My Shell settings"
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/dynamic-opacity false
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/enable-all true
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/opacity 230
gext install dash-to-dock@micxgx.gmail.com
echo "2.2 - Applying Dash to Dock settings"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 36
dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys false
gext install arcmenu@arcmenu.com
echo "2.3 - Applying ArcMenu settings"
gext install user-theme@gnome-shell-extensions.gcampax.github.com
echo "2.4 - Applying user theme"
echo "Calling the themer, other extensions will continue later!"
cd "~/.fedintosh"
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

echo "3 - Compiling a custom version of gnome-shell"
sudo pacman -S --needed base-devel git meson ninja python-pip gtk-doc gnome-common sassc gjs glib2
cd ~/.fedintosh
mkdir "customshell"
cd customshell
#git clone https://gitlab.archlinux.org/archlinux/packaging/packages/gnome-shell
#cd gnome-shell
#sudo pacman -S asciidoc bash-completion gi-docgen glib2-devel gobject-introspection python-docutils
#makepkg -o
#makepkg -si
#cd src/gnome-shell
#wget https://raw.githubusercontent.com/ios7jbpro/fedintosh/refs/heads/main/Shell_BlurEffect__rounded_corners_mask.patch
#patch -p1 < Shell_BlurEffect__rounded_corners_mask.patch
#cd ~/.fedintosh/customshell/gnome-shell
#makepkg -f -si
yay -S gnome-rounded-blur
cd ~/.fedintosh/customshell
git clone https://github.com/aunetx/blur-my-shell
cd blur-my-shell
wget https://raw.githubusercontent.com/ios7jbpro/fedintosh/refs/heads/main/Add_corner_radius_to_NativeDynamicBlurEffect.patch
wget https://github.com/user-attachments/files/25559743/bms_blur_effect_rounded_corners.patch
patch -p1 < bms_blur_effect_rounded_corners.patch
make install
dconf write /org/gnome/shell/extensions/blur-my-shell/applications/corner-radius 17


echo "4 - Cleaning up!"
cd ~
rm -rf ~/.fedintosh

echo "5 - Rebooting to apply changes..."
systemctl reboot -i
