{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    arcmenu
    vitals
    caffeine
    openweather
    gsconnect
    clipboard-indicator
    app-icons-taskbar
    appindicator
    just-perfection
    forge
    # ...
  ];
}
