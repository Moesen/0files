mod cli-tools

svc_packages := "pipewire pipewire-pulse bluez"
wm_packages := "hyprland xdg-desktop-portal-hyprland"
wm_util_packages := "wofi hyprlock waybar wl-clipboard otf-font-awesome"
dev_dependencies := "nodejs-lts-jod npm pnpm"
dev_packages := "neovim zsh just kitty fzf docker bat"
work_packages := "kubectl"
work_apps := "mattermost-desktop"

default:
  @just --list

install-svc-packages:
  yay -S --needed {{svc_packages}}
install-wm:
  yay -S --needed {{wm_packages}}
  yay -S --needed {{wm_util_packages}}
install-dev-dependencies:
  yay -S --needed {{dev_dependencies}}

install-dev-tools:
  yay -S --needed {{dev_packages}}

install-rust:
  yay -S --needed rustup

install-rust-tools: install-rust
  cargo install starship --locked
  cargo install du-dust --locked
  cargo install fd-find --locked
  cargo install eza --locked
  cargo install zellij --locked
  cargo install zoxide --locked

install-uv: install-rust
  cargo install --locked --git https://github.com/astral-sh/uv uv

install-work-packages:
  yay -S --needed {{work_packages}}

install-work-apps:
  yay -S --needed {{work_apps}}

setup-work-env: install-work-packages install-work-apps
  [[ -d ~/alvenir/ ]] || mkdir ~/alvenir/

install: install-svc-packages install-wm install-dev-tools install-rust install-rust-tools
setup: make-symlinks install

make-symlinks: cli-tools::make-symlinks
  ln -sfn ~/0files/waybar ~/.config/waybar
  ln -sfn ~/0files/hypr ~/.config/hypr
  ln -sfn ~/0files/wofi ~/.config/wofi
  ln -sfn ~/0files/nvim ~/.config/nvim
  ln -sfn ~/0files/kitty ~/.config/kitty
  # Not technically a symlink but close
  echo 'export ZDOTDIR=~/0files/zsh' > ~/.zshenv
