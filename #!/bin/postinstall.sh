#!/bin/sh


# install python extension in vs code
# then run the following to copy the extension to all users
echo "kennycheng" | sudo -S cp -r ~/.vscode/extensions/ms-python.* /usr/share/code/resources/app/extensions/
sudo chmod +x $(find /usr/share/code/resources/app/extensions/ms-python.* -type f -exec file {} \; | grep -E 'ELF[^,]+executable' | cut -d: -f1)

#     
echo "kennycheng" | sudo -S rm /etc/sddm.conf.d/* /usr/share/xsessions/*
echo "kennycheng" | sudo -S pip install --break-system-packages pyttsx3
