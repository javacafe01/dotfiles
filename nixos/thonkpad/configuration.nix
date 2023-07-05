# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-extreme-gen4

    # You can also split up your configuration and import pieces of it here:
    ../shared/configuration.nix
    ../shared/desktops/plasma.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nixpkgs-f2k.overlays.stdenvs

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (_: prev:
        {
          vaapiIntel = prev.vaapiIntel.override { enableHybridCodec = true; };
        })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mem_sleep_default=deep" ];
    kernelModules = [ "iwlwifi" ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        consoleMode = "1";
      };
    };

    # resumeDevice = "/dev/nvme0n1p6";
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  };

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      acpi
      nvtop-nvidia
      pciutils;
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };

    enableRedistributableFirmware = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement = { enable = true; finegrained = true; };

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        reverseSync.enable = true;
      };
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = lib.attrValues {
        inherit (pkgs)
          intel-compute-runtime
          intel-media-driver
          vaapiIntel
          vaapiVdpau
          vulkan-tools
          libvdpau-va-gl;
      };
    };

    sensor.iio.enable = true;
  };

  networking = {
    hostName = "thonkpad";
    networkmanager.enable = true;
    useDHCP = false;
  };

  programs.dconf.enable = true;

  services = {
    acpid.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    fwupd.enable = true;
    udev.packages = [ pkgs.platformio ];

    xserver = {
      dpi = 168;

      libinput = {
        enable = true;
        touchpad = { naturalScrolling = true; };
      };

      videoDrivers = [ "nvidia" ];
    };

    thermald.enable = true;

    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };

    upower.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;
}
