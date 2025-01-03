{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    google-chrome
    pkgs-unstable.neovim
    pkgs-unstable.vscode
    # pkgs-unstable.vscode-fhs
    direnv
    pkgs-unstable.ollama
    azure-cli
    kitty
    alacritty
    wezterm
    brave
    vivaldi
    vivaldi-ffmpeg-codecs
    obs-studio
    element-desktop
    signal-desktop
    slack
    whatsapp-for-linux
    vesktop
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    nitch
    neofetch
    fastfetch
    cava
    charasay
    showmethekey
    ripgrep
    fd
    pkgs-unstable.zellij
    unzip
    gnumake
    libgcc
    gdb
    lldb
    clang
    clang-tools
    opencv
    gtk3
    gtk4
    pkg-config
    atk
    cairo
    pango
    gdk-pixbuf
    llvmPackages.libcxxClang
    llvmPackages.libclc
    chromedriver
    chromium
    libglibutil
    glib
    glibc
    nss
    nspr
    xcbuild
    nodejs_22
    go
    gopls
    zig
    nil
    nixd
    nixpkgs-fmt
    lazygit
    git-credential-oauth
    tree-sitter
    python3
    pkgs-unstable.poetry
    go
    gopls
    delve
    htop
    zenith-nvidia
    lm_sensors
    bottom
    gparted
    vlc
    pavucontrol
    krita
    pkgs-unstable.inkscape
    drawing
    gimp
    xclip
    zsh
    pkgs-unstable.nushell
    carapace
    fzf
    eza
    zoxide
    bat
    starship
    terminal-parrot
    cmatrix
    pipes
    cbonsai
    nerdfetch
    lshw
    psmisc
    gnome-tweaks
    kdePackages.kdenlive
    nh
    nix-output-monitor
    nvd
    foliate
    evince
    p7zip
    unrar
    ffmpeg
    conda
    obsidian
    pdfarranger
    libreoffice-qt6-fresh
    libsForQt5.qt5ct
    onlyoffice-bin
    # osu-lazer
    gh
    pkgs-unstable.act
    jq
    jetbrains-toolbox
    pkgs-unstable.eyewitness
    pkgs-unstable.nmap
    pkgs-unstable.ffuf
    openmodelica.omcompiler
    openmodelica.omlibrary
    # openmodelica.combined
  ];
}
