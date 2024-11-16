{ config, lib, pkgs, ... }:

let
  # Define the wallpaper switching script
  switchWallpaper = pkgs.writeScriptBin "switch-wallpaper.sh" ''
    #!/usr/bin/env bash

    LOG_FILE="/home/bakayu/switch-wallpaper.log"

    echo "Script started at $(date)" >> "$LOG_FILE"

    HOUR=$(date +%H)
    echo "Current hour: $HOUR" >> "$LOG_FILE"

    if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 18 ]; then
      /run/current-system/sw/bin/gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji.png' >> "$LOG_FILE" 2>&1
      echo "Set to light wallpaper." >> "$LOG_FILE"
    else
      /run/current-system/sw/bin/gsettings set org.gnome.desktop.background picture-uri 'file:///home/bakayu/data/media/fuji_dark.png' >> "$LOG_FILE" 2>&1
      echo "Set to dark wallpaper." >> "$LOG_FILE"
    fi

    echo "Script ended at $(date)" >> "$LOG_FILE"
  '';
in
{
  # Ensure necessary packages are available
  environment.systemPackages = with pkgs; [
    glib
    gsettings-desktop-schemas
    dbus
  ];

  # Define the systemd service
  systemd.services.switch-wallpaper = {
    description = "Switch GNOME wallpaper based on time";

    # Ensure the service starts after graphical and D-Bus services
    after = [ "graphical.target" "dbus.service" ];
    wants = [ "dbus.service" ];

    # Service Configuration ([Service] section)
    serviceConfig = {
      ExecStart = "${switchWallpaper}/bin/switch-wallpaper.sh"; # Corrected ExecStart path
      User = "bakayu";
      Environment = [
        "DISPLAY=:0"
        "XAUTHORITY=/home/bakayu/.Xauthority"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
        "PATH=/run/current-system/sw/bin:/nix/store/$(basename ${pkgs.glib})/bin:/usr/bin:/bin"
      ];
      # Ensure the script is executed with the correct PATH and environment
    };
  };

  # Define the systemd timer
  systemd.timers.switch-wallpaper-timer = {
    description = "Timer to switch wallpaper every hour";

    # Timer Configuration ([Timer] section)
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };

    # Unit Configuration for Timer ([Unit] section)
    unitConfig = {
      after = [ "graphical.target" ];
      wants = [ "switch-wallpaper.service" ];
    };

    # Link the timer to the timers.target
    wantedBy = [ "timers.target" ];
  };
}
