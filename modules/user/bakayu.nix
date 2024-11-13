{ pkgs, ... }:
{
  users.users.bakayu = {
    isNormalUser = true;
    description = "bakayu";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.nushell;
  };

  environment.shells = [
    pkgs.nushell
  ];

  # change shell to zsh
  # programs.zsh.enable = true;
  # users.defaultUserShell = pkgs.zsh;  

  # change shell to nushell
  # programs.nushell.enable = true;
  users.defaultUserShell = pkgs.nushell;

  # enable flatpaks
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

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

}
