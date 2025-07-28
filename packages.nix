{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
    pinentry-gnome3
    adw-gtk3
    megasync
    github-desktop
    nil
    nixfmt-rfc-style
    vscode
  ];
}
