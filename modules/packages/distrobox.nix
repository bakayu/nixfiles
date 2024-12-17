{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
  };

  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = [ pkgs.distrobox ];
}
