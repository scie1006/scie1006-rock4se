#!/bin/sh


# install python extension in vs code
# then run the following to copy the extension to all users
echo "copying vscode python extensions..."
sudo cp -r ~/.vscode/extensions/ms-python.* /usr/share/code/resources/app/extensions/
sudo chmod +x $(find /usr/share/code/resources/app/extensions/ms-python.* -type f -exec file {} \; | grep -E 'ELF[^,]+executable' | cut -d: -f1)

#     
echo "rm ssdm and install pyttsx3..."
sudo rm /etc/sddm.conf.d/* /usr/share/xsessions/*
sudo pip install --break-system-packages pyttsx3

# pin applications to taskbar, then run the following to add the pinned application to other users
echo "pin taskbar application as current user..."
# pin applications to taskbar, then run the following to add the pinned application to other users
SOURCE_FILE="/home/sandy/.config/plasma-org.kde.plasma.desktop-appletsrc"
# Loop through users g01 to g20
for i in $(seq -w 1 20); do
    USER="g$i"
    # Define the target path 
    TARGET_PATH="/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc"
    #echo "$SOURCE_FILE"
    #echo "$TARGET_PATH"
    sudo cp "$SOURCE_FILE" "$TARGET_PATH"
    # Change the owner of the file to the user
    sudo chown "$USER":"$USER" "$TARGET_PATH$(basename "$SOURCE_FILE")"
    echo "kennycheng" | sudo -S chown "$USER":"$USER" "$TARGET_PATH"
    echo "Copied $SOURCE_FILE to $TARGET_PATH and changed ownership to $USER."
done
