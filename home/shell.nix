# home/shell.nix
{ lib, ... }:

{
  programs.bash = {
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      gpull = "git pull";
      gpush = "git push";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      hms = "home-manager switch --flake ~/.config/home-manager";
    };
  };
}
