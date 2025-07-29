# home/spicetify.nix
{ pkgs, spicetify-nix, system, ... }:

# Load system-specific legacy Spicetify package set
let
  spicePkgs = spicetify-nix.legacyPackages.${system};

  # Helper to wrap app name and src for CustomApps
  mkCustomApp = name: src: { inherit name src; };
in
{
  # Import Spicetify module for Home Manager integration
  imports = [ spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    
    enabledExtensions = with spicePkgs.extensions; [
      	shuffle
      	adblock
      	hidePodcasts
    ];
    
	enabledCustomApps = with spicePkgs.apps; [
      (mkCustomApp "lyricsPlus" pkgs.lyricsPlus)
      (mkCustomApp "newReleases" pkgs.newReleases)
	];
		
	enabledSnippets = with spicePkgs.snippets; [
		autoHideFriends
		modernScrollbar
		hideNowPlayingViewButton
		hideFriendActivityButton
		hideMiniPlayerButton
	] ++ [
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

