# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.keyd = {
  	enable = true;
	keyboards.default = {
		ids = [ "*" ];
		settings.main = {
			capslock = "esc";
		};
	};
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."moesen" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Gustav";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  home-manager.users.moesen = { config, pkgs, ...}: {
    home.stateVersion = "26.05";

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
           "alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/terms/alacritty";
           "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/terms/ghostty";
           "zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/cli-tools/zellij";
           "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/cli-tools/starship.toml";
     };
     home.file.".zshenv".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/0files/zsh/.zshenv";

  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
  	enable = true;
	enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
  	modesetting.enable = true;
	open = true;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
  	# dev packages
  	neovim just kitty fzf bat jq yq antidote
	# dev_deps (a lot of lsp's for nvim depend on (p)npm
	nodejs_22 pnpm
	# rust toolchain
	rustup
	# cargo tools / upgrades
	starship dust fd eza zellij ripgrep tailspin watchexec
	# python dev
	uv ruff ty

  	pciutils git wl-clipboard
  ];

  programs.neovim = {
  	enable = true;
	defaultEditor = true;
	withPython3 = true;
  };

  fonts.packages = with pkgs; [
	  font-awesome
	  nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
}
