{ inputs, outputs, lib, config, pkgs, ... }:

{
  environment = {
    systemPackages = lib.attrValues {
      inherit (pkgs)
        brightnessctl
        inotify-tools
        libnotify
        pavucontrol
        rounded-sbe;

      inherit (pkgs.libsForQt5)
        plasma-applet-caffeine-plus;
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  services = {
    blueman.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        plasma5.enable = true;
        runUsingSystemd = true;
      };

      displayManager = {
        autoLogin = {
          enable = false;
          user = "javacafe01";
        };

        sddm.enable = true;
      };
    };
  };
}
