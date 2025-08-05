# modules/mount-google-drive.nix
{
  config,
  pkgs,
  lib,
  user,
  ...
}:

let
  username = user.username;
  home = "/home/${username}";
  mountScriptPath = "${home}/.local/bin/mount-google-drive.sh";
  desktopEntryPath = "${home}/.config/autostart/google-drive.desktop";

  mountScript = ''
    #!/bin/bash
    LOG="${home}/.cache/google-drive-mount.log"
    echo "[INFO] Mounting at $(date)" >> "$LOG"

    until busctl --user --list | grep -q "org.gnome.OnlineAccounts"; do
      sleep 1
    done

    gio mount "google-drive://$(gsettings get org.gnome.OnlineAccounts account list | grep -oP '(?<=email\": \")[^\"']+')" >> "$LOG" 2>&1
  '';

  desktopEntry = ''
    [Desktop Entry]
    Type=Application
    Name=Google Drive Auto-Mount
    Exec=${mountScriptPath}
    X-GNOME-Autostart-enabled=true
  '';
in
{
  environment.systemPackages = [ pkgs.gnome.gvfs ];

  systemd.tmpfiles.rules = [
    "d ${home}/.local/bin 0755 ${username} users -"
    "d ${home}/.cache 0755 ${username} users -"
    "d ${home}/.config/autostart 0755 ${username} users -"
  ];

  system.activationScripts.mountGoogleDrive = lib.stringAfter [ "users" ] ''
    install -m 755 -o ${username} -g users -D ${pkgs.writeText "mount-google-drive.sh" mountScript} ${mountScriptPath}
    install -m 644 -o ${username} -g users -D ${pkgs.writeText "google-drive.desktop" desktopEntry} ${desktopEntryPath}
  '';
}
