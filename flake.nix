{
  description = "Nixos config flake";

  inputs = {
    # nixpgkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    #   home-manager = {
    #     url = "github:nix-community/home-manager/release-24.05";
    #     inputs.nixpkgs.follows = "nixpkgs";
    #   };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.epheotus = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs =
        {
          inherit inputs;

          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      modules = [
        # config file for default host (epheotus)
        ./configuration.nix
        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
