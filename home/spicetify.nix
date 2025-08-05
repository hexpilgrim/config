# home/spicetify.nix
{
  pkgs,
  spicetify-nix,
  system,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${system};

  mkCustomApp = name: src: {
    inherit name src;
  };
in
{
  imports = [ spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      adblock
      hidePodcasts
    ];

    enabledCustomApps = with spicePkgs.apps; [
      (mkCustomApp "lyricsPlus" pkgs.lyricsPlus)
      (mkCustomApp "newReleases" pkgs.newReleases)
    ];

    enabledSnippets =
      with spicePkgs.snippets;
      [
        autoHideFriends
        modernScrollbar
        hideNowPlayingViewButton
        hideFriendActivityButton
        hideMiniPlayerButton
        removeGradient
        removeDuplicatedFullscreenButton
      ]
      ++ [
        ''
          /* Hide homepage filter buttons: All, Music, Podcasts, Audiobooks */
          [aria-label="All"],
          [aria-label="Music"],
          [aria-label="Podcasts"],
          [aria-label="Audiobooks"] {
            display: none !important;
          }
        ''
      ];
  };
}
