{ ... }:

{
  services.xserver = {
    enable = true;

    xkb = {
      layout = "gb";
      variant = "";
    };

    # libinput.enable = true;
  };
}
