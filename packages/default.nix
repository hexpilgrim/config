# packages/default.nix
{ pkgs, ... }:

{
  cursor = pkgs.callPackage ./cursor.nix { };
}
