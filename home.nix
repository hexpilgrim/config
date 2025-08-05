# home.nix
{
  pkgs,
  lib,
  spicetify-nix,
  user,
  system,
  ...
}:

{
  imports = [
    (import ./home {
      inherit
        pkgs
        lib
        spicetify-nix
        system
        ;
    })
  ];

  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";

  home.file = {
    ".bashrc".text = ''
      [ -f "$HOME/.local/state/home-manager/environment" ] && source "$HOME/.local/state/home-manager/environment"
    '';
  };

  home.stateVersion = "25.05";

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

  xdg.userDirs = {
    enable = true;
    music = "/mnt/Backups/Music";
  };
}
