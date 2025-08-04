# home/gaming.nix
{
  pkgs,
  ...
}:

{
  # Force RADV Vulkan driver for AMD GPUs
  home.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
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
