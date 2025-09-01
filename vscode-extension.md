
## Install vscode Python extensions for all users

```
sudo code --no-sandbox --user-data-dir=/root/.vscode --extensions-dir /usr/share/code/resources/app/extensions --install-extension ms-python.python
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
    "workbench.colorTheme": "Default Light Modern"
}
```



