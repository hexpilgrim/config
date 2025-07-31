# modules/mount-google-drive.nix
{
  pkgs,
  user,
  ...
}:

let
  home = "/home/${user.username}";
in
{

  # Ensure GVfs is available system-wide to support Google Drive mounting via GNOME
  environment.systemPackages = with pkgs; [ gnome.gvfs ];

  # Create a GNOME autostart .desktop entry to auto-run the mount script at user login
  environment.etc."autostart/google-drive.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Google Drive Auto-Mount
      Exec=${home}/.local/bin/mount-google-drive.sh
      X-GNOME-Autostart-enabled=true
    '';
    mode = "0644"; # File is readable by all users but only writable by root
    target = "${home}/.config/autostart/google-drive.desktop"; # Ensure it's placed in the user's autostart folder
  };

  # Provide the actual shell script that handles Google Drive mounting at login
  environment.etc."scripts/mount-google-drive.sh" = {
    text = ''
      #!/bin/bash

      # Define the path to the log file for mount activity
      LOG="${home}/.cache/google-drive-mount.log"
      echo "[INFO] Mounting at $(date)" >> "$LOG"

      # Wait until GNOME Online Accounts DBus service becomes available
      until busctl --user --list | grep -q "org.gnome.OnlineAccounts"; do
        sleep 1
      done

      # Try to mount the user's Google Drive using gio and the discovered email address
      gio mount "google-drive://$(gsettings get org.gnome.OnlineAccounts account list | grep -oP '(?<=email\": \")[^\"']+')" >> "$LOG" 2>&1
    '';
    mode = "0755"; # Script is executable by the owner, readable by others
    target = "${home}/.local/bin/mount-google-drive.sh"; # Install to the user's local binary path
  };

  # Ensure required directories exist at boot with correct ownership and permissions
  systemd.tmpfiles.rules = [
    "d ${home}/.local/bin 0755 ${user.username} users -" # Create ~/.local/bin for the script if missing
    "d ${home}/.cache 0755 ${user.username} users -" # Create ~/.cache for the mount log
    "d ${home}/.config/autostart 0755 ${user.username} users -" # Create ~/.config/autostart for the .desktop entry
  ];
}
