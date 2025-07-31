# modules/packages.nix
{
  pkgs,
  ...
}:

{
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-shell-extensions
    gnome-tweaks
    gnome-software
    adwaita-icon-theme
    git
    gnupg
    pinentry-gnome3
    adw-gtk3
    nil
    nixfmt-rfc-style
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  # Systemd service to ensure Flathub repository is configured on boot
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ]; # Start once network is ready during boot
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Ensure 'flatpak' is in $PATH
    path = [ pkgs.flatpak ];

    # Idempotently add Flathub remote
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';

    # Run once, exit, and keep the service marked active post-execution
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
