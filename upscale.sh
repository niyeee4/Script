sudo apt update && sudo apt upgrade
git clone https://github.com/xinntao/Real-ESRGAN
cd Real-ESRGAN
apt install wget -y
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P experiments/pretrained_models
wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P weights
pip uninstall torch torchvision torchaudio -y
pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install basicsr
pip install facexlib
pip install gfpgan
pip install -r requirements.txt --no-deps
python setup.py develop

cat << 'EOF' | sudo tee /usr/local/bin/upscale > /dev/null
#!/bin/bash

cd /content/Real-ESRGAN || exit

INPUT="$1"

BASENAME=$(basename "$INPUT")
NAME="${BASENAME%.*}"

OUTPUT="${NAME}_x4.mp4"

python inference_realesrgan_video.py -i "$INPUT" -o "$OUTPUT" -n RealESRGAN_x4plus_anime_6B -s 4

echo "Done → $OUTPUT"
EOF

sudo chmod +x /usr/local/bin/upscale

echo DONE
echo 'Use: !upscale "yourfile.mp4"'
