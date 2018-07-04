#!/bin/bash
curl https://install.terraform.io/ptfe/stable > install_ptfe.sh
chmod 500 install_ptfe.sh
sudo ./install_ptfe.sh no-proxy bypass-storagedriver-warnings