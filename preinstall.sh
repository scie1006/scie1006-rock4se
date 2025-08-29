#!/bin/sh

echo "apt update & install require packages..."
echo "radxa" | sudo -S sudo apt update
echo "radxa" | sudo -S sudo apt install -y git wget uuid-runtime util-linux htop podman uidmap slirp4netns codium btrfs-progs

echo "downloading from git..."
git clone https://github.com/scie1006/scie1006-rock4se.git

echo "running the flash script..."
cd scie1006-rock4se
chmod +x flash-image-to-ssd.sh
echo "radxa" | sudo -S ./flash-image-to-ssd.sh





