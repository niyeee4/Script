#!/data/data/com.termux/files/usr/bin/bash

set -e

TERMUX_HOME="$HOME"
TERMUX_PREFIX="/data/data/com.termux/files/usr"

echo "[*] Updating packages"
pkg update -y

echo "[*] Installing required packages"
pkg install -y \
  curl \
  tar \
  fontconfig-utils \
  nerdfix \
  bat \
  eza

####################################
# TERMINAL COLORS (from script gốc)
####################################
mkdir -p "$TERMUX_HOME/.termux"

cat > "$TERMUX_HOME/.termux/colors.properties" <<'EOF'
background=#0f111a
foreground=#c0caf5
cursor=#c0caf5

color0=#15161e
color1=#f7768e
color2=#9ece6a
color3=#e0af68
color4=#7aa2f7
color5=#bb9af7
color6=#7dcfff
color7=#a9b1d6
color8=#414868
color9=#f7768e
color10=#9ece6a
color11=#e0af68
color12=#7aa2f7
color13=#bb9af7
color14=#7dcfff
color15=#c0caf5
EOF

####################################
# NERD FONT (logic gốc, hardcode)
####################################
echo "[*] Installing Nerd Font (0xProto)"

mkdir -p "$TERMUX_HOME/.fonts"
mkdir -p "$TERMUX_HOME/.termux"

FONT_VERSION="v3.2.1"
FONT_NAME="0xProto"

curl -L \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/${FONT_NAME}.tar.xz" \
  -o "/tmp/${FONT_NAME}.tar.xz"

tar -xf "/tmp/${FONT_NAME}.tar.xz" -C "$TERMUX_HOME/.fonts"

FONT_FILE=$(find "$TERMUX_HOME/.fonts" -iname "*NerdFont-Regular*" | head -n1)

cp "$FONT_FILE" "$TERMUX_HOME/.termux/font.ttf"
fc-cache -f

####################################
# TERMINAL UTILITIES (script gốc)
####################################

# aliases
cat > "$TERMUX_HOME/.aliases" <<'EOF'
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias cat='bat'
EOF

####################################
# BASHRC (KHÔNG ZSH)
####################################
BASHRC="$TERMUX_HOME/.bashrc"

grep -q ".aliases" "$BASHRC" 2>/dev/null || echo '[[ -f ~/.aliases ]] && source ~/.aliases' >> "$BASHRC"

####################################
# MOTD (terminal đẹp)
####################################
cat > "$TERMUX_PREFIX/etc/motd.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo
echo "✨ Termux Terminal Ready"
echo "📦 bat | eza | Nerd Font"
echo
EOF

chmod +x "$TERMUX_PREFIX/etc/motd.sh"

if ! grep -q motd.sh "$TERMUX_PREFIX/etc/termux-login.sh" 2>/dev/null; then
  echo ". $TERMUX_PREFIX/etc/motd.sh" >> "$TERMUX_PREFIX/etc/termux-login.sh"
fi

####################################
# APPLY
####################################
termux-reload-settings

echo "✅ Terminal-only setup completed"
echo "👉 Restart Termux to apply font & colors"
