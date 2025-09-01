
## Install vscode Python extensions to all users

```
sudo code --extensions-dir /usr/share/code/resources/app/extensions --install-extension ms-python.python
```

## Set the theme as default for all users

```
sudo nano /usr/share/code/resources/app/extensions/settings.json
```
Light Modern
/usr/share/code/resources/app/extensions/theme-defaults/themes.
```
sudo nano /usr/share/code/resources/app/extensions/theme-defaults/themes/settings.json
```

```
### json

```
{
    "workbench.colorTheme": "Light Modern"
}
```


sudo nano /usr/share/code/resources/app/extensions/theme-defaults/package.json
```

### json

In the contributes section, add an entry for your theme to ensure it's properly recognized. For example:  
```
"contributes": {
    "themes": [
        {
            "label": "My Default Theme",
            "uiTheme": "Light Modern",
            "path": "./themes/settings.json"
        }
    ]
}

```

