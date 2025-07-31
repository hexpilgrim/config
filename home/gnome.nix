# home/gnome.nix
{
  pkgs,
  ...
}:

{
  programs.gnome-shell.enable = true;

  home.packages =
    with pkgs;
    [
      dconf
    ]
    ++ (with gnomeExtensions; [
      appindicator
      blur-my-shell
      just-perfection
      app-hider
      appindicator
      rounded-window-corners-reborn
      bluetooth-battery-meter
      reorder-workspaces
      osd-volume-number
      night-theme-switcher
      cloudflare-warp-toggle
    ]);

  dconf.settings = {
    # App Hider settings
    "org/gnome/shell/extensions/app-hider" = {
      hidden-apps = [
        "org.gnome.Geary.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.Maps.desktop"
        "org.gnome.Music.desktop"
        "org.gnome.Totem.desktop"
        "org.gnome.Snapshot.desktop"
        "org.gnome.Characters.desktop"
        "nixos-manual.desktop"
        "org.gnome.Tour.desktop"
        "yelp.desktop"
        "xterm.desktop"
        "org.gnome.Epiphany.desktop"
      ];
    };

    # Blur My Shell settings
    "org/gnome/shell/extensions/blur-my-shell" = {
      panelBlur = true;
      dashBlur = true;
      overviewBlur = true;
      lockscreenBlur = true;
      hacks-level = 2; # 0 = high performance, 1 = default, 2 = no artifacts
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      style-dialogs = 3; # 0 = no style, 1 = transparent, 2 = light, 3 = dark
    };

    # Just Perfection settings
    "org/gnome/shell/extensions/just-perfection" = {
      events-button = false;
      world-clock = false;
      quick-settings-night-light = false;
    };

    # Rounded Window Corners Reborn settings
    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      border-radius = 12; # in px
      clip-padding = 4; # in px
      shadow-enabled = true;
      superellipse-shape = true;
      blacklist = [
        "vlc"
        "steam"
      ];
    };

    # Bluetooth Battery Meter settings
    "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
      enable-battery-indicator = false;
      enable-battery-level-text = true;
      enable-upower-level-icon = true;
      swap-icon-text = false;
    };

    # Night Theme Switcher settings
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = true;
      sunrise = 7.0; # hour.minute
      sunset = 16.0; # hour.minute
    };
  };
}
