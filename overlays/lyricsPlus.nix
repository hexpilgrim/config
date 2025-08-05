# overlays/lyricsPlus.nix
system: self: super: {
  # Patch Lyrics Plus app for full asset inclusion
  lyricsPlus = super.stdenv.mkDerivation {
    name = "lyricsPlus";

    # Pin source from Spicetify CLI repo (ensure this stays in sync with app expectations)
    src = super.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "main";
      sha256 = "9rX3jifEmGL1ewiTu3DoUYI/u8Osl1wVSo+9yWH+J8I=";
    };

    # Install full contents of lyrics-plus app
    installPhase = ''
      mkdir -p $out
      cp -r $src/CustomApps/lyrics-plus/* $out/
    '';
  };
}
