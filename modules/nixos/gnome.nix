{ lib, pkgs, ... }:
{
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
      videoDrivers = lib.mkDefault [ "nvidia" ];

    };
  };

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
}
