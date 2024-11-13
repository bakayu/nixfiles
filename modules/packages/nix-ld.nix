{ pkgs, ... }:
{
  # enable support for non-nix executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    glib
    glibc
    gtk3
    gtk4
  ];
}
