# modules/users.nix
{
  user,
  ...
}:

{
  users.users.${user.username} = {
    isNormalUser = true;
    description = user.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "users"
    ];
  };
}
