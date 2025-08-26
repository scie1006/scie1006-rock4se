#!/bin/sh

# This script is used to flash the image to the SSD of the Rock 4 SE board, which requires root privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use 'sudo' or switch to the root user."
    exit 1
fi

echo "=== install required packages ==="
apt update && apt install -y uuid-runtime util-linux htop btop podman uidmap slirp4netns

echo "=== flash the image to the SSD from the container ==="
xzcat $(podman mount $(podman run --rm -d docker.io/kennycheng/scie1006-rock4se:latest))/images/*.img.xz | dd of=/dev/nvme0n1 bs=512M status=progress

# wait for the SSD to be ready
while ! lsblk /dev/nvme0n1p1 >/dev/null 2>&1; do
    echo "=== Waiting for the SSD to be ready... ==="
    sleep 5
done

echo "=== resize the root partition to fill the SSD ==="
parted /dev/nvme0n1 --script resizepart 1 100%
fsck -f /dev/nvme0n1p1
resize2fs /dev/nvme0n1p1

echo "=== convert rootfs to btrfs and set properties ==="
btrfs-convert /dev/nvme0n1p1
btrfs property set /dev/nvme0n1p1 compress lzo
btrfs check --readonly /dev/nvme0n1p1
btrfstune -f -u /dev/nvme0n1p1

# get the UUIDs of the root and boot partitions
ROOT_UUID=$(blkid -s UUID -o value /dev/nvme0n1p1)

echo "=== mount the SSD ==="
mount /dev/nvme0n1p1 /mnt

echo "=== Replacing boot files with Custom Armbian ==="
rm -rf /boot/*
cp -r /mnt/boot/* /boot/

echo "=== Modifying armbianEnv.txt to use the SSD as root ==="
sed -i -e "s/675b26ed-7086-4767-b880-d3e392cdd272/${ROOT_UUID}/g" /boot/armbianEnv.txt || true
sed -i -e "s/ext4/btrfs/g" /boot/armbianEnv.txt || true

echo "=== enable i2c7 in armbianEnv.txt ==="
#sed -i -e "s/^overlays=/overlays=i2c7 /" /boot/armbianEnv.txt || true
echo "overlays=rk3399-i2c7" >> /boot/armbianEnv.txt

echo "=== making home as a subvolume ==="
rmdir /mnt/home
btrfs subvolume create /mnt/home

echo "=== modify fstab to use the SSD as root ==="
echo "/dev/nvme0n1p1 / btrfs defaults,compress=lzo,subvol=@ 0 1" > /mnt/etc/fstab
echo "/dev/nvme0n1p1 /home btrfs defaults,compress=lzo,subvol=./home 0 1" > /mnt/etc/fstab
echo "/dev/mmcblk1p3 /boot ext4 defaults,noauto 0 2" >> /mnt/etc/fstab

echo "=== setting up hostname ==="
echo "scie1006-$(uuidgen | cut -c1-6)" > /mnt/etc/hostname

echo "=== setting up timezone ==="
cp -L /usr/share/zoneinfo/Asia/Hong_Kong /mnt/etc/localtime

echo "=== copy provision files to the SSD ==="
cp .not_logged_in_yet users.csv /mnt/root/

echo "=== adding udev rules for plugdev gpio access ==="
mkdir -p /mnt/etc/udev/rules.d
cat << EOF > /mnt/etc/udev/rules.d/99-rock4se.rules
SUBSYSTEM=="gpio*", PROGRAM="/bin/sh -c 'find -L /sys/class/gpio/ -maxdepth 2 -exec chown root:plugdev {} \; -exec chmod 770 {} \; || true'"
SUBSYSTEM=="gpio*", ACTION=="add", \
        RUN+="/bin/chgrp -R plugdev '/sys%p'", \
        RUN+="/bin/chmod -R g=u '/sys%p'"
EOF

echo "=== mount additional filesystems ==="
mount -o bind /dev /mnt/dev
mount -o bind /sys /mnt/sys
mount -t proc /proc /mnt/proc

echo "=== chroot into the SSD and setup ==="
chroot /mnt /bin/bash << EOF
echo "=== generating locale and setting up DNS ==="
echo "en_HK.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_HK.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
mkdir -p /run/systemd/resolve/
echo "nameserver 8.8.8.8" > /run/systemd/resolve/stub-resolv.conf
echo "=== installing additional packages ==="
apt update
apt install -y uuid-runtime util-linux htop btop podman uidmap slirp4netns python3-pymongo python3-smbus python3-smbus2 python3-pip python3-pygame python3-pygame-sdl2 python3-periphery codium chromium firefox-esr software-properties-common apt-transport-https wget gpg plasma-nm libreoffice vim btop pipewire-audio pipewire-pulse pipewire-jack wireplumber plasma-pa plasma-workspace-wayland fonts-noto espeak-ng libespeak1
echo "Installing Visual Studio Code..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=arm64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code
echo "=== Setting up user accounts and permissions from /root/users.csv ==="
while IFS=, read -r user passwd; do
	useradd -m -G users,audio,video,plugdev,netdev,i2c,games,render,kvm,dialout,bluetooth \$user
	echo "\$user:\$passwd" | chpasswd
    su - \$user -c "systemctl --user enable pipewire.service pipewire.socket"
	echo "=== Created user \$user with password \$passwd ==="
done < /root/users.csv
exit 0
EOF

echo "=== taking snapshot of the home subvolume ==="
mkdir -p /mnt/.snapshots
btrfs subvolume snapshot -r /mnt/home /mnt/.snapshots/home

echo "=== Unmounting filesystems ==="
umount /mnt/dev
umount /mnt/sys
umount /mnt/proc
umount /mnt

echo "=== Flashing and setup complete. Please reboot the system and try logging in with the user accounts created. ==="
