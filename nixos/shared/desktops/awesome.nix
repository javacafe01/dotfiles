{ inputs, outputs, lib, config, pkgs, ... }:

{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      (_: _:
        {
          awesome = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-luajit-git;
        })
    ];
  };

  environment = {
    systemPackages = lib.attrValues {
      inherit (pkgs)
        brightnessctl
        inotify-tools
        libnotify
        pavucontrol
        skippy-xd
        xlockmore;
    };
  };

  programs = {
    nm-applet = {
      enable = true;
      indicator = false;
    };

    thunar = {
      enable = true;

      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    xss-lock = {
      enable = true;
      lockerCommand = "${pkgs.xlockmore}/bin/xlock -mode dclock";
    };
  };

  security.pam.services.lightdm.enableGnomeKeyring = true;

  services = {
    blueman.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      displayManager = {
        autoLogin = {
          enable = false;
          user = "javacafe01";
        };

        defaultSession = "none+awesome";

        lightdm = {
          enable = true;
          greeters.gtk.enable = true;
        };
      };

      windowManager = {
        awesome = {
          enable = true;

          luaModules = lib.attrValues {
            inherit (pkgs.luajitPackages) lgi ldbus luadbi-mysql luaposix;
          };
        };
      };
    };
  };
}
