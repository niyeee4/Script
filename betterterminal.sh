#!/data/data/com.termux/files/usr/bin/bash

# TERMUX: update & install required
pkg update -y
pkg install -y git zsh curl wget bash-completion

# Set zsh
chsh -s zsh

# Install starship prompt
curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

# Create starship config
cat <<'EOF' > ~/.config/starship.toml
add_newline = false
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$jobs\
$time\
$status\
"""
[git_status]
disabled = false
[username]
style = "yellow"
[directory]
style = "cyan"
EOF

# Setup history + autosuggestions + completion
pkg install -y fish
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

cat <<'EOF' >> ~/.zshrc
# Starship
eval "$(starship init zsh)"

# History
HISTFILE=~/.zsh_history
SAVEHIST=10000
setopt inc_append_history
setopt share_history

# Enable suggestions & highlight
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Completion
autoload -U compinit && compinit
EOF

# Install nerd font
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -O /sdcard/JetBrainsMono.zip
unzip -o /sdcard/JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv

echo "Terminal setup done! Restart Termux."
