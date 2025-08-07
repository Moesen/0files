mod cli-tools

svc_packages := "pipewire pipewire-pulse bluez"
wm_packages := "hyprland xdg-desktop-portal-hyprland"
wm_util_packages := "wofi hyprlock waybar wl-clipboard otf-font-awesome thunar"
dev_dependencies := "nodejs-lts-jod npm pnpm"
dev_packages := "neovim zsh just kitty fzf docker bat jq yq"
work_packages := "kubectl helm helmfile"
work_apps := "mattermost-desktop"

[group("Default")]
default:
  @just --list

[group("Yay")]
install-svc-packages:
  yay -S --needed {{svc_packages}}
[group("Yay")]
install-wm:
  yay -S --needed {{wm_packages}}
  yay -S --needed {{wm_util_packages}}
[group("Yay")]
install-dev-dependencies:
  yay -S --needed {{dev_dependencies}}
[group("Yay")]
install-dev-tools:
  yay -S --needed {{dev_packages}}
[group("Yay")]
install-rust:
  yay -S --needed rustup
[group("Cargo")]
install-rust-tools: install-rust
  cargo install starship --locked
  cargo install du-dust --locked
  cargo install fd-find --locked
  cargo install eza --locked
  cargo install zellij --locked
  cargo install zoxide --locked
[group("Cargo")]
install-uv: install-rust
  cargo install --locked --git https://github.com/astral-sh/uv uv

[group("Yay")]
install-work-packages:
  yay -S --needed {{work_packages}}
[group("Yay")]
install-work-apps:
  yay -S --needed {{work_apps}}

[group("Config")]
setup-work-env: install-work-packages install-work-apps
  [[ -d ~/alvenir/ ]] || mkdir ~/alvenir/

[group("Config")]
configure-git:
  git config --global user.name "Moesen"
  git config --global user.email "gustavmoesmand@proton.me"
  git config --global pull.rebase true
  git config --global push.default current


[group("Config")]
make-symlinks: cli-tools::make-symlinks
  ln -sfn ~/0files/waybar ~/.config/waybar
  ln -sfn ~/0files/hypr ~/.config/hypr
  ln -sfn ~/0files/wofi ~/.config/wofi
  ln -sfn ~/0files/nvim ~/.config/nvim
  ln -sfn ~/0files/kitty ~/.config/kitty
  ln -sfn ~/0files/dunst ~/.config/dunst
  # Not technically a symlink but close
  echo 'export ZDOTDIR=~/0files/zsh' > ~/.zshenv

install: install-svc-packages install-wm install-dev-tools install-rust install-rust-tools
setup: make-symlinks install
