# modules/scripts/unzip.nix
{
  lib,
  ...
}:

{
  # Override 'unzip' behavior with custom shell logic:
  # • Unzip all .zip files in the current directory into their own folders
  # • If no arguments are given, unzip all .zip files
  # • If an argument is given, use the default unzip command
  programs.bash.shellInit = lib.strings.concatStringsSep "\n" [
    ''
      unzip() {
        if [[ "$1" == "all" ]]; then
          for zipfile in *.zip; do
            [ -e "$zipfile" ] || continue
            foldername=$(basename "$zipfile" .zip)
            echo "Unzipping '$zipfile' into folder: '$foldername'"
            mkdir -p "$foldername"
            command unzip -q "$zipfile" -d "$foldername"
          done
        else
          echo "Unzipping individual file: $*"
          command unzip "$@"
        fi
      }
    ''
  ];
}
