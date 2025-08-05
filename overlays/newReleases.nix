# overlays/newReleases.nix
system: self: super: {
  newReleases = super.stdenv.mkDerivation {
    name = "newReleases";

    src = super.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "main";
      sha256 = "9rX3jifEmGL1ewiTu3DoUYI/u8Osl1wVSo+9yWH+J8I=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r $src/CustomApps/new-releases/* $out/
    '';
  };
}
