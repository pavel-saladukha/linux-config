#!/bin/bash

minikube config set driver kvm2

mkdir -P ${HOME}/Soft

tee -a ${HOME}/.config/appimagelauncher.cfg << 'EOF'
[AppImageLauncher]
destination = ~/Soft
enable_daemon = true
EOF

wget https://github.com/balena-io/etcher/releases/download/v1.14.3/balenaEtcher-1.14.3-x64.AppImage -O ${HOME}/Soft/balenaEtcher-1.14.3-x64.AppImage
wget https://github.com/bitwarden/clients/releases/download/desktop-v2023.1.1/Bitwarden-2023.1.1-x86_64.AppImage -O ${HOME}/Soft/bitwarden.AppImage
wget https://github.com/TheTumultuousUnicornOfDarkness/CPU-X/releases/download/v4.5.2/CPU-X-v4.5.2-x86_64.AppImage -O ${HOME}/Soft/CPU-X.AppImage

mkdir -p ${HOME}/Soft/{java17,java11,java8,maven,gradle,groovy}

#Ansible
python -m pip install --user ansible

#SDKMan
curl -s "https://get.sdkman.io" | bash 
source "${HOME}/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.2-open ${HOME}/Soft/java17
echo N | sdk install java 11.0.12-open ${HOME}/Soft/java11
echo N | sdk install java 8.0.302-open ${HOME}/Soft/java8

sdk install maven 3.8.5 ${HOME}/Soft/maven
sdk install gradle 7.4.2 ${HOME}/Soft/gradle
sdk install groovy 4.0.1 ${HOME}/Soft/groovy

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

#JetBrains
toolbox_version="1.27.2.13801"
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
wget https://github.com/stuarthayhurst/alphabetical-grid-extension/releases/download/v22.0/AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip -O alphabetical-grid.zip
wget https://github.com/aunetx/blur-my-shell/releases/download/v28/blur-my-shell@aunetx.zip -O blur-my-shell.zip
wget https://github.com/eonpatapon/gnome-shell-extension-caffeine/archive/refs/tags/v41.zip -O caffeine.zip
wget https://github.com/home-sweet-gnome/dash-to-panel/releases/download/v46/dash-to-panel@jderose9.github.com_v46.zip -O dash-to-panel.zip
wget https://extensions.gnome.org/extension-data/nightthemeswitcherromainvigier.fr.v72.shell-extension.zip -O nightthemeswitcher.zip
wget https://extensions.gnome.org/extension-data/openweather-extensionjenslody.de.v119.shell-extension.zip -O openweather.zip
wget https://github.com/MartinPL/Tray-Icons-Reloaded/releases/download/23/trayIconsReloaded@selfmade.pl.zip -O tray-icons.zip
wget https://github.com/G-dH/workspace-switcher-manager/releases/download/wsm-v3/workspace-switcher-manager@G-dH.github.com.zip -O workspace-switcher.zip
for gef in ./*; do
	gnome-extensions install "${gef}" -f || true
done
cd ../
rm -rf ge

#create folders to mount cloud storage
mkdir ${HOME}/cloud_mounts/dropbox_private
mkdir ${HOME}/cloud_mounts/google_drive_private
mkdir ${HOME}/cloud_mounts/onedrive_official
mkdir ${HOME}/cloud_mounts/onedrive_private
mkdir ${HOME}/cloud_mounts/yandex_official
