{ config, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = false;
    shadow = false;
    shadowOffsets = [ (-10) (-10) ];
    shadowOpacity = 0.8;

    settings = {
      enable-fading-next-tag = true;
      shadow-radius = 10;
    };
  };
}
