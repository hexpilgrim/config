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
  # Import full user-specific Home Manager config from ./home/*
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

  # Define the user's home directory and username
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";

    # Load Home Manager shell hooks on login (avoids hardcoded sourcing in .bashrc)
    file.".bashrc".text = ''
      [ -f "$HOME/.local/state/home-manager/environment" ] && source "$HOME/.local/state/home-manager/environment"
    '';

    # Lock Home Manager compatibility version
    stateVersion = "25.05";
  };

  # Bootstrap Home Manager functionality
  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

  # Enable XDG user directories
  xdg.userDirs = {
    enable = true;
    music = "/mnt/Backups/Music";
  };
}
