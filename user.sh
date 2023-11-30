#!/bin/bash

minikube config set driver kvm2

mkdir -p ${HOME}/Soft

tee -a ${HOME}/.config/appimagelauncher.cfg << 'EOF'
[AppImageLauncher]
destination = ~/Soft
enable_daemon = true
EOF

wget https://github.com/balena-io/etcher/releases/download/v1.18.8/balenaEtcher-1.18.8-x64.AppImage -O ${HOME}/Soft/balenaEtcher.AppImage
wget https://github.com/bitwarden/clients/releases/download/desktop-v2023.5.1/Bitwarden-2023.5.1-x86_64.AppImage -O ${HOME}/Soft/bitwarden.AppImage
wget https://github.com/TheTumultuousUnicornOfDarkness/CPU-X/releases/download/v4.5.3/CPU-X-4.5.3-x86_64.AppImage -O ${HOME}/Soft/CPU-X.AppImage
wget https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.x86_64.AppImage -O ${HOME}/Soft/OpenLens.AppImage

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

#install extensions
mkdir -p $(pwd)/ge
cd ge
wget https://extensions.gnome.org/extension-data/AlphabeticalAppGridstuarthayhurst.v35.shell-extension.zip -O alphabetical-grid.zip
wget https://extensions.gnome.org/extension-data/blur-my-shellaunetx.v54.shell-extension.zip -O blur-my-shell.zip
wget https://extensions.gnome.org/extension-data/nightthemeswitcherromainvigier.fr.v75.shell-extension.zip -O nightthemeswitcher.zip
wget https://extensions.gnome.org/extension-data/PrivacyMenustuarthayhurst.v21.shell-extension.zip -O privacy-menu.zip
wget https://extensions.gnome.org/extension-data/trayIconsReloadedselfmade.pl.v29.shell-extension.zip -O tray-icons.zip
wget https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v47.shell-extension.zip -O app-indicator.zip
for gef in ./*; do
	gnome-extensions install "${gef}" -f || true
done
cd ../
rm -rf ge

gnome-extensions enable AlphabeticalAppGrid@stuarthayhurst
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable PrivacyMenu@stuarthayhurst
gnome-extensions enable trayIconsReloaded@selfmade.pl
gnome-extensions enable nightthemeswitcher@romainvigier.fr
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

#create folders to mount cloud storage
mkdir -p ${HOME}/Soft/{dropbox_private, google_drive_private, onedrive_official, onedrive_private, yandex_official}
