# flake.nix
{
  description = "hexpilgrim: a nixos configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nur.url = "github:nix-community/NUR";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    disko.url = "github:nix-community/disko";
    nix-index.url = "github:nix-community/nix-index";
    catppuccin.url = "github:catppuccin/nix";
    #lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    #infra.url = "github:nix-community/infra";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      _module.args = {
        inputFollows = {
          home-manager = "nixpkgs";
          nur = "nixpkgs-unstable";
          chaotic = "nixpkgs-unstable";
          spicetify-nix = "nixpkgs-unstable";
          umu = "nixpkgs-unstable";
          nix-gaming = "nixpkgs-unstable";
          disko = "nixpkgs-unstable";
          nix-index = "nixpkgs-unstable";
          catppuccin = "nixpkgs-unstable";
          #lanzaboote = "nixpkgs";
          #infra = "nixpkgs-unstable";
        };
      };

      imports = [ ./outputs.nix ];
    };
}
