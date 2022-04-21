#!/bin/bash

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

#AWS CLI
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -rf aws

#JetBrains
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11680.tar.gz 
tar -xf jetbrains-toolbox-1.23.11680.tar.gz -C ${HOME}/Soft
mv ${HOME}/Soft/jetbrains-toolbox-1.23.11680 ${HOME}/Soft/jetbrains-toolbox
rm -f jetbrains-toolbox-1.23.11680.tar.gz

cp ./.vimrc ${HOME}/.vimrc
mkdir -p ${HOME}/.bashrc.d
cp -R bash_aliases.d/* ${HOME}/.bashrc.d/

git config --global core.editor "subl -n -w"

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq 
echo i | sudo ./auto-cpufreq-installer
cd ../
rm -rf auto-cpufreq

#install extensions
mkdir -p $(pwd)/ge
cd ge
wget https://github.com/stuarthayhurst/alphabetical-grid-extension/releases/download/v22.0/AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip -O alphabetical-grid.zip
wget https://github.com/aunetx/blur-my-shell/releases/download/v28/blur-my-shell@aunetx.zip -O blur-my-shell.zip
wget https://github.com/eonpatapon/gnome-shell-extension-caffeine/archive/refs/tags/v41.zip -O caffeine.zip
wget https://github.com/home-sweet-gnome/dash-to-panel/releases/download/v46/dash-to-panel@jderose9.github.com_v46.zip -O dash-to-panel.zip
wget https://github.com/kgshank/gse-sound-output-device-chooser/archive/refs/tags/39.zip -O sound-output-device-chooser.zip
wget https://github.com/MartinPL/Tray-Icons-Reloaded/releases/download/23/trayIconsReloaded@selfmade.pl.zip -O tray-icons.zip
wget https://github.com/G-dH/workspace-switcher-manager/releases/download/wsm-v3/workspace-switcher-manager@G-dH.github.com.zip -O workspace-switcher.zip
for gef in ./*; do
	gnome-extensions install "${gef}" -f || true
done
cd ../
rm -rf ge