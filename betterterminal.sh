#!/bin/bash

# Update trước
pkg update -y && pkg upgrade -y

# Cài các tool hay
pkg install -y bat eza zoxide fzf fastfetch nala unzip curl fontconfig-utils

# Thay màu terminal đẹp
mkdir -p ~/.termux
curl -o ~/.termux/colors.properties https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/colors.properties
termux-reload-settings

# Cấu hình zoxide (cd thông minh)
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

# Alias hay
cat <<EOF >> ~/.bashrc

# Alias apt dùng nala
apt() {
    if command -v nala >/dev/null 2>&1; then
        command nala "\$@"
    else
        command apt "\$@"
    fi
}

# Alias ls sang eza (colorful + icons nếu có Nerd Font)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
EOF

# Phần Nerd Font: Chọn font phổ biến (đổi tên nếu muốn)
FONT_NAME="JetBrainsMono"  # Thay bằng: FiraCode, Hack, CascadiaCode, Meslo, etc.

# Lấy latest version Nerd Fonts
latest_version=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name"' | cut -d'"' -f4)

# Tải và cài
mkdir -p ~/.fonts ~/.termux
curl -L -o font.tar.xz "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_version}/${FONT_NAME}.tar.xz"
tar -xf font.tar.xz -C ~/.fonts
rm font.tar.xz

# Copy file Regular.ttf sang font.ttf (Termux dùng cái này)
nerd_font_file=$(find ~/.fonts -type f -iname "*NerdFont-Regular.ttf" -o -iname "*NerdFontMono-Regular.ttf" | head -n1)
if [[ -n "$nerd_font_file" ]]; then
    cp "$nerd_font_file" ~/.termux/font.ttf
    echo "Đã cài Nerd Font: $FONT_NAME"
else
    echo "Không tìm thấy file font Regular, thử font khác đi!"
fi

# Cập nhật font cache
fc-cache -f

# Reload bash
source ~/.bashrc

echo "Xong hết! Restart Termux để thấy font mới + màu + icons đẹp."
echo "Gợi ý: Gõ 'ls' hoặc 'tree' để thấy icons (nếu eza hỗ trợ)."
echo "Nếu muốn đổi font: Chỉnh FONT_NAME ở đầu script rồi chạy lại."
