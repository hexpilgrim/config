# dev/default.nix
{
  pkgs,
}:

{
  nodejs = import ./nodejs.nix { pkgs = pkgs; };
}
