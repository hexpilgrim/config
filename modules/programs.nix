# modules/programs.nix
{ pkgs, ... }:

{
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-shell-extensions
    gnome-tweaks
    gnome-software
    adwaita-icon-theme
    nautilus-open-any-terminal
    gradience
    git
    gnupg
    pinentry-gnome3
    adw-gtk3
    nil
    nixfmt-rfc-style
    spotify-patch
    unzip
    act
  ];

  environment.gnome.excludePackages = [ pkgs.gnome-console ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  security.pam.services.login.enableGnomeKeyring = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    path = [ pkgs.flatpak ];

    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
