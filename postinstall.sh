#!/bin/sh


# install python extension in vs code for all users
# 
echo "installing vscode python extensions..."
sudo code --no-sandbox --user-data-dir=/root/.vscode --extensions-dir /usr/share/code/resources/app/extensions --install-extension ms-python.python


# set default vscode theme to "Default Light Modern" for user g01~g20
echo "setting vscode theme..."
# Loop through users g01 to g20
for i in $(seq -w 1 20); do
    USER="g$i"

    # Define the target file path
    TARGET_FILE="/home/$USER/.config/Code/User/settings.json"
    
    # Create the directory if it doesn't exist
    mkdir -p "$(dirname "$TARGET_FILE")"
    
    # Create the JSON content
    echo '{' > "$TARGET_FILE"
    echo '    "workbench.colorTheme": "Default Light Modern"' >> "$TARGET_FILE"
    echo '}' >> "$TARGET_FILE"

    # Inform the user
    echo "Settings file created at: $TARGET_FILE"
done

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
    sudo chown "$USER":"$USER" "$TARGET_PATH"    
    echo "Copied $SOURCE_FILE to $TARGET_PATH and changed ownership to $USER."
done
