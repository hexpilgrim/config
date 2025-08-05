# overlays/newReleases.nix
system: self: super: {
  # Patch New Releases app for full asset exposure
  newReleases = super.stdenv.mkDerivation {
    name = "newReleases";

    # Pin source from Spicetify CLI repo (ensure this stays in sync with app expectations)
    src = super.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "main";
      sha256 = "9rX3jifEmGL1ewiTu3DoUYI/u8Osl1wVSo+9yWH+J8I=";
    };

    # Install full contents of new-releases app
    installPhase = ''
      mkdir -p $out
      cp -r $src/CustomApps/new-releases/* $out/
    '';
  };
}
