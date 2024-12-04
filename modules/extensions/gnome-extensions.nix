{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    arcmenu
    vitals
    caffeine
    gsconnect
    clipboard-indicator
    app-icons-taskbar
    appindicator
    just-perfection
    color-picker
    forge
    cronomix
    # ...
  ];
}
