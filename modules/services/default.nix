# modules/services/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./warp.nix
  ];
}