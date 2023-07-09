{ config, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = false;
    shadow = false;

    settings = {
      enable-fading-next-tag = true;
      unredir-if-possible = true;
    };
  };
}
