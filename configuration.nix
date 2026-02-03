{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "marco-nixos";
  networking.networkmanager.enable = true;

  # Timezone e locale
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

  # Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Layout tastiera IT + EN con switch Alt+Shift
  services.xserver.xkb = {
    layout = "it,us";
    variant = "";
    options = "grp:alt_shift_toggle";
  };
  console.keyMap = "it";

  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.marco = {
    isNormalUser = true;
    description = "Marco Perini";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "vboxusers" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Browser
    brave
    google-chrome
    firefox

    # Editor / IDE
    vscode
    neovim
    vim

    # Dev tools
    git
    python313
    wget
    curl
    gnupg
    jdk21

    # Communication
    telegram-desktop
    discord
    thunderbird
    session-desktop

    # Media
    vlc
    obs-studio

    # Utilities
    balenaetcher
    qbittorrent
    _7zz
    unrar
    htop
    btop

    # System
    gparted
    
    # Virtualizzazione
    virtualbox
  ];

  # Flatpak
  services.flatpak.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Firewall
  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
