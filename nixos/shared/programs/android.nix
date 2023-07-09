{ inputs, outputs, lib, config, pkgs, ... }:

{

  programs.adb.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  users.users.javacafe01.extraGroups = [ "adbusers" ];
  virtualisation.libvirtd.enable = true;
}
