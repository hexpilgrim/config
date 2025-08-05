# overlays/lyricsPlus.nix
system: self: super: {
  lyricsPlus = super.stdenv.mkDerivation {
    name = "lyricsPlus";

    src = super.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "main";
      sha256 = "9rX3jifEmGL1ewiTu3DoUYI/u8Osl1wVSo+9yWH+J8I=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r $src/CustomApps/lyrics-plus/* $out/
    '';
  };
}
