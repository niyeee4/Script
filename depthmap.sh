#!/bin/bash
set -e

echo "===== updating system packages ====="
sudo apt update -y

echo "===== installing dependencies ====="
sudo apt install python3 python3-pip git build-essential mesa-utils libgl1-mesa-glx libgl1-mesa-dri libgl1 git wget curl unzip ffmpeg -y

echo "===== cloning depth-anything-v2 ====="
git clone https://github.com/DepthAnything/Depth-Anything-V2.git

echo "===== entering folder ====="
cd Depth-Anything-V2

echo "===== creating checkpoints folder ====="
mkdir -p checkpoints

echo "===== downloading model ====="
wget -O checkpoints/depth_anything_v2_vitl.pth "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth?download=true"

echo "===== installing python requirements ====="
pip install -r requirements.txt --break-system-packages

echo "===== creating 'depthmap' command ====="
cat << 'EOF' > /usr/local/bin/depthmap
#!/bin/bash
cd /content/Depth-Anything-V2
python run_video.py --encoder vitl --video-path "$1" --outdir output --grayscale --pred-only
EOF

chmod +x /usr/local/bin/depthmap

echo "===== setup complete ====="
echo ""
echo "now you can run:"

echo "!depthmap \"yourfile.mp4\""

echo "for example:"

echo "!depthmap \"anime.mp4\""
echo ""
