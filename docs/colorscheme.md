# Gruvbox

The active configurations use [morhetz/gruvbox](https://github.com/morhetz/gruvbox),
dark with medium contrast. The palette comes from its
[`colors/gruvbox.vim`](https://github.com/morhetz/gruvbox/blob/ef8864bb42bf244f0295d1c5a403b27e3d139695/colors/gruvbox.vim).
Terminal ANSI slots 0–15 match the plugin's dark-mode terminal colors.

| Component | Configuration / palette |
| --- | --- |
| Neovim | `nvim/lua/plugins/colorscheme.lua` (`morhetz/gruvbox` in Lazy) |
| Ghostty | `terms/ghostty/config`, `terms/ghostty/gruvbox.ghostty` |
| Alacritty | `terms/alacritty/alacritty.toml`, `terms/alacritty/themes/gruvbox/gruvbox-dark.toml` |
| Kitty | `terms/kitty/kitty.conf`, `terms/kitty/gruvbox.conf` |
| Zellij | `cli-tools/zellij/config.kdl`, `cli-tools/zellij/themes/gruvbox-dark.kdl` |
| Starship | `cli-tools/starship.toml`, palette `gruvbox_dark` |
| fzf | `zsh/options.zsh` |
| macOS borders | `aerospace/.aerospace.toml` |
| Hyprland / Hyprlock | `hypr/hyprland.conf`, `hypr/hyprlock.conf` |
| Waybar | `waybar/style.css`, Docker icon in `waybar/config.jsonc` |
| Wofi | `wofi/style.css`, `wofi/custom/game-launcher/launch-game.css` |
| Dunst | `dunst/dunstrc` |

Neovim restores the saved background mode and toggles with `<leader>mbg`.
Its custom statusline indicator follows the Gruvbox highlight groups.
Other applications use the dark palette independently of that toggle.
Hyprpaper and the wallpaper randomizer use the existing `wallpapers/dark` collection.

Reload or reopen applications to pick up their configuration changes. Start a new
shell for the updated fzf options. Existing alternative theme files are retained.
