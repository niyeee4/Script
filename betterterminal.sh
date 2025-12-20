#!/bin/bash

echo "Bắt đầu setup terminal đẹp cho Termux (nhẹ, không cài desktop)"

# Fix dpkg kẹt nếu có (lỗi phổ biến khi update trước đó bị dừng)
dpkg --configure -a 2>/dev/null

# Kiểm tra và gợi ý dùng termux-change-repo (cách tốt nhất)
if command -v termux-change-repo >/dev/null 2>&1; then
    echo "Khuyến nghị: Chạy 'termux-change-repo' để chọn mirror nhanh nhất (Grimler hoặc CloudFlare thường tốt)."
    echo "Bạn có muốn chạy ngay bây giờ? (y/n, default n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        termux-change-repo
    fi
else
    echo "Chưa có termux-tools, sẽ cài sau."
fi

# Nếu vẫn chưa có repo tốt, ghi đè sources.list bằng mirror chính thức ổn định
echo "Đảm bảo sources.list dùng mirror chính thức..."
cat > $PREFIX/etc/apt/sources.list << EOF
deb https://packages.termux.dev/apt/termux-main stable main
EOF

# Update & upgrade an toàn
pkg update -y && pkg upgrade -y

# Cài các package cần thiết
pkg install -y bat eza zoxide fzf fastfetch nala unzip curl fontconfig termux-tools

# Thay màu terminal đẹp từ repo gốc sabamdarif
mkdir -p ~/.termux
curl -o ~/.termux/colors.properties https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/colors.properties
termux-reload-settings

# Cấu hình zoxide (cd thông minh: dùng z thay cd)
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

# Alias hay
cat <<EOF >> ~/.bashrc

# Alias apt dùng nala (giao diện đẹp, colorful, gợi ý package)
apt() {
    if command -v nala >/dev/null 2>&1; then
        command nala "\$@"
    else
        command apt "\$@"
    fi
}

# Alias ls sang eza (colorful + icons khi có Nerd Font)
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --group-directories-first'
alias la='eza -la --icons=auto --group-directories-first'
alias tree='eza --tree --icons=auto'
EOF

# Phần Nerd Font: JetBrainsMono (phổ biến, đẹp, readable)
FONT_NAME="JetBrainsMono"

echo "Đang tải latest Nerd Font $FONT_NAME..."
mkdir -p ~/.fonts ~/.termux

# Tải trực tiếp latest tar.xz (không cần biết version)
curl -L -o font.tar.xz "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.tar.xz"

# Giải nén
tar -xf font.tar.xz -C ~/.fonts
rm font.tar.xz

# Copy file Regular.ttf phù hợp sang font.ttf cho Termux
nerd_font_file=$(find ~/.fonts -type f -iname "*Regular*Nerd*Font*.ttf" -o -iname "*NerdFont-Regular.ttf" | head -n1)
if [[ -n "$nerd_font_file" ]]; then
    cp "$nerd_font_file" ~/.termux/font.ttf
    echo "Đã cài Nerd Font: $FONT_NAME"
else
    echo "Không tìm thấy file Regular, có thể font tải lỗi. Thử chạy lại script."
fi

# Cập nhật font cache
fc-cache -f

# Reload bash config
source ~/.bashrc

echo ""
echo "HOÀN TẤT! 🎉"
echo "Restart Termux hoàn toàn (đóng app rồi mở lại) để thấy:"
echo "- Màu terminal đẹp hơn"
echo "- apt dùng nala (gợi ý package, giao diện colorful)"
echo "- ls/ll/la/tree hiển thị icons đẹp (nhờ Nerd Font)"
echo "- Dùng 'z <tên_thư_mục>' để cd nhanh thông minh"
echo "- Gõ 'fastfetch' để xem info hệ thống đẹp"
echo ""
echo "Nếu muốn đổi font khác (FiraCode, Hack, CascadiaCode...):"
echo "Sửa dòng FONT_NAME ở đầu script rồi chạy lại."
echo "Hoặc dùng lệnh: getnf (nếu cài termux-api hoặc tool khác)."
