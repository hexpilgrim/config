# dev/nodejs.nix
{ pkgs, nodeVersion ? pkgs.nodejs_24 }:

pkgs.mkShell {
  buildInputs = [
    nodeVersion
    pkgs.nodePackages.npm
    pkgs.nodePackages.yarn
  ];

  shellHook = ''
    echo "Node.js (${nodeVersion.version or "default"}) dev shell activated."
    export NODE_ENV=development
  '';
}
