#!/bin/bash
# Create the systemd service file
cat <<EOF | sudo tee /etc/systemd/system/myapp.service
[Unit]
Description=Fish NodeJS Service
After=network.target
[Service]
User=packer
WorkingDirectory=$HOME/hello-fish
ExecStart=/usr/bin/node $HOME/hello-fish/index.js
Restart=always
[Install]
WantedBy=multi-user.target
EOF
# Reload systemd to recognize the new service, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable myapp.service
sudo systemctl start myapp.service