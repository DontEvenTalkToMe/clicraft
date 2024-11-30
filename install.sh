#!/bin/bash

mkdir -p $HOME/.config
mkdir -p $HOME/.config/cli-craft; echo "Creating config folder..."; 
chmod +x clicraft.sh 
sudo cp clicraft.sh /usr/local/bin/clicraft; echo "Moving file to PATH..."
sudo cp clicraft.desktop /usr/share/applications
