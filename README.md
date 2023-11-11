# Sonarr Instance Installer
### For Swizzin installs
Second *arr Installation on Swizzin based systems
# Warning: this fork is untested
please use the original code from https://github.com/ComputerByte/sonarr4k until verified.


Uses existing install as a base. you must ``sudo box install readarr|radarr|sonarr|lidarr`` prior to running this script. 

Run install.sh as sudo
```bash
sudo su -
wget "https://raw.githubusercontent.com/Betonhaus/swizzin2/main/arr2install.sh"
chmod +x ~/arr2install.sh
~/arr2install.sh
```
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

