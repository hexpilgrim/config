# modules/maintenance.nix
{ ... }:

{
  # Automatically upgrade the system using NixOS channel updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  # Enable automatic garbage collection to keep the system clean
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  # Backup the current /etc/nixos config & Log restults
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
      
      # List sorted backup folders (most recent first), skip the newest N, and delete older ones
      ls -dt "$backup_root"/* 2>/dev/null | tail -n +$((max_backups + 1)) | while read -r old; do
        rm -rf "$old"
        echo "[Cleanup] Removed: $old" | tee -a "$log"
      done

      echo "[Maintenance] Done at $(date)" | tee -a "$log"
    '';
	};
}

