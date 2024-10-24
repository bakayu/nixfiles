# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, pkgs-unstable, inputs,... }:
 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.home-manager.nixosModules.default
      ./battery.nix
      ./gnome-extensions.nix
    ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # picking the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;


#  # Bootloader.
#  boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;

# enabling grub
  boot.loader = {
    grub = {
	enable = true;
	device = "nodev";
	useOSProber = true;
	efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  # Adds the missing asus functionality to Linux.
  # https://asus-linux.org/manual/asusctl-manual/
  services = {
    asusd = {
      enable = lib.mkDefault true;
      enableUserService = lib.mkDefault true;
    };
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau	
    ];
  };

  # AMD Microcode
  hardware.cpu.amd.updateMicrocode = 
	lib.mkDefault config.hardware.enableRedistributableFirmware;

#  # Load nvidia driver for Xorg and Wayland
#  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.

    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58.02";
      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
      openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
    };    

    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
 };

  # specilisation
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
      };
    };
  };

  # logind service
  services.logind = {
    lidSwitchExternalPower = "ignore";
  };

  # enable fstrim
  services.fstrim.enable = lib.mkDefault true;

  networking.hostName = "epheotus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # enable thermald
  services.thermald.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };


# default x11 + gnome settings

#  # Enable the X11 windowing system.
#  services.xserver.enable = true;
#
#  # Enable the GNOME Desktop Environment.
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;
#
#  # Configure keymap in X11
#  services.xserver = {
#    xkb.layout = "us";
#    xkb.variant = "";
#  };

# wayland - gnome settings
  services = {
    # Ensure gnome-settings-daemon udev rules are enabled.
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    xserver = {
	enable = true;
	displayManager = {
	    gdm = {
		enable = true;
		wayland = true;
	    };
	};
	# Enable Desktop Environment.
        desktopManager.gnome.enable = true;

	# configuring keymaps in X11
	xkb.layout = "us";
	xkb.variant = "";

	# Load nvidia driver for Xorg and Wayland
	videoDrivers = lib.mkDefault ["nvidia"];

    };
  };

  # enable support for non-nix executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    glib
  ];

  # change shell to zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;  

  # enabling git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config.credential.helper = "libsecret";
  };

  # enable flatpaks
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bakayu = {
    isNormalUser = true;
    description = "bakayu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # home-manager
  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     "bakayu" = import ./home.nix;
  #   };
  # };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.sessionVariables = {
    FLAKE = "/home/bakayu/nixfiles";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "~/steam/root/compatibilitytools.d";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # installing steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # pkgs to fetch from stable branch
  environment.systemPackages = with pkgs; [
    lutris
    google-chrome
    bottles
    mangohud
    protonup
    pkgs-unstable.neovim
    pkgs-unstable.vscode
    bootstrap-studio
    pkgs-unstable.ollama-cuda
    kitty
    alacritty
    wezterm
    brave
    vivaldi
    warp-terminal
    vivaldi-ffmpeg-codecs
    obs-studio
    element-desktop
    slack
    whatsapp-for-linux
    vesktop
    gradience
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    nitch
    neofetch
    fastfetch
    cava
    ripgrep
    zellij
    unzip
    gnumake
    libgcc
    gdb
    lldb
    clang
    clang-tools
    opencv
    gtk3
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
    lazygit
    git-credential-oauth
    tree-sitter
    python3
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
    drawing 
    gimp
    pkgs-unstable.spicetify-cli
    xclip
    zsh
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
    gnome.gnome-tweaks
    kdePackages.kdenlive
    nh
    nix-output-monitor
    nvd
    transmission
    qbittorrent
    aria2
    foliate
    evince
    zathura
    kdePackages.okular
    calibre
    persepolis
    p7zip
    unrar
    ffmpeg
    conda
    obsidian
    libreoffice-qt6-fresh
    libsForQt5.qt5ct
    onlyoffice-bin
    osu-lazer
    hub
    gh
    jq
    jetbrains-toolbox
    pkgs-unstable.eyewitness
    pkgs-unstable.nmap
    pkgs-unstable.ffuf
  ];  


  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    noto-fonts-monochrome-emoji

    # Nerd fonts
    fantasque-sans-mono
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
