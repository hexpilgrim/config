# modules/scripts/git-wrapper.nix
{
  lib,
  ...
}:

{
  # Override 'git' behavior with custom shell logic:
  # • Pull from all Git repos in current directory (non-recursive)
  # • List unique remote URLs from each Git repo
  # • If no arguments are given, use the default git command
  programs.bash.shellInit = lib.strings.concatStringsSep "\n" [
    ''
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
