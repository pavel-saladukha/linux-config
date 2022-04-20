#!/bin/bash

#Remove everything unused

dnf remove @libreoffice -y
dnf group remove libreoffice -y

dnf remove -y \
	libreoffice-* \
	totem \
	rhythmbox \
	gnome-boxes \
	gnome-contacts \
	gnome-connections

dnf autoremove -y

#Upgrade
dnf check-update
dnf upgrade -y
dnf autoremove -y

#DNF
dnf install -y \
	vim-enhanced \
	inxi \
	htop \
	unzip \
	redhat-lsb \
	neofetch \
	stress \
	stacer \
	sysprof \
	thinkfan \
	alacritty \
	dnf-plugins-core \
	rclone \
	rclone-browser \
	evolution \
	evolution-ews
	
#Python3
dnf install -y \
	python3-virtualenv \
	python3-pip

#Virtualization
dnf group install --with-optional -y \
	virtualization \
	vagrant 

usermod -aG libvirt ${SUDO_USER}
service libvirtd.service enable
service libvirtd.service start

#Terraform
# dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
# dnf install -y \
# 	terraform

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
dnf install -y \
	kubectl

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
rpm -Uvh minikube-latest.x86_64.rpm
rm -f minikube-latest.x86_64.rpm

wget https://github.com/apptainer/apptainer/releases/download/v1.0.1/apptainer-1.0.1-1.x86_64.rpm
rpm -Uvh apptainer-1.0.1-1.x86_64.rpm
rm -f apptainer-1.0.1-1.x86_64.rpm

rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf install -y \
	sublime-text \
	sublime-merge

dnf check-update
dnf upgrade -y
dnf autoremove -y

#FLATPAK
flatpak update -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

flatpak install flathub -y \
	com.github.maoschanz.drawing \
	org.gimp.GIMP \
	com.rafaelmardojai.Blanket \
	de.haeckerfelix.Shortwave \
	org.flameshot.Flameshot \
	io.github.seadve.Kooha \
	io.github.seadve.Mousai \
	org.videolan.VLC \
	org.libreoffice.LibreOffice \
	org.qbittorrent.qBittorrent \
	org.gnome.DejaDup \
	com.calibre_ebook.calibre \
	fr.free.Homebank \
	net.cozic.joplin_desktop
	
flatpak install flathub -y \
	com.mattjakeman.ExtensionManager \
	fr.romainvigier.MetadataCleaner \
	org.gustavoperedo.FontDownloader

flatpak install flathub -y \
	com.google.Chrome \
	org.chromium.Chromium

flatpak install flathub -y \
	com.skype.Client \
	com.viber.Viber \
	org.telegram.desktop

# flatpak install flathub -y \
# 	org.texstudio.TeXstudio

flatpak update -y
