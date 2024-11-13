{ lib, config, pkgs, ... }:
{
  # AMD Microcode
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
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
