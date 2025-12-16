#!/bin/bash

set -e

echo "== Update system =="
sudo apt update

echo "== Install base packages =="
sudo apt install -y ffmpeg git wget libgl1 unzip software-properties-common

echo "== Add Python 3.11 PPA =="
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.11 python3.11-distutils

echo "== Clone RIFE =="
if [ ! -d "Practical-RIFE" ]; then
  git clone https://github.com/hzwer/Practical-RIFE.git
fi

cd Practical-RIFE

echo "== Download model =="
wget -q https://github.com/niyeee4/Script/raw/refs/heads/main/RIFEv4.25_0919.zip
unzip -o RIFEv4.25_0919.zip

echo "== Install pip for Python 3.11 =="
curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.11 get-pip.py

echo "== Install requirements =="
pip3.11 install -r requirements.txt

echo "== Create rife command =="
cat << 'EOF' | sudo tee /usr/local/bin/rife > /dev/null
#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "usage: rife input.mp4 multi 2-10"
  exit 1
fi

INPUT="$1"
MULTI="$3"
OUTPUT="output_${MULTI}x_${INPUT}"

cd /content/Practical-RIFE || exit 1

python3.11 inference_video.py \
  --video "$INPUT" \
  --output "$OUTPUT" \
  --multi "$MULTI"
EOF

sudo chmod +x /usr/local/bin/rife

echo "== DONE =="
echo "Use: !rife video.mp4 multi 4"
