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

  home = {
    stateVersion = "25.05";

    username = user.username;
    homeDirectory = "/home/${user.username}";

    file = {
      ".bashrc".text = ''
        [ -f "$HOME/.local/state/home-manager/environment" ] && source "$HOME/.local/state/home-manager/environment"
      '';
    };
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };
}
