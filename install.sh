#!/usr/bin/bash
# Select DispVM serving salt files
read -p "Enter DispVM here: " DISPVM
#LIST=$(qvm-ls --no-spinner | grep DispVM | awk '{print $1}')
#DISPVM=$(echo $LIST | sed 's/\s\+/\n/g' | zenity --list --title "Select DispVM" --text "Select the hosting DispVM: " --column DispVMs | sed 's/|//g')
echo "Using $DISPVM"

export $DISPVM

# Download salt files
sudo mkdir /srv/salt/config &>/dev/null
qvm-run --pass-io $DISPVM 'cat /home/user/srv-sliver/qubes-salt/srv-sliver.top' | tee /srv/salt/srv-sliver.top
qvm-run --pass-io $DISPVM 'cat /home/user/srv-sliver/qubes-salt/config/srv-sliver.sls' | tee /srv/salt/config/srv-sliver.sls
qvm-run --pass-io $DISPVM 'cat /home/user/srv-sliver/qubes-salt/config/srv-sliver-template.sls' | tee /srv/salt/config/srv-sliver-template.sls
qvm-run --pass-io $DISPVM 'cat /home/user/srv-sliver/qubes-salt/config/srv-sliver-template-config.sls' | tee /srv/salt/config/srv-sliver-template-config.sls
qvm-run --pass-io $DISPVM 'cat /home/user/srv-sliver/qubes-salt/config/srv-sliver-dvm.sls' | tee /srv/salt/config/srv-sliver-dvm.sls

# Salt states
sudo qubesctl top.enable srv-sliver
sudo qubesctl --show-output --targets srv-sliver-template,srv-sliver-dvm,srv-sliver state.highstate
