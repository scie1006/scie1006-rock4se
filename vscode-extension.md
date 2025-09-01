
## Install vscode Python extensions to all users

```
sudo code --extensions-dir /usr/share/code/resources/app/extensions --install-extension ms-python.python
```

## Set the theme as default for all users
### system-wide settings file
As a superuser, create a settings.json file in a location that VS Code will read for default values.

```
sudo nano /usr/share/code/resources/app/extensions/theme-defaults/themes/settings.json
```
Add the workbench.colorTheme property with your chosen theme name. For example, to set "Light Morden" as the default theme, add this line and save the file:

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

