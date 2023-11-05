#!/bin/bash
. /etc/swizzin/sources/globals.sh
. /etc/swizzin/sources/functions/utils


# Script by @ComputerByte edited by @Betonhaus
# For Swizzin Installs
#shellcheck=SC1017

#prompt for names and port number
echo "Please enter the following information to connect to the server. Ensure each value is unused"
echo "Name for new server (Sonarr 4K):"
read arrname
if test -z "$arrname" then
    arrname = "Sonarr 4K"
fi
#code here to make lowercase and remove whitespace from input to present as default system name
echo "System name for new server (sonarr4k):"
read arrsysname
if test -z "$arrsysname" then
    arrsysname = "sonarr4k"
fi
#code here to find random unused ports
echo "Port for new server (8882):"
read arrport
if test -z "$arrsort" then
    arrsort = "8882"
fi

echo "Secure port for new server (9898):"
read arrsport
if test -z "$arrsport" then
    arrsport = "9898"
fi
#code here to check for conflicts, exit if any are found

# Log to Swizzin.log
export log=/root/logs/swizzin.log
touch $log
# Set variables
user=$(_get_master_username)

echo_progress_start "Making data directory and owning it to ${user}"
mkdir -p "/home/$user/.config/$arrsysname"
chown -R "$user":"$user" /home/$user/.config/$arrsysname
echo_progress_done "Data Directory created and owned."

echo_progress_start "Installing systemd service file"
cat >/etc/systemd/system/$arrsysname.service <<-SERV
# This file is owned by the sonarr package, DO NOT MODIFY MANUALLY
# Instead use 'dpkg-reconfigure -plow sonarr' to modify User/Group/UMask/-data
# Or use systemd built-in override functionality using 'systemctl edit sonarr'
[Unit]
Description=Sonarr Daemon
After=network.target

[Service]
User=${user}
Group=${user}
UMask=0002

Type=simple
ExecStart=/usr/bin/mono --debug /opt/Sonarr/Sonarr.exe -nobrowser -data=/home/${user}/.config/${arrsysname}
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERV
echo_progress_done "$arrname service installed"

# This checks if nginx is installed, if it is, then it will install nginx config for sonarr4k
if [[ -f /install/.nginx.lock ]]; then
    echo_progress_start "Installing nginx config"
    cat >/etc/nginx/apps/$arrsysname.conf <<-NGX
location ^~ /${arrsysname} {
    proxy_pass http://127.0.0.1:${arrport};
    proxy_set_header Host \$proxy_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$http_connection;
    auth_basic "What's the password?";
    auth_basic_user_file /etc/htpasswd.d/htpasswd.${user};
}
# Allow the API External Access via NGINX
location ^~ /${arrsysname}/api {
    auth_basic off;
    proxy_pass http://127.0.0.1:${arrport};
}
NGX
    # Reload nginx
    systemctl reload nginx
    echo_progress_done "Nginx config applied"
fi

echo_progress_start "Generating configuration"

# Start sonarr to config
systemctl stop sonarr.service >>$log 2>&1

cat > /home/${user}/.config/$arrsysname/config.xml << EOSC
<Config>
  <LogLevel>info</LogLevel>
  <UpdateMechanism>BuiltIn</UpdateMechanism>
  <Branch>main</Branch>
  <BindAddress>127.0.0.1</BindAddress>
  <Port>8882</Port>
  <SslPort>${arrsport}</SslPort>
  <EnableSsl>False</EnableSsl>
  <LaunchBrowser>False</LaunchBrowser>
  <AuthenticationMethod>None</AuthenticationMethod>
  <UrlBase>${arrsysname}</UrlBase>
  <UpdateAutomatically>False</UpdateAutomatically>
</Config>
EOSC

chown -R ${user}:${user} \/home/${user}/.config/$arrsysname/
systemctl enable --now sonarr.service >>$log 2>&1
sleep 10
systemctl enable --now $arrsysname.service >>$log 2>&1

echo_progress_start "Patching panel."
systemctl start $arrsysname.service >>$log 2>&1
#Install Swizzin Panel Profiles
if [[ -f /install/.panel.lock ]]; then
    cat <<EOF >>/opt/swizzin/core/custom/profiles.py
class ${arrsysname}_meta:
    name = "${arrsysname}"
    pretty_name = "${arrname}"
    baseurl = "/${arrsysname}"
    systemd = "${arrsysname}"
    check_theD = False
    img = "sonarr"
class sonarr_meta(sonarr_meta):
    systemd = "sonarr"
    check_theD = False
EOF
fi
touch /install/.${arrsysname}.lock >>$log 2>&1
echo_progress_done "Panel patched."
systemctl restart panel >>$log 2>&1
echo_progress_done "Done."
