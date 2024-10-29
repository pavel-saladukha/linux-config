#!/bin/bash

cp -f dnf.conf /etc/dnf/dnf.conf

#RPM Fusion
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Remove everything unused
dnf remove @libreoffice -y
dnf group remove -y \
	container-management \
	libreoffice

dnf remove -y \
	libreoffice-* \
	totem \
	rhythmbox \
	gnome-boxes \
	gnome-contacts \
	gnome-connections \
	evolution \
	evolution-ews \
	evolution-ews-langpacks \
	evolution-langpacks \
	podman \
	docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
	docker-latest-logrotate \
	docker-logrotate \
	docker-selinux \
	docker-engine-selinux \
	docker-engine

dnf autoremove -y

#Upgrade
dnf check-update
dnf upgrade -y
dnf autoremove -y

#Firewall
dnf install -y \
	ufw

ufw disable
ufw limit 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw default deny incoming
ufw default allow outgoing
ufw enable

#DNF
dnf install -y \
	bash \
	blueman \
	bluez \
	bluez-tools \
	btop \
	coreutils \
	dkms \
	dnf-plugins-core \
	duf \
	edk2-tools \
	efibootmgr \
	fastfetch \
	fuse-sshfs \
	genisoimage \
	gnome-tweaks \
	gparted \
	grep \
	helm \
	htop \
	inxi \
	jq \
	kernel-devel-`uname -r` \
	kernel-headers \
	lm_sensors \
	make \
	procps \
	rclone \
	rclone-browser \
	redhat-lsb \
	screenkey \
	sed \
	spice-gtk-tools \
	stress \
	swtpm \
	sysprof \
	thinkfan \
	unzip \
	usbutils \
	util-linux \
	vim-enhanced \
	wget \
	xdg-user-dirs \
	xrandr \
	xsensors

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
	intel-media-driver \
	lame\* \
	--exclude=gstreamer1-plugins-bad-free-devel \
	--exclude=lame-devel \
    nvidia-vaapi-driver
dnf group upgrade --with-optional --allowerasing -y \
	multimedia

#Docker
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin

groupadd docker
usermod -aG docker ${SUDO_USER}
systemctl enable docker.service --now
systemctl start docker.service

#Virtualization
dnf install -y \
	distrobox
dnf group install --with-optional -y \
	virtualization \
	vagrant 

usermod -aG libvirt ${SUDO_USER}
systemctl enable libvirtd.service --now
systemctl start libvirtd.service

#k3d
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#Terraform
dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
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

#AWS CLI
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm awscliv2.zip
rm -rf aws

curl --output-dir /tmp -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

wget -q https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm -O appimagelauncher.rpm
rpm -Uvh appimagelauncher.rpm
rm -f appimagelauncher.rpm

wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
chmod +x /usr/local/bin/yq

rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
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
	com.calibre_ebook.calibre \
	com.discordapp.Discord \
	com.github.PintaProject.Pinta \
	com.github.maoschanz.drawing \
	com.github.tchx84.Flatseal \
	com.google.Chrome \
	com.mattjakeman.ExtensionManager \
	com.rafaelmardojai.Blanket \
	com.skype.Client \
	io.github.flattool.Warehouse \
	io.github.thetumultuousunicornofdarkness.cpu-x \
	net.cozic.joplin_desktop \
	net.nokyan.Resources \
	org.chromium.Chromium \
	org.gnome.Extensions \
	org.gnome.PowerStats \
	org.libreoffice.LibreOffice \
	org.mozilla.Thunderbird \
	org.qbittorrent.qBittorrent \
	org.telegram.desktop \
	org.videolan.VLC \
	us.zoom.Zoom

flatpak update -y
