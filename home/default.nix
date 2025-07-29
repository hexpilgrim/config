# home/default.nix
{ pkgs, lib, spicetify-nix, system, ... }:

{
  imports = [
    (import ./packages.nix { inherit pkgs system; })
    (import ./spicetify.nix { inherit pkgs spicetify-nix system; })
    (import ./gnome.nix { inherit pkgs lib; })
    (import ./firefox.nix { inherit pkgs; })
    (import ./gaming.nix { inherit pkgs; })
    #./mount-google-drive.nix # inherit config, pkgs
  ];
}
