{ ... }:

{
  users.users.james = {
    isNormalUser = true;
    description = "James";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
