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
    inputs.chaotic.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
    ../shared/configuration.nix
    ../shared/programs/steam.nix
    ../shared/programs/pio.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../shared/desktops/awesome.nix
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
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    supportedFilesystems = [ "ntfs" ];
  };

  chaotic.steam.extraCompatPackages = with pkgs; [ proton-ge-custom ];

  environment = {
    systemPackages = lib.attrValues {
      inherit (pkgs)
        acpi
        liquidctl
        pciutils
        radeontop;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };

    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
  };

  networking = {
    hostName = "tritonpc";
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

    xserver = {
      dpi = 96;
      videoDrivers = [ "amdgpu" ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;
}
