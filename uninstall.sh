#!/usr/bin/bash

sudo qubesctl top.disable srv-sliver

rm srv-sliver-install.sh

sudo rm /srv/salt/srv-sliver.top
sudo rm /srv/salt/config/srv-sliver.sls
sudo rm /srv/salt/config/srv-sliver-template.sls
sudo rm /srv/salt/config/srv-sliver-template-config.sls
sudo rm /srv/salt/config/srv-sliver-dvm.sls
