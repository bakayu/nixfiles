{ lib, config, pkgs, ... }:
{
  # AMD Microcode
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # graphics
  hardware.graphics = {
    enable = true;

    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # enable fstrim
  services.fstrim.enable = lib.mkDefault true;

  # logind service
  services.logind = {
    lidSwitchExternalPower = "ignore";
    lidSwitch = "ignore";
  };
}
