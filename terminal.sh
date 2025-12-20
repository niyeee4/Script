#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "==> Updating system"
apt update
yes | apt upgrade
apt update

echo "==> Installing dependencies"
apt install -y git fzf

echo "==> Cloning T-Header"
if [ -d "$HOME/T-Header" ]; then
  rm -rf "$HOME/T-Header"
fi

git clone https://github.com/remo7777/T-Header.git
cd T-Header

echo "==> Running T-Header installer"
bash t-header.sh

echo
echo "✅ Done!"
echo "👉 Open NEW Termux session to see the effect"
echo "   (or manually: source ~/.bashrc)"
