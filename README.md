# Installation guide

## Requirements

- Rock Pi 4SE single board computer with microSD card and M.2 SSD
- USB-C power supply
- USB keyboard and mouse
- Monitor with HDMI input and cable
- MicroSD card reader
- Docker installed on your host machine

## Installation Steps

### Preparing the microSD card for the Boot partition of the Rock Pi 4SE

1. On your host machine, **Download the Radxa official Rock Pi 4SE image** from [Radxa release page](https://github.com/radxa-build/rock-4se/releases).
    - The image file should be ` rock-4se_debian_bullseye_kde_b38.img.xz`.
2. Unplug the microSD card from Rock Pi 4SE and insert it into your computer using a microSD card reader.
3. **Write the `.xz` image to the microSD card** using a tool like [`USBImager`](https://gitlab.com/bztsrc/usbimager).
    - You may use the `write-only interface` to write the image directly to the microSD card. ![](https://gitlab.com/bztsrc/usbimager/raw/master/usbimager.png)
4. **Safely eject the microSD card** from your computer after the writing process is complete.
5. Insert the microSD card back into the Rock Pi 4SE.

### Booting up the Rock Pi 4SE for flashing image to the M.2 SSD

For the first time login, you may login as `radxa` with password `radxa`. Please follow the on screen instructions to setup the Rock Pi 4SE, including setting up the root password and network connection.

Please setup the network connection to your Wi-Fi or Ethernet. If you are using Ethernet, the Rock Pi 4SE should automatically connect to the network. If you are using Wi-Fi, please click on the network icon in the system tray and select your Wi-Fi network. Enter the password for your Wi-Fi network when prompted.

After completing the setup and logged in, Please open a terminal and run the following commands to install the necessary tools for flashing the M.2 SSD:

```bash
sudo apt update
sudo apt install -y git wget uuid-runtime util-linux htop podman uidmap slirp4netns codium btrfs-progs
```

After the installation is complete, you will need to clone the repository containing the flashing. There are several options available, you could clone it with `codium`, download zip by the browser, or use `git` command in the terminal:

```bash
git clone https://github.com/hkbu-kennycheng/scie1006-rock4se.git
```

When the repository is cloned, navigate to the directory and run the following command to start the flashing process:

```bash
cd scie1006-rock4se
sudo flash-image-to-ssd.sh
```

The flashing script will automatically detect the M.2 SSD and flash the image to it. Make sure that the M.2 SSD is properly connected to the Rock Pi 4SE before running the script.

It will take some time to flash the image to the M.2 SSD, please be patient. Once the process is complete, you will see a message indicating that the flashing was successful.

#### User accounts

The flashing script will create user accounts for you according to the `users.csv` file in the repository. You can modify the file to add or remove users as needed. The root password will be set to `kennycheng` according to the `.not_logged_in_yet` file in the repository. An admin user account will be created for you with the username `sandy` and the password `kennycheng`. You can change the password after logging in for the first time with the `passwd` command.

### Post-installation

If everything goes well, please reboot the Rock Pi 4SE. The system should now boot from the M.2 SSD. After the system boots up from the M.2 SSD, please login with user `root` and password `1234` for final setup. If everything is working correctly, you should see the SDDM login screen.

Please login with the user account `sandy` and password `kennycheng`. After logging in, you will need to run the following command to complete the post-installation setup:

```bash
sudo rm /etc/sddm.conf.d/* /usr/share/xsessions/*
sudo pip install --break-system-packages pyttsx3
```

After finishing all installation, please login with the user account you created during the flashing process and try to run the lab python scripts to ensure everything is working correctly.
