{ pkgs, ... }:

{
  programs.firefox.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
