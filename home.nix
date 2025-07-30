# home.nix
{ pkgs, lib, spicetify-nix, user, system, ... }:

{
  # Import full user-specific Home Manager config from ./home/*
  # This allows separation between user identity (username, dir)
  # and system-affecting user configuration like Spicetify, GTK, etc.
  # It also allows ./home to stay reusable across hosts or bootstraps.
  imports = [ (import ./home { inherit pkgs lib spicetify-nix system; }) ];
  
  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";

  # Bootstrap Home Manager functionality
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  # Inject the nixos-rebuild wrapper function
  programs.bash.shellInit = ''
    nixos-rebuild() {
      IS_LOCAL_BUILD=1 command nixos-rebuild "$@"
    }
  '';

  # Load Home Manager shell hooks on login (avoids hardcoded sourcing in .bashrc)
  home.file.".bashrc".text = ''
  # Loads Home Manager environment hooks (such as shellInit)
  # Required for aliases and exported paths defined in Home Manager modules
    [ -f "$HOME/.local/state/home-manager/environment" ] && source "$HOME/.local/state/home-manager/environment"
  '';

  xdg.userDirs = {
    enable = true;
    music = "/mnt/Backups/Music";
  };

  # Lock Home Manager compatibility version
  home.stateVersion = "25.05";
}

