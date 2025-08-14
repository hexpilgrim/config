# overlays/lyricsPlus.nix
system: self: super: {
  lyricsPlus = super.stdenv.mkDerivation {
    name = "lyricsPlus";

    src = super.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "702e027fde6edf2ccd30ef97cb92a44f42a95c6c";
      sha256 = "GkJjqas+DTh8jJhOyY6RtxkkYs1CHH1ngD8kahpbD4k=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r $src/CustomApps/lyrics-plus/* $out/
    '';
  };
}
