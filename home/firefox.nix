# home/firefox.nix
{ pkgs, ... }:

# Firefox GNOME theme fetched from upstream GitHub repo
let
	themeSrc = pkgs.fetchFromGitHub {
		owner = "rafaelmardojai";
		repo = "firefox-gnome-theme";
		rev = "master";
		sha256 = "KJjs4BdQ03X4jcc/aAcjO0PwHaYUYBAb6UIIL5fFslY=";
	};
	
in
{
	programs.firefox = {
		enable = true;
		
		profiles.default-release = {
			isDefault = true;
			id = 0;
			
			# Inject GNOME visual theme and override snippets
			userChrome = ''
			  @import "firefox-gnome-theme/userChrome.css";
			'' + (import ./firefox-overrides.userChrome.nix);
			
			userContent = ''
				@import "firefox-gnome-theme/userContent.css";
			'';
      
	  		# Enable custom theming and tweak default behaviors
			settings = {
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				"svg.context-properties.content.enabled" = true;
				"browser.tabs.drawInTitlebar" = true;
				"gnomeTheme.hideSingleTab" = false;
				"gnomeTheme.oledBlack" = false;
			};
		};
	};

	home = {
		file = {
			# Symlink theme files into chrome directory
			".mozilla/firefox/default-release/chrome/firefox-gnome-theme" = {
				source = themeSrc;
			};
			
			# Override default desktop entry to explicitly set mime types
			".local/share/applications/firefox.desktop".text = ''
				[Desktop Entry]
				Name=Firefox
				Exec=firefox %u
				Icon=firefox
				Type=Application
				Categories=GNOME;GTK;Network;WebBrowser;
				MimeType=x-scheme-handler/http;x-scheme-handler/https;
				StartupNotify=true
				Terminal=false
			'';
		};
	};
	
	# Set Firefox as default handler for web and markup content
	xdg.mimeApps.defaultApplications = {
    		"text/html" = ["firefox.desktop"];
    		"text/xml" = ["firefox.desktop"];
    		"x-scheme-handler/http" = ["firefox.desktop"];
    		"x-scheme-handler/https" = ["firefox.desktop"];
  	};
}

