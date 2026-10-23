{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    just
    kitty
    fzf
    bat
    jq
    yq
    antidote
    nodejs_22
    pnpm
    rustup
    starship
    dust
    fd
    eza
    zellij
    ripgrep
    tailspin
    watchexec
    uv
    ruff
    ty
    nixd
    nixfmt
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
  };
}
