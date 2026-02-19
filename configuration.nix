{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ];

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Network configuration
  networking.hostName = "aleph0"; # Define your hostname.
    networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Set your time zone.
  time.timeZone = "America/Bogota";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
# console = {
#   font = "Lat2-Terminus16";
#   keyMap = "us";
#   useXkbConfig = true; # use xkb.options in tty.
# };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  services.displayManager.ly.enable = true;

# Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.oxwm.enable = true;
    xkb = {
      layout = "us,latam";
      options = "grp:alt_shift_toggle";
    };
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/.dotfiles/walls/wall.png
      xset r rate 200 35 &
      '';
  };

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.ch1p = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      tree
        alacritty
        neovim
        wiremix
        rofi
      ];
  };

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

# List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
      wget
      git
      xclip
      xwallpaper
  ];
  programs.bash = {
    promptInit = ''
      '';
  };

  system.stateVersion = "25.11"; 
}

