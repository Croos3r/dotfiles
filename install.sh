#!/usr/bin/env bash
# Symlink these dotfiles into ~/.config and install what the sway setup needs.
#
#   ./install.sh             link configs, install user-level tools (fonts, rust, zscroll, cargo tools, bun)
#   ./install.sh --packages  same, plus `sudo apt install` the system packages first
#
# Anything already in the way is moved to ~/.config-backup/<timestamp>/.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"

LINKS=(
    bat btop dunst fish flameshot foot gh git lazygit nvim opencode oxker rofi
    starship.toml sway swaylock terminator tmux tree-sitter waybar
)

PACKAGES=(
    # sway desktop
    sway swaybg swayidle swaylock waybar xdg-desktop-portal-wlr
    rofi rofimoji wtype dunst foot tmux flameshot
    grim slurp swappy wl-clipboard
    autotiling dex network-manager-gnome
    playerctl brightnessctl alsa-utils
    python3-requests curl unzip
    # shell + CLI tools (fish functions, lazygit, btop, ...)
    fish starship bat btop lazygit gh git zoxide eza fzf fd-find ripgrep sl pyenv
    # neovim + the toolchains its language modules expect
    neovim tree-sitter-cli build-essential clang golang-go rustup php-cli composer
    # needed to build bluetui with cargo
    pkg-config libdbus-1-dev
)

CARGO_TOOLS=(oxker bluetui)

link_configs() {
    for name in "${LINKS[@]}"; do
        local src="$DOTFILES/$name" dst="$CONFIG/$name"
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            continue
        fi
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            mkdir -p "$BACKUP"
            mv "$dst" "$BACKUP/"
            echo "backed up $dst -> $BACKUP/$name"
        fi
        ln -s "$src" "$dst"
        echo "linked $dst -> $src"
    done
}

install_packages() {
    sudo apt-get update
    sudo apt-get install -y "${PACKAGES[@]}"
}

install_fonts() {
    local dir="$HOME/.local/share/fonts/JetBrainsMono"
    if grep -qi "JetBrainsMono Nerd Font" <(fc-list); then
        return
    fi
    mkdir -p "$dir"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
        | tar -xJ -C "$dir"
    fc-cache -f "$dir"
    echo "installed JetBrainsMono Nerd Font"
}

install_rust_tools() {
    command -v rustup >/dev/null || { echo "rustup missing, skipping ${CARGO_TOOLS[*]}"; return; }
    rustup toolchain list | grep -q stable || rustup default stable
    for tool in "${CARGO_TOOLS[@]}"; do
        command -v "$tool" >/dev/null || [ -x "$HOME/.cargo/bin/$tool" ] || cargo install --locked "$tool"
    done
}

# Unpacks the release directly rather than piping bun.sh/install into a shell,
# which would append to fish/config.fish (already set up for bun).
install_bun() {
    local dir="$HOME/.bun/bin" tmp
    [ -x "$dir/bun" ] && return
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/bun.zip" https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip
    unzip -q "$tmp/bun.zip" -d "$tmp"
    mkdir -p "$dir"
    mv "$tmp/bun-linux-x64/bun" "$dir/bun"
    rm -rf "$tmp"
    echo "installed bun"
}

# zscroll (used by the waybar spotify/crypto modules) is a single Python file
# that isn't on PyPI, so fetch it straight into ~/.local/bin.
install_zscroll() {
    local bin="$HOME/.local/bin/zscroll"
    [ -x "$bin" ] && return
    mkdir -p "$(dirname "$bin")"
    curl -fsSL -o "$bin" https://raw.githubusercontent.com/noctuid/zscroll/master/zscroll
    chmod +x "$bin"
    echo "installed zscroll"
}

# Catppuccin Mocha (blue accent) for GTK, cursors and Papirus icons, all under
# ~/.local/share so no root is needed. Applied through gsettings, which both
# GNOME and GTK apps under sway read.
install_catppuccin() {
    local themes="$HOME/.local/share/themes" icons="$HOME/.local/share/icons" tmp
    local gtk="catppuccin-mocha-blue-standard+default" cursors="catppuccin-mocha-dark-cursors"
    tmp="$(mktemp -d)"
    mkdir -p "$themes" "$icons"

    if [ ! -d "$themes/$gtk" ]; then
        curl -fsSL -o "$tmp/gtk.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-blue-standard%2Bdefault.zip"
        unzip -q "$tmp/gtk.zip" -d "$themes"
        echo "installed GTK theme $gtk"
    fi
    # libadwaita/GTK4 apps ignore gtk-theme and only read ~/.config/gtk-4.0
    mkdir -p "$CONFIG/gtk-4.0"
    for f in gtk.css gtk-dark.css assets; do
        ln -sfn "$themes/$gtk/gtk-4.0/$f" "$CONFIG/gtk-4.0/$f"
    done

    if [ ! -d "$icons/$cursors" ]; then
        curl -fsSL -o "$tmp/cursors.zip" "https://github.com/catppuccin/cursors/releases/download/v2.0.0/$cursors.zip"
        unzip -q "$tmp/cursors.zip" -d "$icons"
        echo "installed cursors $cursors"
    fi

    if [ ! -d "$icons/Papirus-Dark" ]; then
        curl -fsSL https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh \
            | DESTDIR="$icons" sh
    fi
    if [ ! -e "$icons/Papirus/64x64/places/folder-cat-mocha-blue.svg" ]; then
        git clone -q --depth 1 https://github.com/catppuccin/papirus-folders "$tmp/papirus-folders"
        cp -r "$tmp/papirus-folders/src/"* "$icons/Papirus/"
        curl -fsSL -o "$tmp/papirus-folders.sh" https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders
        bash "$tmp/papirus-folders.sh" -C cat-mocha-blue --theme Papirus-Dark
        echo "installed Papirus-Dark with Catppuccin folders"
    fi
    rm -rf "$tmp"

    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk"
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
    gsettings set org.gnome.desktop.interface cursor-theme "$cursors"
}

install_tmux_plugins() {
    local catppuccin="$HOME/.local/share/tmux/plugins/catppuccin/tmux"
    local floax="$HOME/.tmux/plugins/tmux-floax"
    if [ ! -d "$catppuccin" ]; then
        git -c advice.detachedHead=false clone -q --depth 1 -b v2.3.2 https://github.com/catppuccin/tmux.git "$catppuccin"
        echo "installed catppuccin/tmux"
    fi
    if [ ! -d "$floax" ]; then
        git clone -q --depth 1 https://github.com/omerxx/tmux-floax "$floax"
        echo "installed tmux-floax"
    fi
}

# JS/AI CLIs used by fish/config.fish and fish/functions. Installers are told
# not to touch shell config: fish/config.fish and conf.d/deno.fish set PATH.
install_cli_tools() {
    local pnpm="$HOME/.local/share/pnpm/bin/pnpm"
    if [ ! -x "$HOME/.deno/bin/deno" ]; then
        curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
    fi
    if [ ! -x "$HOME/.opencode/bin/opencode" ]; then
        curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
    fi
    if [ ! -x "$pnpm" ]; then
        # the binary needs the dist/ directory shipped next to it
        mkdir -p "$(dirname "$pnpm")"
        curl -fsSL https://github.com/pnpm/pnpm/releases/latest/download/pnpm-linux-x64.tar.gz \
            | tar -xz -C "$(dirname "$pnpm")"
        echo "installed pnpm"
    fi
    # npm comes from nvm.fish, so go through fish to get it on PATH
    if command -v fish >/dev/null; then
        fish -c 'command -q copilot; or npm install -g @github/copilot'
    fi
}

# Brave as the default browser (Firefox is removed by hand: snap remove firefox)
set_default_browser() {
    command -v brave-browser >/dev/null || return
    xdg-settings set default-web-browser brave-browser.desktop
    for mime in x-scheme-handler/http x-scheme-handler/https x-scheme-handler/about \
        x-scheme-handler/unknown text/html application/xhtml+xml; do
        xdg-mime default brave-browser.desktop "$mime"
    done
}

mkdir -p "$CONFIG"
[ "${1:-}" = "--packages" ] && install_packages
link_configs
install_fonts
install_zscroll
install_rust_tools
install_bun
install_catppuccin
install_tmux_plugins
install_cli_tools
set_default_browser
