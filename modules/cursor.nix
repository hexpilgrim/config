# modules/cursor.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (import ../packages/cursor.nix { inherit pkgs; })
    (pkgs.makeDesktopItem {
      name = "cursor";
      exec = "cursor";
      icon = "cursor";
      desktopName = "Cursor";
      comment = "AI-powered code editor";
      categories = [ "Development" ];
    })
  ];
}

