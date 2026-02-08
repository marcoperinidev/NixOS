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
  security.sudo.extraConfig = ''
    Defaults !sudoedit_checkdir
    Defaults lecture = never
  '';
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;
  services.flatpak.enable = true;
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
  nixpkgs.config.permittedInsecurePackages = false;

  # === EDITOR ===
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # === ZSH ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = ''
      HISTFILE="$HOME/.zsh_history"
      export EDITOR="nvim"
      export VISUAL="nvim"
    '';

    interactiveShellInit = ''
      # Case insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      
      # History search con frecce
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';

    histSize = 10000;
  };

  # === FONTS ===
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  # === PACKAGES ===
  environment.systemPackages = with pkgs; [
    # Base tools
    neovim
    p7zip
    unzip
    unrar
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

    # Neovim deps
    wl-clipboard
    ripgrep
    fd
    fzf

    # LSP and formatters
    nodePackages.prettier
    prettier
    vscode-json-languageserver
    nil
    nixd
    nixfmt-classic
    yamlfmt
    lua-language-server
    javascript-typescript-langserver
    bashdb
    bash-language-server
    stylua
    shfmt
    pyright
    ruff

    # Treesitter
    gcc
    gnumake

    # Extras
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
    ferdium

    # Editors
    notepad-next

    # Dev
    python3
    nodejs_22
    cargo
    libx11
    libxcb
    libxcb-util
    makeself
    qmake2cmake
    javaPackages.compiler.temurin-bin.jre-21
    javaPackages.compiler.temurin-bin.jdk-21
    bash-completion
    libsForQt5.qt5.qtbase
    kdePackages.qtbase

    # Work
    teamviewer
    #teams-for-linux
    virtualboxWithExtpack
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "$USER" ];

  users.users.$USER = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "bluetooth" "flatpak" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.11";
}
