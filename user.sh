#!/bin/bash

minikube config set driver kvm2

mkdir -P ${HOME}/Soft

tee -a ${HOME}/.config/appimagelauncher.cfg << 'EOF'
[AppImageLauncher]
destination = ~/Soft
enable_daemon = true
EOF

wget https://github.com/balena-io/etcher/releases/download/v1.18.8/balenaEtcher-1.18.8-x64.AppImage -O ${HOME}/Soft/balenaEtcher.AppImage
wget https://github.com/bitwarden/clients/releases/download/desktop-v2023.5.1/Bitwarden-2023.5.1-x86_64.AppImage -O ${HOME}/Soft/bitwarden.AppImage
wget https://github.com/TheTumultuousUnicornOfDarkness/CPU-X/releases/download/v4.5.3/CPU-X-v4.5.3-x86_64.AppImage -O ${HOME}/Soft/CPU-X.AppImage
wget https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.x86_64.AppImage -O ${HOME}/Soft/OpenLens.AppImage
mkdir -p ${HOME}/Soft

#Ansible
python -m pip install --user ansible

#SDKMan
curl -s "https://get.sdkman.io" | bash 
source "${HOME}/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.2-open
echo N | sdk install java 11.0.12-open
echo N | sdk install java 8.0.302-open

sdk install maven 3.9.3
sdk install gradle 8.2
sdk install groovy 4.0.13

tee -a ${HOME}/.sdkman/etc/config << 'EOF'
sdkman_auto_answer=true
sdkman_auto_complete=true
sdkman_auto_env=false
sdkman_auto_update=true
sdkman_beta_channel=false
sdkman_checksum_enable=true
sdkman_colour_enable=true
sdkman_curl_connect_timeout=7
sdkman_curl_max_time=10
sdkman_debug_mode=false
sdkman_insecure_ssl=false
sdkman_rosetta2_compatible=false
sdkman_selfupdate_feature=true
EOF

#AWS CLI
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -rf aws

#NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

#JetBrains
toolbox_version="1.28.1.15219"
wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${toolbox_version}.tar.gz
tar -xf jetbrains-toolbox-${toolbox_version}.tar.gz -C ${HOME}/Soft
mv ${HOME}/Soft/jetbrains-toolbox-${toolbox_version} ${HOME}/Soft/jetbrains-toolbox
rm -f jetbrains-toolbox-${toolbox_version}.tar.gz

cp ./.vimrc ${HOME}/.vimrc
mkdir -p ${HOME}/.bashrc.d
cp -R bash_aliases.d/* ${HOME}/.bashrc.d/

git config --global core.editor "subl -n -w"

# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq 
# echo i | sudo ./auto-cpufreq-installer
# cd ../
# rm -rf auto-cpufreq

pip install system-monitoring-center

#install extensions
mkdir -p $(pwd)/ge
cd ge
wget https://github.com/stuarthayhurst/alphabetical-grid-extension/releases/download/v31.0/AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip -O alphabetical-grid.zip
wget https://github.com/aunetx/blur-my-shell/releases/download/v46/blur-my-shell@aunetx.zip -O blur-my-shell.zip
wget https://github.com/eonpatapon/gnome-shell-extension-caffeine/archive/refs/tags/v48.zip -O caffeine.zip
wget https://github.com/tuberry/color-picker/archive/refs/tags/44.0.zip -O color-picker.zip
wget https://github.com/home-sweet-gnome/dash-to-panel/releases/download/v56/dash-to-panel@jderose9.github.com_v46.zip -O dash-to-panel.zip
wget https://extensions.gnome.org/extension-data/nightthemeswitcherromainvigier.fr.v73.shell-extension.zip -O nightthemeswitcher.zip
wget https://extensions.gnome.org/extension-data/openweather-extensionjenslody.de.v121.shell-extension.zip -O openweather.zip
wget https://github.com/stuarthayhurst/privacy-menu-extension/archive/refs/tags/v14.0.zip -O privacy-menu.zip
wget https://github.com/MartinPL/Tray-Icons-Reloaded/releases/download/26/trayIconsReloaded@selfmade.pl.zip -O tray-icons.zip
wget https://github.com/G-dH/workspace-switcher-manager/releases/download/wsm-v3/workspace-switcher-manager@G-dH.github.com.zip -O workspace-switcher.zip
for gef in ./*; do
	gnome-extensions install "${gef}" -f || true
done
cd ../
rm -rf ge

#create folders to mount cloud storage
mkdir -p ${HOME}/Soft/{dropbox_private, google_drive_private, onedrive_official, onedrive_private, yandex_official}
