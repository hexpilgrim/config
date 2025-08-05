# dev/default.nix
{ pkgs }:

{
  nodejs = import ./nodejs.nix { inherit pkgs; };
}
