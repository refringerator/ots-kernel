echo "Installing nss-mdns"

sudo dnf install -y nss-mdns
sudo systemctl start avahi-daemon
