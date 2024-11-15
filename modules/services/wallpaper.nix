{ config, lib, pkgs, ... }:

let
  switchWallpaper = pkgs.writeShellScript "switch-wallpaper.sh" ''
    #!/bin/bash

    HOUR=$(date +%H)

    if [ "$HOUR" -ge 6 ] && [ "$HOUR" < 18 ]; then
      gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji.png'
    else
      gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji_dark.png'
    fi
  '';
in
{
  systemd.services.switch-wallpaper = {
    description = "Switch GNOME wallpaper based on time";
    serviceConfig = {
      ExecStart = "${switchWallpaper}";
      User = "bakayu";
      Environment = "DISPLAY=:0";
      XAUTHORITY = "/home/bakayu/.Xauthority";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.timers.switch-wallpaper-timer = {
    description = "Timer to switch wallpaper every hour";
    timerConfig = {
      OnCalendar = "hourly";
    };
    unitConfig = {
      After = [ "graphical.target" ];
      Wants = [ "switch-wallpaper.service" ];
    };
    wantedBy = [ "timers.target" ];
  };
}
