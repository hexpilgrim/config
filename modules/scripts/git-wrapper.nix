# modules/scripts/git-wrapper.nix
{ lib, ... }:

{
  programs.bash.shellInit = lib.strings.concatStringsSep "\n" [
    ''
      # Wrapper function for nixos-rebuild that injects IS_LOCAL_BUILD=1
      nixos-rebuild() {
        IS_LOCAL_BUILD=1 command nixos-rebuild "$@"
      }

      # Wrapper function for sudo nixos-rebuild with IS_LOCAL_BUILD=1
      snixos-rebuild() {
        sudo IS_LOCAL_BUILD=1 nixos-rebuild "$@"
      }
    ''
    ''
      # Override git command with custom behavior
      git() {
        if [[ "$1" == "pull" && "$2" == "all" ]]; then
          find . -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            if [ -d "$dir/.git" ]; then
              echo "Pulling $dir"
              git -C "$dir" pull
            fi
          done

        elif [[ "$1" == "pull" && "$2" == "url" ]]; then
          find . -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            if [ -d "$dir/.git" ]; then
              pushd "$dir" >/dev/null || continue
              echo "Remotes in $dir:"
              git remote -v | awk '{print $2}' | sort -u
              popd >/dev/null || true
            fi
          done

        else
          command git "$@"
        fi
      }
    ''
  ];
}
