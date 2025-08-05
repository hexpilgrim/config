# home/xdg.nix
{ pkgs, lib, ... }:

{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      music = "/mnt/Backups/Music";
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
  };
}
