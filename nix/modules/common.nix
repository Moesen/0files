{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.signal-desktop
    pkgs.slack
    pkgs.discord
    pkgs.alacritty
  ];
}
