# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
# coder: b0b
# stamp: 1999-12-31

#
# Install dependencies & preferences
#
install-curl:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-nautilus
      - nautilus
      - bash-completion
      - terminator
      - curl

# Add cloudflared key
add-cloudflared-key:
  cmd.run:
    - name: 'export https_proxy=127.0.0.1:8082 && curl -fsSL "https://pkg.cloudflare.com/cloudflare-main.gpg" | gpg --dearmor -o /usr/share/keyrings/cloudflare-main.gpg'

#
# Add cloudflared repo
#
/etc/apt/sources.list.d/cloudflared.list:
  file.managed:
    - makedirs: True
    - contents:
      - 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bullseye main'

# Install cloudflared
install-cloudflared:
  pkg.installed:
    - refresh: True
    - pkgs:
      - cloudflared

# Add cloudflared user
cloudflared:
  user.present:
    - home: /var/lib/cloudflared
    - usergroup: True
    - system: True
    - groups:
      - adm

# Create cloudflared service
/etc/systemd/system/cloudflared.service:
  file.managed:
    - makedirs: True
    - contents:
      - '[Unit]'
      - Description=Cloudflared Tunnel
      - After=network-online.target
      - ''
      - '[Service]'
      - Type=simple
      - User=cloudflared
      - Group=adm
      - "StandardOutput=file:/tmp/cloudflare_tunnel"
      - "ExecStart=/usr/bin/cloudflared tunnel --url http://localhost:8080"
      - Restart=on-failure
      - RestartSec=10
      - KillMode=process
      - ''
      - '[Install]'
      - WantedBy=multi-user.target

enable-cloudflare:
  cmd.run:
    - name: 'systemctl enable cloudflared'

# Create get_tunnel helper script
/usr/bin/get_tunnel:
  file.managed:
    - mode: 755
    - contents:
      - '#!/bin/bash'
      - "awk '/^INF |  https/ {print $4}' /tmp/cloudflare_tunnel"

#
# fetch Sliver install script
#
fetch-sliver-install-script:
  cmd.run:
    - name: 'export https_proxy=127.0.0.1:8082 && curl -o /home/user/sliver_install.sh https://sliver.sh/install && chmod +x /home/user/sliver_install.sh'

#
# Modify Sliver install script
#
/home/user/sliver_install.sh-cd:
    file.replace:
      - name: /home/user/sliver_install.sh
      - pattern: '-----END PGP PUBLIC KEY BLOCK-----\nEOF'
      - repl: '-----END PGP PUBLIC KEY BLOCK-----\nEOF\ncd /usr/bin'

/home/user/sliver_install.sh-server:
    file.replace:
      - name: /home/user/sliver_install.sh
      - pattern: {{ '/root/$SLIVER_SERVER' |regex_escape }}
      - repl: '/usr/bin/$SLIVER_SERVER'

/home/user/sliver_install.sh-client:
    file.replace:
      - name: /home/user/sliver_install.sh
      - pattern: {{ '/root/$SLIVER_CLIENT' |regex_escape }}
      - repl: '/usr/bin/$SLIVER_CLIENT'

/home/user/sliver_install.sh-global1:
    file.replace:
      - name: /home/user/sliver_install.sh
      - pattern: '/usr/local'
      - repl: '/usr'

/home/user/sliver_install.sh-global2:
    file.replace:
      - name: /home/user/sliver_install.sh
      - pattern: '/root/sliver-server'
      - repl: '/usr/bin/sliver-server'

# 
# Install Sliver 
#
install-sliver:
  cmd.run:
    - name: 'export https_proxy=127.0.0.1:8082 && cat /home/user/sliver_install.sh | bash'

#
# Sliver service
#
enable-sliver:
  cmd.run:
    - name: 'systemctl enable sliver'

#
# Sliver auto-config
#
/etc/profile.d/sliver_client_config.sh:
  file.managed:
    - contents:
      - #!/bin/bash
      - "rm -rf /home/$USER/.sliver-client"
      - "if [ -e /home/$USER/.sliver-client/configs/*.cfg ]"
      - then
      - "    true"
      - else
      - "    mkdir -p /home/$USER/.sliver-client/configs"
      - "    sudo /usr/bin/sliver-server operator --name $USER --lhost localhost --save /home/$USER/.sliver-client/configs"
      - "    sudo chown -R $USER:$USER /home/$USER/.sliver-client"
      - fi

#
# Install Sliver GUI dependencies
#
#install-sliver-gui-dependencies:
  pkg.installed:
    - pkgs:
      - fuse
      - libfuse2
      - libnss3
      - libasound2
      - libatk1.0-0
      - libatk-bridge2.0-0
      - libcups2
      - libgtk-3-bin
      - python3-pip

#
# Install lastversion
#
install-lastversion:
  pip.installed:
    - name: lastversion
    - proxy: http://127.0.0.1:8082

#
# Install Sliver GUI
#
install-sliver-gui:
  cmd.run:
    - name: 'export https_proxy=127.0.0.1:8082 && lastversion --assets --filter AppImage --output /usr/bin/sliver_gui download "https://github.com/BishopFox/sliver-gui" && chmod +x /usr/bin/sliver_gui'

#
# Install Sliver GUI desktop launcher
#
/usr/share/applications/sliver_gui.desktop:
  file.managed: 
    - contents:
      - '[Desktop Entry]'
      - Name=Sliver
      - Comment=A Sliver GUI Client
      - TryExec=/usr/bin/sliver_gui
      - Exec=/usr/bin/sliver_gui
      - Icon=sliver_gui
      - Type=Application
      - Categories=System

#
# Install MetaSploit
#
install-metasploit:
  cmd.run:
    - name: 'cd /tmp && export https_proxy=127.0.0.1:8082 && curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall'

#
# Apt upgrade & autoremove
# 
i2pd-apt-autoremove:
  cmd.run:
    - name: 'apt upgrade -y && apt autoremove -y'
 
