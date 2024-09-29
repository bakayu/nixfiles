{lib, pkgs}:
let
unstable = import <nixos-unstable> { config.allowUnfree = true; };
in
{
nixpkgs.config = {
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    ];

    packageOverrides = pkgs: {
      vscode = unstable.vscode;
    };
  };
}
