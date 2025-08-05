# home/firefox.nix
{ pkgs, ... }:

let
  themeSrc = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "6f173d0873dd33c5653dee89a831af3e49db3e36";
    sha256 = "sha256-9veVYpPCwKNjIK5gOigl5nEUN6tmrSHXUv4bVZkRuOE=";
  };
in
{
  programs.firefox.enable = true;

  programs.firefox.profiles.default-release = {
    isDefault = true;
    id = 0;

    # Inject GNOME visual theme and override snippets
    userChrome = ''
      @import "firefox-gnome-theme/userChrome.css";
    ''
    + (import ./firefox-overrides.userChrome.nix);

    userContent = ''
      @import "firefox-gnome-theme/userContent.css";
    '';

    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "browser.tabs.drawInTitlebar" = true;
      "gnomeTheme.hideSingleTab" = false;
      "gnomeTheme.oledBlack" = false;
    };
  };

  home.file = {
    ".mozilla/firefox/default-release/chrome/firefox-gnome-theme" = {
      source = themeSrc;
    };

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

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
