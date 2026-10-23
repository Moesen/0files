{ config, ... }:
{
  home.stateVersion = "26.05";
  imports = [ ../modules/nixos/monitors.nix ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Moesen";
      user.email = "gustav@moesen.dk";
      pull.rebase = true;
      push.default = "current";
    };
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/nvim";
    "alacritty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/terms/alacritty";
    "ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/terms/ghostty";
    "zellij".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/cli-tools/zellij";
    "starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/cli-tools/starship.toml";
  };
  home.file.".zshenv".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/zsh/.zshenv";
}
