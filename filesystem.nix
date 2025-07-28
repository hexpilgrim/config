{ ... }:

{
  fileSystems."/mnt/Backups" = {
    device = "LABEL=Backups";
    fsType = "auto";
    options = [
      "nosuid"
      "nodev"
      "nofail"
      "x-gvfs-show"
    ];
  };
}
