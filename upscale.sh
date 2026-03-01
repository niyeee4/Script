sudo apt update && sudo apt upgrade
sudo apt install -y ffmpeg git wget libgl1 unzip software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.11 python3.11-distutils
git clone https://github.com/xinntao/Real-ESRGAN
cd Real-ESRGAN
apt install wget -y
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P experiments/pretrained_models
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P weights
curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.11 get-pip.py
pip3.11 install basicsr
pip3.11 install facexlib
pip3.11 install gfpgan
pip3.11 install -r requirements.txt --no-deps
python3.11 setup.py develop

cat << 'EOF' | sudo tee /usr/local/bin/upscale > /dev/null
#!/bin/bash

cd /content/Real-ESRGAN || exit

INPUT="$1"

BASENAME=$(basename "$INPUT")
NAME="${BASENAME%.*}"

OUTPUT="${NAME}_x4.mp4"

python3.11 inference_realesrgan_video.py -i "$INPUT" -o "$OUTPUT" -n RealESRGAN_x4plus_anime_6B -s 4

echo "Done → $OUTPUT"
EOF

sudo chmod +x /usr/local/bin/upscale

echo DONE
echo 'Use: !upscale "yourfile.mp4"'
