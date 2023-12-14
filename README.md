# Sonarr/Radarr/Readarr/lidarr Secondary Instance Installer
### For Swizzin installs
Second *arr Installation on Swizzin based systems
Forked from from https://github.com/ComputerByte/sonarr4k.


Uses existing install as a base. you must ``sudo box install readarr|radarr|sonarr|lidarr`` prior to running this script and ensure the base app is instaleld and working. 

Run install.sh as sudo
```bash
sudo su -
wget "https://raw.githubusercontent.com/Betonhaus/swizzin2/main/arr2install.sh"
chmod +x ~/arr2install.sh
~/arr2install.sh
```
Script will prompt for a server pretty name (eg: Sonarr Anime), a internal/url name (eg: sonarrani), and an encrypted and unincripted port numbers
Ensure that the internal name is short and has no special characters, otherwise the server may not launch or show up in Panel. Ensure the ports are unused.


Sometimes the second server instance won't start due to another instance existing, use the panel to stop both of them, enable the first and wait a second before starting the second, or

```bash
sudo systemctl stop sonarr && sudo systemctl stop sonarr2
sudo systemctl start sonarr
sudo systemctl start sonarr2
```

The log file should be located at ``/root/log/swizzin.log``.

# Uninstaller: 

```bash
sudo su -
wget "https://raw.githubusercontent.com/Betonhaus/swizzin2/main/arr2uninstall.sh"
chmod +x ~/arr2uninstall.sh
~/arr2uninstall.sh
```

