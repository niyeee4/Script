apt update && apt upgrade
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.7 python3.7-distutils
curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.7 get-pip.py
git clone https://github.com/xinntao/Real-ESRGAN
cd Real-ESRGAN
apt install wget -y
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P experiments/pretrained_models
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P weights
pip3.7 install basicsr
pip3.7 install facexlib
pip3.7 install gfpgan
pip3.7 install -r requirements.txt
python3.7 setup.py develop

sudo tee /usr/local/bin/upscale > /dev/null << 'EOF'
#!/bin/bash

INPUT="$1"

BASENAME=$(basename "$INPUT")
NAME="${BASENAME%.*}"

OUTPUT="${NAME}_x4.mp4"

python3.7 inference_realesrgan_video.py -i "$INPUT" -o "$OUTPUT" -n RealESRGAN_x4plus_anime_6B -s 4

echo "Done → $OUTPUT"
EOF

sudo chmod +x /usr/local/bin/upscale

echo DONE
echo "Use: !upscale "yourfile.mp4"
