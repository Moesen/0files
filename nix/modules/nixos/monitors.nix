{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "display-tv" ''
      ${pkgs.mutter}/bin/gdctl set --logical-monitor --primary --monitor HDMI-1 --mode 1920x1080@60.000
    '')
    (pkgs.writeShellScriptBin "display-main" ''
      ${pkgs.mutter}/bin/gdctl set --logical-monitor --primary --monitor HDMI-2 --mode 3440x1440@120.000
    '')
  ];

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "TV mode";
      command = "display-tv";
      binding = "<Super><Shift>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Main display";
      command = "display-main";
      binding = "<Super><Shift>m";
    };
  };
}
