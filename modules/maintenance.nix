# modules/maintenance.nix
{ ... }:

{
  # Automatic system upgrade (no reboot)
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  # Automatic garbage collection weekly, removing items older than 7 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Backup current /etc/nixos config and cleanup old backups
  system.activationScripts.postActivation = {
    text = ''
      log="/var/log/nixos-maintenance.log"
      backup_root="/var/backups/nixos-etc"

      echo "[Backup] Saving current /etc/nixos snapshot..." | tee -a "$log"

      timestamp="$(date +%Y-%m-%d-%H%M%S)"
      backup_dir="$backup_root/$timestamp"
      mkdir -p "$backup_dir"
      cp -a /etc/nixos "$backup_dir"

      echo "[Backup] Done: $backup_dir" | tee -a "$log"

      max_backups=10
      echo "[Cleanup] Retaining only the latest $max_backups backups..." | tee -a "$log"

      # Delete older backups, keep the newest $max_backups
      ls -dt "$backup_root"/* 2>/dev/null | tail -n +$((max_backups + 1)) | while read -r old; do
        rm -rf "$old"
        echo "[Cleanup] Removed: $old" | tee -a "$log"
      done

      echo "[Maintenance] Done at $(date)" | tee -a "$log"
    '';
  };
}
