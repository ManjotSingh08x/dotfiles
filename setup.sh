#!/usr/bin/env bash
# ==============================================================================
# Manjot's Automated Dotfiles Installer & Bootstrapper
# OS: Arch Linux (Hyprland + Caelestia Shell)
# ==============================================================================

set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for pretty terminal output
CLR_RESET="\033[0m"
CLR_INFO="\033[1;34m"
CLR_SUCCESS="\033[1;32m"
CLR_WARN="\033[1;33m"
CLR_ERROR="\033[1;31m"

info()    { echo -e "${CLR_INFO}[INFO]${CLR_RESET} $*"; }
success() { echo -e "${CLR_SUCCESS}[OK]${CLR_RESET} $*"; }
warn()    { echo -e "${CLR_WARN}[WARN]${CLR_RESET} $*"; }
error()   { echo -e "${CLR_ERROR}[ERROR]${CLR_RESET} $*" >&2; exit 1; }

# ------------------------------------------------------------------------------
# 1. Pre-flight Checks
# ------------------------------------------------------------------------------
info "Running pre-flight checks..."
if [ "$EUID" -eq 0 ]; then
    error "Do NOT run setup.sh as root/sudo! Run as your standard user. sudo will be requested when needed."
fi

if [ ! -f /etc/arch-release ]; then
    warn "This system does not appear to be Arch Linux. Continuing, but package installation may fail."
fi

# ------------------------------------------------------------------------------
# 2. Bootstrap AUR Helper (yay)
# ------------------------------------------------------------------------------
if ! command -v yay &> /dev/null; then
    info "Installing base-devel and bootstrapping 'yay'..."
    sudo pacman -S --needed --noconfirm git base-devel
    TEMP_DIR="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$TEMP_DIR/yay-bin"
    (cd "$TEMP_DIR/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$TEMP_DIR"
    success "yay installed successfully."
else
    success "AUR helper (yay) already available."
fi

# ------------------------------------------------------------------------------
# 3. Install System & AUR Packages
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/pkglist-pacman.txt" ]; then
    info "Installing official Arch packages from pkglist-pacman.txt..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist-pacman.txt"
    success "Official packages installed."
fi

if [ -f "$DOTFILES_DIR/pkglist-aur.txt" ]; then
    info "Installing AUR packages from pkglist-aur.txt..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist-aur.txt"
    success "AUR packages installed."
fi

# ------------------------------------------------------------------------------
# 4. Bootstrap Caelestia Base Framework
# ------------------------------------------------------------------------------
if command -v caelestia &> /dev/null; then
    info "Configuring Caelestia dotfiles framework..."
    caelestia dots apply || true
    success "Caelestia framework initialized."
else
    warn "Caelestia CLI not found. If using Caelestia shell, ensure 'caelestia-cli' is installed."
fi

# ------------------------------------------------------------------------------
# 5. Idempotent Symlinking Engine
# ------------------------------------------------------------------------------
info "Symlinking configuration directories and user overrides..."

link_target() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        if [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
            success "Already linked: $dst"
            return 0
        else
            rm -f "$dst"
        fi
    elif [ -e "$dst" ]; then
        local backup="${dst}.backup_$(date +%s)"
        warn "Existing path found at $dst. Backing up to $backup"
        mv "$dst" "$backup"
    fi

    ln -sfn "$src" "$dst"
    success "Linked $dst -> $src"
}

# Config symlinks
link_target "$DOTFILES_DIR/config/caelestia" "$HOME/.config/caelestia"
link_target "$DOTFILES_DIR/config/kitty"     "$HOME/.config/kitty"
link_target "$DOTFILES_DIR/config/fish"      "$HOME/.config/fish"
link_target "$DOTFILES_DIR/config/btop"      "$HOME/.config/btop"
link_target "$DOTFILES_DIR/config/fastfetch" "$HOME/.config/fastfetch"
link_target "$DOTFILES_DIR/config/spicetify" "$HOME/.config/spicetify"

# Home dotfiles
link_target "$DOTFILES_DIR/home/.bashrc"     "$HOME/.bashrc"
link_target "$DOTFILES_DIR/home/.gitconfig"  "$HOME/.gitconfig"

# Wallpapers
link_target "$DOTFILES_DIR/wallpapers"      "$HOME/Pictures/Wallpapers"

# ------------------------------------------------------------------------------
# 6. Post-Installation & Spicetify Configuration
# ------------------------------------------------------------------------------
if command -v spicetify &> /dev/null; then
    info "Applying Spicetify Spotify theme..."
    spicetify backup apply 2>/dev/null || true
    success "Spicetify theme applied."
fi

# Set default shell to fish if installed
if command -v fish &> /dev/null && [ "$SHELL" != "$(which fish)" ]; then
    info "Setting fish as default shell..."
    chsh -s "$(which fish)" || true
fi

echo
success "=== Setup complete! Please log out and back into Hyprland ==="
