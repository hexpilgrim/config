# home/packages.nix
{ pkgs, system, ... }:

{
  home.packages = with pkgs; [
    git
    ptyxis
    home-manager
    vscode
    fragments
    mission-center
    zapzap
    github-desktop
    popcorntime
    papers
    parabolic
    icon-library
    showtime
    keepassxc
    vesktop
    megasync
    protonvpn-gui
    #cloudflare-warp
    #code-cursor
    #iconic
  ];
}
