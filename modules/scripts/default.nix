# modules/scripts/default.nix
{ lib, ... }:

{
  imports = [
    ./git-wrapper.nix
  ];
}
