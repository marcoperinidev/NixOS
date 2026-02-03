{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "$USER-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "it_IT.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # === SERVICES ===
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "it,us";
    options = "grp:alt_shift_toggle";
  };
  console.keyMap = "it";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;
  services.flatpak.enable = true;


  # === HARDWARE ===
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };



  # === CONFIG ===
  xdg.portal.enable = true;



  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Base tools
    neovim
    git
    wget
    curl
    tree
    htop
    nettools
    bind

    # Browsers
    firefox
    brave
    google-chrome

    # Messaging
    # telegram-desktop
    # whatsie

    # Email
    thunderbird

    # Editors
    notepad-next

    # Dev
    python3

    # Streaming
    # stremio

    # Work
    teamviewer
    teams-for-linux
    virtualboxWithExtpack
  ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.$USER = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "bluetooth" ];
  };


  system.stateVersion = "25.11";
}
