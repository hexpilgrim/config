{ spicePkgs, ... }:

{
  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      newReleases
    ];

    enabledSnippets =
      with spicePkgs.snippets;
      [
        autoHideFriends
        modernScrollbar
        hideNowPlayingViewButton
        hideFriendActivityButton
        hideMiniPlayerButton
      ]
      ++ [
        ''
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
