#!/data/data/com.termux/files/usr/bin/bash

#########################################################################
# Variables (trích từ script gốc)
#########################################################################

TERMUX_HOME="$HOME"
TERMUX_PREFIX="/data/data/com.termux/files/usr"
REPO_OWNER="sabamdarif"
REPO_NAME="termux-desktop"
REPO_BRANCH_MAIN="main"
REPO_RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}"

#########################################################################
# Helper functions (trích nguyên bản)
#########################################################################

print_msg() { echo -e "$1"; }
print_failed() { echo -e "❌ $1"; }
print_success() { echo -e "✅ $1"; }

check_and_create_directory() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

check_and_delete() {
  for i in "$@"; do
    [[ -e "$i" ]] && rm -rf "$i"
  done
}

download_file() {
  local dest url
  if [[ -z "$2" ]]; then
    url="$1"
    dest="$(basename "$url")"
  else
    dest="$1"
    url="$2"
  fi
  curl -L --fail "$url" -o "$dest" || wget -O "$dest" "$url"
}

get_latest_release() {
  curl -s "https://api.github.com/repos/$1/$2/releases/latest" | jq -r '.tag_name'
}

#########################################################################
# Select Shell
#########################################################################

echo "Select your shell:"
echo "1) Zsh"
echo "2) Bash"
read -r shell_choice

if [[ "$shell_choice" == "1" ]]; then
  pkg install -y zsh
  chsh -s zsh
  shell_rc_file="$TERMUX_HOME/.zshrc"
else
  shell_rc_file="$TERMUX_HOME/.bashrc"
fi

#########################################################################
# ZSH Theme (trích nguyên logic)
#########################################################################

if [[ "$shell_choice" == "1" ]]; then
  echo "Select zsh theme:"
  echo "1) td_zsh"
  echo "2) powerlevel10k"
  echo "3) pure"
  read -r chosen_zsh_theme

  case "$chosen_zsh_theme" in
    1) selected_zsh_theme_name="td_zsh" ;;
    2) selected_zsh_theme_name="p10k_zsh" ;;
    3) selected_zsh_theme_name="pure_zsh" ;;
  esac

  echo "export ZSH_THEME=${selected_zsh_theme_name}" >> "$shell_rc_file"
fi

#########################################################################
# Terminal Utilities
#########################################################################

pkg install -y nerdfix fontconfig-utils bat eza

echo "[[ -f $TERMUX_HOME/.aliases ]] && source $TERMUX_HOME/.aliases" >> "$shell_rc_file"

#########################################################################
# Nerd Font Setup (trích 100%)
#########################################################################

latest_nf_version=$(get_latest_release "ryanoasis" "nerd-fonts")

echo "Select Nerd Font:"
release_json=$(curl -sSL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/tags/${latest_nf_version}")

mapfile -t ASSET_NAMES < <(
  jq -r '.assets[] | select(.name|endswith(".tar.xz")) | .name' <<< "$release_json"
)

for i in "${!ASSET_NAMES[@]}"; do
  echo "$((i+1))) ${ASSET_NAMES[$i]%.tar.xz}"
done

read -r nerd_choice
sel_base_name="${ASSET_NAMES[$((nerd_choice-1))]%.tar.xz}"

check_and_create_directory "$TERMUX_HOME/.termux"
check_and_create_directory "$TERMUX_HOME/.fonts"

download_file "${sel_base_name}.tar.xz" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_nf_version}/${sel_base_name}.tar.xz"

tar -xf "${sel_base_name}.tar.xz" -C "$TERMUX_HOME/.fonts"

nerd_font_file=$(find "$TERMUX_HOME/.fonts" -iname "*NerdFont-Regular*" | head -n1)

cp "$nerd_font_file" "$TERMUX_HOME/.termux/font.ttf"
fc-cache -f

check_and_delete "${sel_base_name}.tar.xz"

print_success "Terminal-only setup completed"
