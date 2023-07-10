{ inputs, outputs, lib, config, pkgs, ... }:

{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      (_: prev:
        {
          awesome =

            let
              extraGIPackages = with prev; [ networkmanager upower playerctl ];
            in

            (prev.awesome.override { gtk3Support = true; lua = prev.luajit; }).overrideAttrs (_: {
              version = "luajit-999-master";

              src = inputs.awesome-git;
              patches = [ ];

              postPatch = ''
                patchShebangs tests/examples/_postprocess.lua
                patchShebangs tests/examples/_postprocess_cleanup.lua
              '';

              GI_TYPELIB_PATH =
                let
                  mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
                  extraGITypeLibPaths = prev.lib.forEach extraGIPackages mkTypeLibPath;
                in
                prev.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [ (mkTypeLibPath prev.pango.out) ]);
            });
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
