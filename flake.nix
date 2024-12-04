{
  description = "Nixos config flake";

  inputs = {
    # nixpgkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix-ld
    nix-ld.url = "github:Mic92/nix-ld";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager
    #   home-manager = {
    #     url = "github:nix-community/home-manager/release-24.11";
    #     inputs.nixpkgs.follows = "nixpkgs";
    #   };
  };

  outputs = { self, nix-ld, nixpkgs, nixpkgs-unstable, ... }@inputs: {
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
        ./hosts/default/configuration.nix
        # inputs.home-manager.nixosModules.default

        # enable nix-ld
        nix-ld.nixosModules.nix-ld

        # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
        # to not collide with the nixpkgs version.
        { programs.nix-ld.dev.enable = true; }
      ];
    };
  };
}
