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
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "it,us";
    options = "grp:alt_shift_toggle";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
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

  # Flatpak FULL: repo + xdg-desktop-portal
  services.flatpak.enable = true;

  # TeamViewer: enable daemon service
  services.teamviewer.enable = true;

  # === HARDWARE ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
    "qtwebengine-5.15.19"
  ];

  # === CONFIG ===

  environment.systemPackages = with pkgs; [
    # Base tools
    neovim
    git
    wget
    curl
    tree
    htop
    nettools
    ffmpeg-full
    mpv
    vlc
    bind
    pciutils
    hardinfo2
    flatpak
    appimage-run
    kdePackages.plasma-browser-integration

    # === Neovim ===
    wl-clipboard

    # search and navigation
    ripgrep
    fd
    fzf

    # LSP and format
    nil
    nixd
    lua-language-server
    javascript-typescript-langserver
    bashdb
    bash-language-server
    stylua
    pyright
    ruff

    # Treesitter
    gcc
    gnumake

    # extras
    lazygit
    tree-sitter
    vimPlugins.nvim-treesitter-parsers.bash

    # Torrent
    qbittorrent
    stremio

    # Browsers
    firefox
    brave
    google-chrome

    # Email
    thunderbird

    # Messaging
    #beeper -- una vera merda-privacy problems
    ferdium

    # Editors
    notepad-next

    # Dev
    python3
    nodejs_22
    cargo
    pkgs.libx11
    pkgs.libxcb
    pkgs.libxcb-util
    makeself
    qmake2cmake
    javaPackages.compiler.temurin-bin.jre-21
    javaPackages.compiler.temurin-bin.jdk-21
    bash-completion
    pkgs.libsForQt5.qt5.qtbase
    pkgs.kdePackages.qtbase

    # Work
    teamviewer
    teams-for-linux
    virtualboxWithExtpack
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.$USER = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "bluetooth"
      "flatpak"
    ];
  };

  system.stateVersion = "25.11";
}
