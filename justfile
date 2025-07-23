svc_packages := "pipewire pipewire-pulse bluez"
wm_packages := "hyprland xdg-desktop-portal-hyprland"
wm_util_packages := "wofi hyprlock waybar wl-clipboard otf-font-awesome"
dev_packages := "neovim zsh just kitty fzf docker"

default:
	@just --list

install-svc-packages:
	yay -S --needed {{svc_packages}}
install-wm:
	yay -S --needed {{wm_packages}}
	yay -S --needed {{wm_util_packages}}
install-dev-tools:
	yay -S --needed {{dev_packages}}

install-rust:
	yay -S rustup

install-rust-cli-tools: install-rust
	cargo install starship --locked


install: install-svc-packages install-wm install-dev-tools install-rust install-rust-cli-tools
setup: make-symlinks install

make-symlinks:
	ln -sfn ~/0files/waybar ~/.config/waybar
	ln -sfn ~/0files/hypr ~/.config/hypr
	ln -sfn ~/0files/wofi ~/.config/wofi
	ln -sfn ~/0files/nvim ~/.config/nvim
	ln -sfn ~/0files/kitty ~/.config/kitty

	# Not technically a symlink but close
	echo 'export ZDOTDIR=~/0files/zsh' > ~/.zshenv
