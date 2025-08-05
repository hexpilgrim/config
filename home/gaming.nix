# home/gaming.nix
{ pkgs, ... }:

{
  home.sessionVariables = {
    AMD_VULKAN_ICD = "RADV"; # Force RADV Vulkan driver for AMD GPUs
  };

  home.packages = with pkgs; [
    lutris
    mangohud
    gamescope
    protonplus
    mangojuice
    heroic
  ];
}
