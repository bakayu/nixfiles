# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.home-manager.nixosModules.default

      # env variables
      ../../modules/env-variables/env-variables.nix

      # extensions
      ../../modules/extensions/gnome-extensions.nix

      # nixos modules
      ../../modules/nixos/gnome.nix
      ../../modules/nixos/power.nix
      ../../modules/nixos/hardware.nix
      ../../modules/nixos/nvidia.nix
      # off load (on-the-go) config
      # ../../modules/nixos/nvidia-offload.nix


      # services
      ../../modules/services/battery.nix
      ../../modules/services/wallpaper.nix

      # fonts
      ../../modules/fonts/fonts.nix

      # packages
      ../../modules/packages/system-packages.nix
      ../../modules/packages/nix-ld.nix
      ../../modules/packages/git.nix

      # user
      ../../modules/user/bakayu.nix
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



  networking.hostName = "epheotus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


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



  # List packages installed in system profile. To search, run:
  # $ nix search wget


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
