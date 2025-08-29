#!/bin/sh

echo "radxa" | sudo -S sudo apt update
sudo apt install -y git wget uuid-runtime util-linux htop podman uidmap slirp4netns codium btrfs-progs

git clone https://github.com/scie1006/scie1006-rock4se.git

cd scie1006-rock4se
chmod +x flash-image-to-ssd.sh
echo "radxa" | sudo -S ./flash-image-to-ssd.sh





