# home/programs.nix
{ pkgs, ... }:

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
    sticky-notes
    keepassxc
    vesktop
    megasync
    protonvpn-gui
    #cloudflare-warp
    #code-cursor
    #iconic
    deja-dup
    gnome-text-editor
    qbittorrent
    onlyoffice-desktopeditors
    gnome-logs
    impression
    loupe
    gnome-calculator
    gnome-calendar
    decibels
    gnome-boxes
    baobab
    simple-scan
    gnome-extension-manager
  ];
}
