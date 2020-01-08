#version=CentOS6
install
# Poweroff after installation
poweroff
# System authorization information
auth --enableshadow --passalgo=sha512
# Firewall configuration
firewall --enabled --service=ssh
firstboot --disable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard us
# System language
lang en_US.UTF-8
repo --name "os" --baseurl="http://mirror.centos.org/centos/6/os/x86_64"
repo --name "updates" --baseurl="http://mirror.centos.org/centos/6/updates/x86_64"
repo --name="epel" --baseurl=http://dl.fedoraproject.org/pub/epel/6/x86_64/
# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on
# System bootloader configuration
bootloader --append="console=ttyS0,115200n8 console=tty0" --location=mbr --driveorder="vda" --timeout=1
# Root password
rootpw --iscrypted nothing
selinux --enforcing
services --disabled="kdump" --enabled="network,sshd,rsyslog,chronyd"
timezone UTC --isUtc
# Disk
zerombr
clearpart --all --initlabel 
part / --fstype="ext4" --size=3072

%post --erroronfail

# workaround anaconda requirements
passwd -d root
passwd -l root

# remove avahi and networkmanager
echo "Removing avahi/zeroconf and NetworkManager"
yum -C -y remove avahi\* Network\*

# make sure firstboot doesn't start
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

echo "Cleaning old yum repodata."
yum clean all

# chance dhcp client retry/timeouts to resolve #6866
cat  >> /etc/dhcp/dhclient.conf << EOF

timeout 300;
retry 60;
EOF

# clean up installation logs"
rm -rf /var/log/yum.log
rm -rf /var/lib/yum/*
rm -rf /root/install.log
rm -rf /root/install.log.syslog
rm -rf /root/anaconda-ks.cfg
rm -rf /var/log/anaconda*
rm -rf /root/anac*

%end

%packages
@core
chrony
cloud-init
cloud-utils-growpart
efibootmgr
epel-release
grub
kernel
rsync
tar
yum-utils
python-oauth
-NetworkManager
-aic94xx-firmware
-alsa-firmware
-alsa-lib
-alsa-tools-firmware
-iprutils
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl105-firmware
-iwl135-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260-firmware
-iwl7265-firmware
-libertas-sd8686-firmware
-libertas-sd8787-firmware
-libertas-usb8388-firmware
-plymouth
-postfix
-wpa_supplicant

%end

