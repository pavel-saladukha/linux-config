#!/bin/bash

cp -f dnf.conf /etc/dnf/dnf.conf

#RPM Fusion
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf group update core -y

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
	autojump \
	barrier \
	bash \
	blueman \
	coreutils \
	distrobox \
	dnf-plugins-core \
	dnfdragora \
	dnfdragora-gui \
	duf \
	edk2-tools \
	efibootmgr \
	evolution \
	evolution-ews \
	fuse-sshfs \
	genisoimage \
	gnome-tweaks \
	gparted \
	grep \
	helm \
	htop \
	inxi \
	jq \
	joystick-support \
	kitty \
	lm_sensors \
	neofetch \
	procps \
	rclone \
	rclone-browser \
	redhat-lsb \
	screenkey \
	sed \
	spice-gtk-tools \
	stacer \
	stress \
	swtpm \
	sysprof \
	thinkfan \
	timeshift \
	unzip \
	usbutils \
	util-linux \
	vim-enhanced \
	wget \
	xdg-user-dirs \
	xrandr \
	xsensors \
	dkms make bluez bluez-tools kernel-devel-`uname -r` kernel-headers

#Python3
dnf install -y \
	python3 \
	python3-virtualenv \
	python3-pip

#Nvidia
dnf install akmod-nvidia -y
dnf install xorg-x11-drv-nvidia-cuda -y

#Codecs
dnf install -y \
	gstreamer1-plugins-{bad-\*,good-\*,base} \
	gstreamer1-plugin-openh264 \
	gstreamer1-libav \
	lame\* \
	--exclude=gstreamer1-plugins-bad-free-devel \
	--exclude=lame-devel
dnf group upgrade --with-optional -y \
	Multimedia

#Virtualization
dnf group install --with-optional -y \
	virtualization \
	vagrant 

usermod -aG libvirt ${SUDO_USER}
service libvirtd.service enable
service libvirtd.service start

#Terraform
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf install -y \
	terraform

#VSCodium
tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
dnf install codium -y

tee -a /etc/yum.repos.d/kubernetes.repo << 'EOF'
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

wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm -O appimagelauncher.rpm
rpm -Uvh appimagelauncher.rpm
rm -f appimagelauncher.rpm

wget https://github.com/apptainer/apptainer/releases/download/v1.0.1/apptainer-1.0.1-1.x86_64.rpm
rpm -Uvh apptainer-1.0.1-1.x86_64.rpm
rm -f apptainer-1.0.1-1.x86_64.rpm

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
chmod +x /usr/local/bin/yq

wget https://github.com/gohugoio/hugo/releases/latest/download/hugo_extended_0.110.0_Linux-64bit.tar.gz
tar -xf hugo_extended_0.110.0_Linux-64bit.tar.gz
rm -rf hugo_extended_0.110.0_Linux-64bit.tar.gz
mv hugo /usr/local/bin
chmod +x /usr/local/bin/hugo

#for evolution backup
ln -s /usr/libexec/evolution/evolution-backup /usr/local/bin/evolution-backup

rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf install -y \
	sublime-text \
	sublime-merge

dnf check-update
dnf upgrade -y
dnf autoremove -y

#Gamepad support
git clone https://github.com/paroj/xpad.git /usr/src/xpad-0.4
dkms install -m xpad -v 0.4 --force

#FLATPAK
flatpak update -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

flatpak install flathub -y \
	ca.desrt.dconf-editor \
	com.calibre_ebook.calibre \
	com.dangeredwolf.ModernDeck \
	com.github.johnfactotum.Foliate \
	com.github.maoschanz.drawing \
	com.github.PintaProject.Pinta \
	com.github.tchx84.Flatseal \
	com.google.Chrome \
	com.mattjakeman.ExtensionManager \
	com.rafaelmardojai.Blanket \
	com.skype.Client \
	com.uploadedlobster.peek \
	com.usebottles.bottles \
	com.valvesoftware.Steam \
	fr.free.Homebank \
	fr.romainvigier.MetadataCleaner \
	io.github.hakandundar34coding.system-monitoring-center \
	io.github.seadve.Kooha \
	io.github.seadve.Mousai \
	net.cozic.joplin_desktop \
	net.lutris.Lutris \
	org.audacityteam.Audacity \
	org.bleachbit.BleachBit \
	org.chromium.Chromium \
	org.flameshot.Flameshot \
	org.gimp.GIMP \
	org.gnome.Boxes \
	org.gnome.DejaDup \
	org.gnome.Extensions \
	org.gnome.PowerStats \
	org.gramps_project.Gramps \
	org.gustavoperedo.FontDownloader \
	org.kde.tokodon \
	org.libreoffice.LibreOffice \
	org.linux_hardware.hw-probe \
	org.nickvision.money \
	org.qbittorrent.qBittorrent \
	org.telegram.desktop \
	org.videolan.VLC \
	re.sonny.Tangram

flatpak update -y
