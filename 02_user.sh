#!/bin/bash

minikube config set driver kvm2

mkdir -p ${HOME}/Soft

tee -a ${HOME}/.config/appimagelauncher.cfg << 'EOF'
[AppImageLauncher]
destination = ~/Soft
enable_daemon = true
EOF

wget -q https://github.com/balena-io/etcher/releases/download/v1.18.8/balenaEtcher-1.18.8-x64.AppImage -O ${HOME}/Soft/balenaEtcher.AppImage
wget -q https://github.com/bitwarden/clients/releases/download/desktop-v2023.5.1/Bitwarden-2023.5.1-x86_64.AppImage -O ${HOME}/Soft/bitwarden.AppImage
wget -q https://github.com/TheTumultuousUnicornOfDarkness/CPU-X/releases/download/v4.5.3/CPU-X-4.5.3-x86_64.AppImage -O ${HOME}/Soft/CPU-X.AppImage
wget -q https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.x86_64.AppImage -O ${HOME}/Soft/OpenLens.AppImage
wget -q https://download.cdn.viber.com/desktop/Linux/viber.AppImage -O ${HOME}/Soft/Viber.AppImage

#Ansible
python -m pip install --user ansible

#SDKMan
curl -s "https://get.sdkman.io" | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.9-tem
echo N | sdk install java 11.0.21-tem
echo N | sdk install java 8.0.392-tem

sdk install maven 3.9.6
sdk install gradle 8.5
sdk install groovy 4.0.17

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

#NVM
curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

#JetBrains
toolbox_version="2.1.3.18901"
wget -q https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${toolbox_version}.tar.gz
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
wget -q https://extensions.gnome.org/extension-data/AlphabeticalAppGridstuarthayhurst.v36.shell-extension.zip -O alphabetical-grid.zip
wget -q https://extensions.gnome.org/extension-data/blur-my-shellaunetx.v54.shell-extension.zip -O blur-my-shell.zip
wget -q https://extensions.gnome.org/extension-data/nightthemeswitcherromainvigier.fr.v75.shell-extension.zip -O nightthemeswitcher.zip
wget -q https://extensions.gnome.org/extension-data/PrivacyMenustuarthayhurst.v22.shell-extension.zip -O privacy-menu.zip
wget -q https://extensions.gnome.org/extension-data/trayIconsReloadedselfmade.pl.v29.shell-extension.zip -O tray-icons.zip
wget -q https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v57.shell-extension.zip -O app-indicator.zip
for gef in ./*; do
	gnome-extensions install "${gef}" -f || true
done
cd ../
rm -rf ge

#create folders to mount cloud storage
mkdir -p ${HOME}/Soft/{dropbox_private,google_drive_private,onedrive_official,onedrive_private,yandex_official}
