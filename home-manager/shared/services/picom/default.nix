{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    shadow = false;

    settings = {
      enable-fading-next-tag = true;
      unredir-if-possible = true;
    };
  };
}
