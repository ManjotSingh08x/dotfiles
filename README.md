# Dotfiles

Personal configurations and user overrides for **Arch Linux** running **Hyprland** with **Caelestia Shell**.

## Repository Structure

```
~/.dotfiles/
├── setup.sh                 # Fully automated installer and symlink creator
├── pkglist-pacman.txt       # Explicitly installed native Arch packages
├── pkglist-aur.txt          # Explicitly installed AUR packages
├── config/
│   ├── caelestia/           # Hyprland user overrides, keybinds, gestures, shell.json
│   ├── kitty/               # Kitty terminal configuration
│   ├── fish/                # Fish shell functions, aliases, and completions
│   ├── btop/                # btop monitoring configuration & themes
│   ├── fastfetch/           # Fastfetch system info layout
│   └── spicetify/           # Spicetify theme and Spotify configurations
├── home/
│   ├── .bashrc              # Sanitized bash configuration
│   └── .gitconfig           # Git user profile and credential helpers
└── wallpapers/              # High-resolution desktop wallpapers
```

## Fresh Installation / Restore on a New Machine

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ManjotSingh08x/dotfiles.git ~/.dotfiles
   ```

2. **Run the setup script:**
   ```bash
   cd ~/.dotfiles
   chmod +x setup.sh
   ./setup.sh
   ```

3. **What `setup.sh` does automatically:**
   - Bootstraps `yay` (if missing).
   - Installs all required official packages from `pkglist-pacman.txt`.
   - Installs all required AUR packages from `pkglist-aur.txt`.
   - Initializes the Caelestia dotfiles framework (`caelestia dots apply`).
   - Safely symlinks your configurations into `~/.config/`, `~/.bashrc`, and `~/Pictures/Wallpapers/` (backing up any conflicting files first).
   - Re-applies the Spicetify theme for Spotify.
   - Sets `fish` as your default interactive shell.

## Daily Usage & Tracking Changes

Because all active configuration folders in `~/.config` are live **symbolic links** to this repository:
- Any change you make in `~/.config/caelestia/`, `~/.config/kitty/`, or `~/Pictures/Wallpapers/` is instantly reflected here.
- To push your updates:
  ```bash
  cd ~/.dotfiles
  git status
  git add .
  git commit -m "Update configurations"
  git push
  ```

## Handling Secrets
Do not add API keys or tokens to tracked files. Place machine-specific private variables into `~/.bashrc.local` (which is ignored by Git and automatically sourced by `~/.bashrc`).
