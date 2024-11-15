{ config, lib, pkgs, ... }:

let
  switchWallpaper = pkgs.writeShellScript "switch-wallpaper.sh" ''
    #!/bin/bash

    HOUR=$(date +%H)

    if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 18 ]; then
      gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji.png'
    else
      gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji_dark.png'
    fi
  '';
in
{
  systemd.services.switch-wallpaper = {
    description = "Switch GNOME wallpaper based on time";
    execStart = "${switchWallpaper}";
    user = "bakayu";
    environment = {
      DISPLAY = ":0";
      XAUTHORITY = "/home/bakayu/.Xauthority";
    };
  };

  systemd.timers.switch-wallpaper-timer = {
    description = "Timer to switch wallpaper every hour";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
    };
    unitConfig = {
      After = [ "graphical.target" ];
      Wants = [ "switch-wallpaper.service" ];
    };
  };
}
