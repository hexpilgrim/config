# home/mount-google-drive.nix
{
  config,
  pkgs,
  ...
}:

{
  # Mount script for GNOME Online Accounts → Google Drive
  home.file."${config.home.homeDirectory}/.local/bin/mount-google-drive.sh" = {
    text = ''
      #!/bin/bash

      LOG="$HOME/.cache/google-drive-mount.log"
      echo "[INFO] Mounting at $(date)" >> "$LOG"

      until busctl --user --list | grep -q "org.gnome.OnlineAccounts"; do
        sleep 1
      done

      # Attempt to mount Google Drive using GNOME Online Accounts
      gio mount "google-drive://$(gsettings get org.gnome.OnlineAccounts account list | grep -oP '(?<=email\": \")[^\"']+')" >> "$LOG" 2>&1
    '';
    executable = true;
  };

  # Autostart entry to run the mount script on login
  home.file."${config.home.homeDirectory}/.config/autostart/google-drive.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Google Drive Auto-Mount
      Exec=$HOME/.local/bin/mount-google-drive.sh
      X-GNOME-Autostart-enabled=true
    '';
  };

  # Activation hook to create necessary dirs before files are placed
  home.activation.ensure-google-drive-dirs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.cache"
    mkdir -p "$HOME/.config/autostart"
  '';

  # Dependency required for Google Drive mounting over GVFS
  home.packages = with pkgs; [
    gnome.gvfs # ensures `gio mount` can resolve Google Drive URLs
  ];
}
